#!/bin/bash
#
# build-digital-twin.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Automated RAN Digital Twin simulation containing the following software stack:
#
# Architecture:
# 1. Open5GS 5GC Core: MME/AMF/SGW/PGW
# 2. Modified OSC RIC: Supports machine virtualization
# 3. srsProject srsgNB: Disaggregated CU/DU gNB
# 4. srs4G srsUE: Multiple dedicated UE instances
#
# Signal Modulation:
# - gnuradio: Modulated RF waveform for all UEs
#
# Provided xApps:
# 1. kpimon: Performance metric monitoring at core within shell terminal
# 2. grafana: Performance metric monitoring at gNB within firefox
#
# Script flow:
# To be documented upon completion.
# 
# Pre-Conditions and Assumptions:
# 1. This script works by assuming the host machine's IP will be statically assigned in a private IP subnet. The default address range is 10.0.2.0/24. If this will create a network conflict, it can be overridden with the -hostip commmand, which will automatically infer /24 subnets.
# 2. The private subnets indicated at the top of the file are reserved for docker applications contained within this script. They cannot be in use anywhere else on the private network, else the RAN digital twin will fail.
#
# Optional CLI arguments (see usage below):
# 1. mode: Enables or disables the build of the 5G core, RIC, and gNB. gNB at the edge is not # currently supported. Default = core.
# 2. hostip: Overrides the default host machine IP to configure with the IP address specified.
# Default = CORE_RAN_IP.

# Mode
MODE="core" # Setup core RAN by default
BUILD_SRSP="T" # Build srsProject by default

# Host IP configuration
CORE_RAN_IP="10.0.2.15"
UE_NODE_IP="10.0.2.100"
HOST_IP=${CORE_RAN_IP} # Setup core RAN by default
DEFAULT_NETMASK="255.255.255.0"
DEFAULT_GATEWAY="10.0.2.1"
DEFAULT_DNS="8.8.8.8"
INTERFACE=""  # Default empty, will be set if provided by -int flag

# Private Application IPs. If any of these are changed, destruct-digital-twin.sh must run 
# to destroy docker bridged adapters at this address range. Modifying this section is not
# recommended.
RIC_NET_ADDR="192.168.63.0"
RIC_NETMASK="255.255.255.0"
UE_NET_ADDR="10.45.1.0"
UE_NETMASK="255.255.255.0"

# Default values for UE-related flags
TOTAL_UES=3       # Total number of UEs across the network
LOCAL_UES=""     # Number of UEs on this machine, will be set after parsing flags.
UE_START_IDX=1    # Starting index of UEs on this machine. One based indexing.

# Define valid flags
VALID_FLAGS=("-debug" "-mode" "-hostip" "-int" "-srsP" "-ue" "-ue_local" "-ue_idx")
DEBUG_MODE=false

# Function to display usage information
usage() {
    echo "Usage: $0"
    echo "Optional flags:"
    echo "  -debug Prints all runtime options if specified."
    echo "  -mode [core|edge] Specify whether to configure a core or edge network VM."
    echo "  -hostip <ip_address>  Specify the static IP for the host machine."
    echo "  -int <iface> Specify the network interface to configure static IP."
    echo "  -srsP [T|F] Specify whether or not to build srsRAN Project from source."
    echo "  -ue Specify the total amount of UEs to build across the network. Default 3."
    echo "  -ue_local Specify the amount of UEs to build on this machine. Must be <= total UEs. Default total UEs."
    echo "  -ue_idx Specify the starting index of the UEs on this machine. Cannot overlap with remote server if multiple machines are used. Default 1. Cannot specify 0."
    exit 1
}

# Function to validate CLI input
validate_cli() {
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -hostip)
                if [[ -n "$2" && ! "$2" =~ ^- ]]; then
                    HOST_IP="$2"
                    shift 2
                else
                    echo "Error: -hostip flag requires an argument."
                    usage
                fi
                ;;
            -mode)
                if [[ "$2" == "core" || "$2" == "edge" ]]; then
                    MODE="$2"
                    shift 2
                else
                    echo "Error: -mode flag requires either 'core' or 'edge'."
                    usage
                fi
                ;;
            -int)
                if [[ -n "$2" && ! "$2" =~ ^- ]]; then
                    INTERFACE="$2"
                    shift 2
                else
                    echo "Error: -int flag requires an argument."
                    usage
                fi
                ;;
            -ue)
                if [[ -n "$2" && "$2" =~ ^[0-9]+$ ]]; then
                    TOTAL_UES="$2"
                    shift 2
                else
                    echo "Error: -ue flag requires a numeric argument."
                    usage
                fi
                ;;
            -ue_local)
                if [[ -n "$2" && "$2" =~ ^[0-9]+$ && "$2" -le "$TOTAL_UES" ]]; then
                    LOCAL_UES="$2"
                    shift 2
                else
                    echo "Error: -ue_local flag requires a numeric argument that is <= total UEs."
                    usage
                fi
                ;;
            -ue_idx)
                if [[ -n "$2" && "$2" =~ ^[0-9]+$ && "$2" -ge 1 ]]; then
                    UE_START_IDX="$2"
                    shift 2
                else
                    echo "Error: -ue_idx flag requires a numeric argument >= 1."
                    usage
                fi
                ;;
            -srsP)
                if [[ "$2" == "T" || "$2" == "F" ]]; then
                    BUILD_SRSP="$2"
                    shift 2
                else
                    echo "Error: -srsP flag requires 'T' (true) or 'F' (false)."
                    usage
                fi
                ;;
            -debug)
                DEBUG_MODE=true
                shift
                ;;
            *)
                echo "Error: Unknown flag '$1'."
                usage
                ;;
        esac
    done
}

# Function to validate the host OS
validate_os() {
    # Get the distribution name and release version
    os_name=$(lsb_release -si)
    os_version=$(lsb_release -sr)

    # Check if the OS is Ubuntu and the version is 22.04 (any subversion)
    if [ "$os_name" != "Ubuntu" ] || [[ "$os_version" != 22.04* ]]; then
        echo "Error: This script requires Ubuntu 22.04. Detected OS: $os_name $os_version."
        exit 1
    fi

    echo "OS validation passed: $os_name $os_version."
}

# Function to check if IP and subnet are available
check_ip_availability() {
    echo "Checking if IP address $HOST_IP is available..."

    # Check if the IP is already assigned to the host machine
    if ip a | grep -q "$HOST_IP"; then
        echo "The IP address $HOST_IP is already assigned to this machine. Proceeding..."
    else
        # Ping the IP address to check if it is in use by another device on the network
        ping -c 1 -W 1 "$HOST_IP" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "Error: IP address $HOST_IP is already in use by another device on the network."
            exit 1
        else
            echo "The IP address $HOST_IP is available."
        fi
    fi

    # Extract the network part of the subnet (first three octets) for subnet validation
    echo "Checking if subnet $SUBNET is available..."
    SUBNET_IN_USE=false

    # Loop through the configured interfaces and check if the subnet is already in use
    while read -r line; do
        CONFIGURED_IP=$(echo "$line" | awk '{print $2}' | cut -d'/' -f1)  # Get IP address from output
        IFS='.' read -r -a config_ip_parts <<< "$CONFIGURED_IP"  # Split configured IP into parts
        CONFIGURED_SUBNET="${config_ip_parts[0]}.${config_ip_parts[1]}.${config_ip_parts[2]}.0/24"

        # Check if the subnet matches the one we're trying to configure
        if [ "$CONFIGURED_SUBNET" == "$SUBNET" ]; then
            echo "Subnet $SUBNET is already in use on this machine (interface: $line)."
            SUBNET_IN_USE=true
        fi
    done <<< "$(ip a | grep inet | grep -v '127.0.0.1')"  # Ignore loopback interface

    # If the subnet is not in use on the host, check the gateway or other devices
    if [ "$SUBNET_IN_USE" = false ]; then
        GATEWAY_IP="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.1"
        echo "Pinging gateway $GATEWAY_IP to check for other devices on the subnet..."
        ping -c 1 -W 1 "$GATEWAY_IP" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "Warning: Gateway $GATEWAY_IP is reachable. Ensure no conflicts exist on this subnet."
        else
            echo "Subnet $SUBNET is available."
        fi
    fi

    echo "IP address and subnet validation complete. Proceeding with the configuration..."
}

# Function to configure static IP
configure_static_ip() {
    echo "Configuring static IP address $HOST_IP with subnet $SUBNET..."

    # Check if the user specified an interface via the -int flag
    if [ -n "$INTERFACE" ]; then
        # Validate if the specified interface exists
        if ! ip link show "$INTERFACE" > /dev/null 2>&1; then
            echo "Error: Network interface '$INTERFACE' does not exist."
            exit 1
        fi
    else
        # Find an active interface with an IP address (excluding loopback) if no interface is specified
        INTERFACE=$(ip -o -4 addr show | awk '!/127.0.0.1/ {print $2; exit}')
        if [ -z "$INTERFACE" ]; then
            echo "Error: Could not find an active network interface."
            exit 1
        fi
    fi

    echo "Using network interface: $INTERFACE"

    # Bring the interface down, configure the IP, and bring it up
    sudo ip addr flush dev $INTERFACE
    sudo ip addr add $HOST_IP/$DEFAULT_NETMASK dev $INTERFACE
    sudo ip link set $INTERFACE up

    # Configure the default gateway
    sudo ip route add default via $DEFAULT_GATEWAY dev $INTERFACE

    # Update /etc/resolv.conf for DNS settings
    echo "nameserver $DEFAULT_DNS" | sudo tee /etc/resolv.conf > /dev/null

    echo "Static IP configuration completed successfully."
}

# Function to build dependencies based on the provided component
build_dependencies() {
    component=$1

    case "$component" in
        "os") 
            echo "Building dependencies for OS.."
            sudo apt-get install vim-gtk meld net-tools xterm dbus-x11 iperf iperf3 curl
            for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
            sudo apt-get update
            sudo apt-get install ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc
            echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
            sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        "srs_project")   
            echo "Building dependencies for srsRAN Project: 5G Protocol stack..."
            sudo apt-get install libzmq3-dev
            sudo apt-get install cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev
            ;;
        "osc-ric")
            echo "Building dependencies for OSC RIC..."
            ;;
        "open5gs")   
            echo "Building dependencies for Open5GS 5GC Core: MME/AMF/SGW/PGW..."
            sudo apt-get install libzmq3-dev
            sudo apt-get install cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev
            ;;
        "osc-ric")
            echo "Building dependencies for OSC RIC..."
            ;;
        "srsgnb")
            echo "Building dependencies for srsProject srsgNB: Disaggregated CU/DU gNB..."
            sudo apt-get install libzmq3-dev
            sudo apt-get install cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev
            ;;
        "srsue")
            echo "Building dependencies for srs4G srsUE..."
            # Insert the commands to build dependencies for srsUE
            ;;
        "gnuradio")
            echo "Building dependencies for GNU Radio: Modulated RF waveform for all UEs..."
            sudo apt-get install xterm #defensive programming
            ;;
        "kpimon")
            echo "Building dependencies for KPIMon xApp: Performance metric monitoring at core..."
            # Insert the commands to build dependencies for KPIMon
            ;;
        "grafana")
            echo "Building dependencies for Grafana xApp: Performance metric monitoring at gNB..."
            # Insert the commands to build dependencies for Grafana
            ;;
        *)
            echo "Error: Invalid component '$component'. Please specify a valid component."
            echo "Valid components are: open5gs, osc-ric, srsgnb, srsue, gnuradio, kpimon, grafana."
            exit 1
            ;;
    esac
}

#            gnome-terminal --tab --title="Open5GS Build" -- bash -c "echo 'Building #Open5GS...'; ./build/open5gs.sh; exec bash"

# Function to build component based on the provided component
build_component() {
    component=$1

    case "$component" in
        "srs_project")
            SRSBUILD="./srsRAN_Project/build"
            if [[ $SRSBUILD == "T" || ! -d "$SRSBUILD" || -z "$(ls -A "$SRSBUILD" 2>/dev/null)" ]]; then
                # Force build, build folder does not exist, or build folder is empty
                echo "Building component for srsRAN Project: 5G Protocol stack..."
                ./compile/srs_project.sh
            fi
            ;;
        "open5gs")
            echo "Building component for Open5GS 5GC Core: MME/AMF/SGW/PGW..."
            echo "Calling ./compile/open5gs.sh with TOTAL_UES=$TOTAL_UES $UE_START_IDX"
            ./compile/open5gs.sh $TOTAL_UES $UE_START_IDX
            ;;
        "osc-ric")
            echo "Building component for OSC RIC..."
            ./compile/osc-ric.sh $RIC_NET_ADDR $RIC_NETMASK
            ;;
        "srsgnb")
            echo "Building component for srsProject srsgNB: Disaggregated CU/DU gNB..."
            ./compile/srsgnb.sh $RIC_NET_ADDR
            ;;
        "srsue")
            echo "Building component for srsUE..."
            ./compile/srsue.sh $LOCAL_UES $UE_START_IDX
            ;;
        "gnuradio")
            echo "Building component for GNU Radio: Modulated RF waveform for all UEs..."
            ./compile/gnuradio.sh
            ;;
        "kpimon")
            echo "Building component for KPIMon xApp: Performance metric monitoring at core..."
            echo "Built with osc-ric"
            ;;
        "grafana")
            echo "Building dependencies for Grafana xApp: Performance metric monitoring at gNB..."
            echo "Built with srsProject"
            ;;
        *)
            echo "Error: Invalid component '$component'. Please specify a valid component."
            echo "Valid components are: open5gs, osc-ric, srsgnb, srsue, gnuradio, kpimon, grafana."
            exit 1
            ;;
    esac
}


# ----------------- Main Script -----------------

echo "---------------------------------------------------------------------"
echo "--------------------- build-digital-twin.sh -------------------------"
echo "---------------------------------------------------------------------"
echo ""

# Parse command-line arguments
validate_cli "$@"  # Pass all arguments to the validate_cli function

# Set LOCAL_UES to TOTAL_UES if -ue_local is not provided
if [[ -z "$LOCAL_UES" ]]; then
    LOCAL_UES=$TOTAL_UES
fi

# Check if debug mode is enabled and print all runtime options
if [ "$DEBUG_MODE" = true ]; then
echo "----------------- Debugging enabled... -----------------"
    echo "Mode: $MODE"
    echo "Host IP: $HOST_IP"
    echo "Interface (null=active interface check): $INTERFACE"
    echo "Total UEs: $TOTAL_UES"
    echo "Local UEs: $LOCAL_UES"
    echo "UE Start Index: $UE_START_IDX"
fi

if [ "$LOCAL_UES" -gt "$TOTAL_UES" ]; then
    echo "Error: Local UEs cannot exceed total UEs."
    exit 1
fi

# Validate host OS
echo ""
echo ""
echo "----------------- Checking host OS and installing initial dependencies... -----------------"
echo ""
echo ""
validate_os
build_dependencies "os"

echo ""
echo ""
echo "----------------- Host ${MODE^^} machine IP configuration: $HOST_IP... -----------------"
echo ""
echo ""

# Extract the subnet from the provided IP address (/24 subnet)
IFS='.' read -r -a ip_parts <<< "$HOST_IP"
SUBNET="${ip_parts[0]}.${ip_parts[1]}.${ip_parts[2]}.0/24"

# Check if IP and subnet are available
check_ip_availability

# Configure the static IP
configure_static_ip

# Output the selected mode and host IP
echo ""
echo ""
echo "----------------- Building ${MODE^^} RAN Digital Twin -----------------"
echo ""
echo ""

if [ "$MODE" = "core" ]; then
   # Core RAN

   # srs_project
   app="srs_project" 
   echo "----- ${app} -----"
   build_dependencies "${app}"
   echo ""
   build_component "${app}"  
   echo ""

   # Open5GS
   app="open5gs" 
   echo "----- ${app} -----"
   build_dependencies "${app}"
   echo ""
   build_component "${app}"  
   echo ""

   # OSC RIC
   app="osc-ric" 
   echo "----- ${app} -----"
   build_dependencies "${app}"
   echo ""
   build_component "${app}"  
   echo ""

   # srsgnb
   app="srsgnb" 
   echo "----- ${app} -----"
   build_dependencies "${app}"
   echo ""
   build_component "${app}"  
   echo ""

   # srsue
   app="srsue" 
   echo "----- ${app} -----"
   build_dependencies "${app}"
   echo ""
   build_component "${app}"  
   echo ""
   
else
   # Edge RAN
   echo "Edge RAN: Currently unsupported..."
fi

echo ""
echo ""
echo "----------------- Build of ${MODE^^} RAN Digital Twin Complete -----------------"
echo ""
echo ""

