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

# IP configuration
CORE_RAN_IP="10.0.2.15"
UE_NODE_IP="10.0.2.100"
HOST_IP=${CORE_RAN_IP} # Setup core RAN by default
DEFAULT_NETMASK="255.255.255.0"
DEFAULT_GATEWAY="10.0.2.1"
DEFAULT_DNS="8.8.8.8"
INTERFACE=""  # Default empty, will be set if provided by -int flag

# Define valid flags
VALID_FLAGS=("-mode" "-hostip" "-int")

# Function to display usage information
usage() {
    echo "Usage: $0 [-hostip <ip_address>]"
    echo "Optional flags:"
    echo "  -mode [core|edge] Specify whether to configure a core or edge network VM."
    echo "  -hostip <ip_address>  Specify the static IP for the host machine."
    echo "  -int <iface> Specify the network interface to configure static IP."
    exit 1
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
            sudo apt-get install vim-gtk meld net-tools iperf iperf3
            ;;
        "open5gs")   
            echo "Building dependencies for Open5GS 5GC Core: MME/AMF/SGW/PGW..."
            sudo apt-get install libzmq3-dev
            sudo apt-get install cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev
            ;;
        "osc-ric")
            echo "Building dependencies for OSC RIC..."
            # Insert the commands to build dependencies for OSC RIC
            ;;
        "srsgnb")
            echo "Building dependencies for srsProject srsgNB: Disaggregated CU/DU gNB..."
            sudo apt-get install libzmq3-dev
            sudo apt-get install cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev
            # Insert the commands to build dependencies for srsgNB
            ;;
        "srsue")
            echo "Building dependencies for srs4G srsUE..."
            # Insert the commands to build dependencies for srsUE
            ;;
        "gnuradio")
            echo "Building dependencies for GNU Radio: Modulated RF waveform for all UEs..."
            # Insert the commands to build dependencies for GNU Radio
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

# Function to build component based on the provided component
build_component() {
    component=$1

    case "$component" in
        "open5gs")
            echo "Building component for Open5GS 5GC Core: MME/AMF/SGW/PGW..."

            ;;
        "osc-ric")
            echo "Building component for OSC RIC..."

            ;;
        "srsgnb")
            echo "Building component for srsProject srsgNB: Disaggregated CU/DU gNB..."

            ;;
        "srsue")
            echo "Building dependencies for srs4G srsUE..."

            ;;
        "gnuradio")
            echo "Building dependencies for GNU Radio: Modulated RF waveform for all UEs..."

            ;;
        "kpimon")
            echo "Building dependencies for KPIMon xApp: Performance metric monitoring at core..."

            ;;
        "grafana")
            echo "Building dependencies for Grafana xApp: Performance metric monitoring at gNB..."

            ;;
        *)
            echo "Error: Invalid component '$component'. Please specify a valid component."
            echo "Valid components are: open5gs, osc-ric, srsgnb, srsue, gnuradio, kpimon, grafana."
            exit 1
            ;;
    esac
}


# ----------------- Main Script -----------------

# Parse command-line arguments
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
        *)
            # Check if the provided flag is in the list of valid flags
            if [[ ! " ${VALID_FLAGS[*]} " =~ " $1 " ]]; then
                echo "Error: Unknown flag '$1'."
                usage
            fi
            ;;
    esac
done

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

   # Open5GS
   app="open5gs" 
   echo "----- ${app} -----"
   build_dependencies "${app}"
   echo ""
   build_component "${app}"  
   echo ""

   
else
   # Edge RAN
   echo "Edge RAN"
fi

# Continue with the rest of your script here...

