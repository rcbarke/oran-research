#!/bin/bash
#
# deploy-digital-twin.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory
# ORAN team
#
# Description:
# This script automates the deployment of a RAN (Radio Access Network) Digital Twin simulation. It initializes the software stack including Open5GS (5G core), OSC RIC (RAN Intelligent Controller), srsGNB (gNB CU/DU), and srsUE (UE instances), with RF signal modulation managed through GNU Radio.
#
# Architecture:
# 1. **Open5GS 5GC Core**: MME/AMF/SGW/PGW components to manage 5G core functionalities.
# 2. **OSC RIC**: Orchestration and control of the RAN through a modified RAN Intelligent Controller.
# 3. **srsGNB**: Disaggregated CU/DU gNB connected to both OSC RIC and Open5GS core.
# 4. **srsUE**: Multiple UE instances configured and managed in their own network namespaces.
#
# Signal Modulation:
# - **GNU Radio**: Modulates RF waveforms for all UEs.
#
# Provided xApps:
# 1. **KPIMon**: Core performance metric monitoring via terminal CLI.
# 2. **Grafana**: gNB performance metric monitoring via a web browser (Grafana dashboard).
#
# Script Flow:
# - Parses CLI arguments for deployment options (e.g., number of UEs, build options, xApp handling).
# - Automates the deployment of Open5GS core, OSC RIC, srsGNB, and UE instances in separate gnome-terminal tabs.
# - Optionally builds the environment before deployment and launches performance monitoring xApps (KPIMon and Grafana).
# - Guides the user through critical steps such as starting each component and ensuring proper connections.
#
# Pre-Conditions and Assumptions:
# 1. ./build-digital-twin.sh has been run successfully to deploy the environment.
# 2. The number of UEs is consistent with the amount currently built.
#
# Optional CLI Arguments:
# 3. **NUM_UES**: Specifies the number of UEs to deploy in the simulation. This argument is required and must be a whole number.
#
# Optional CLI Arguments:
# 1. **-b**: Runs the build script (`build-digital-twin.sh`) before deployment to prepare the environment.
# 2. **-xm**: Automatically deploys the monitoring xApps (KPIMon and Grafana) without prompting for user input.
#
# Example Usage:
# - **./deploy-digital-twin.sh -b 3**: Builds the environment and deploys a RAN simulation with 3 UEs.
# - **./deploy-digital-twin.sh -xm 3**: Deploys 3 UEs and automatically starts the xApps without user confirmation.
#
# Notes:
# - Each UE runs in its own network namespace to simulate multiple devices attaching to the network.
# - The script utilizes `gnome-terminal` to open separate tabs for each process, making it easier to manage the environment.

# Supress GTK error
export NO_AT_BRIDGE=1

# Function to check for required commands
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 could not be found. Please install it before running the script."
        exit 1
    fi
}

# Function to validate the CLI arguments
validate_cli() {
    build_flag=false
    xm_flag=false
    rm_flag=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            -b)
                build_flag=true
                shift
                ;;
            -xm)
                xm_flag=true
                shift
                ;;
            -rm)
                rm_flag=true
                shift
                ;;
            *)
                if [[ "$1" =~ ^[0-9]+$ ]]; then
                    num_ues=$1
                    shift
                else
                    echo "Error: The number of UEs must be a whole number."
                    exit 1
                fi
                ;;
        esac
    done

    if [[ -z "$num_ues" ]]; then
        echo "Usage: $0 [-b] [-xm] <NUM_UES>"
        exit 1
    fi
}

# Validate the CLI arguments
validate_cli "$@"

# If -b flag is provided, run the build script before deployment
if $build_flag; then
    echo "Building digital twin environment with ${num_ues} UEs..."
    ./build-digital-twin.sh -ue $num_ues
    if [[ $? -ne 0 ]]; then
        echo "Error: build-digital-twin.sh failed."
        exit 1
    fi
fi

# Check if gnome-terminal is installed
check_command gnome-terminal

echo "---------------------------------------------------------------------"
echo "--------------------- deploy-digital-twin.sh ------------------------"
echo "---------------------------------------------------------------------"
echo ""

# Step 1: Launch Open5GS 5G Core (5GC) in a new tab
gnome-terminal --tab --title="Open5GS 5GC" -- bash -c "cd srsRAN_Project/docker && echo 'Starting Open5GS 5G Core...' && sudo docker compose up --build 5gc; exec bash" 2>/dev/null

# Wait for Open5GS to finish building
echo "Waiting for Open5GS to build and run..."
echo "Press Enter when Open5GS is running and ready."
read -r

# Step 2: Launch OSC RIC in a new tab
gnome-terminal --tab --title="OSC RIC" -- bash -c "cd oran-sc-ric && echo 'Starting OSC RIC...' && sudo docker compose up; exec bash" 2>/dev/null

# Wait for OSC RIC to connect
echo "Waiting for OSC RIC to connect to Open5GS..."
echo "Press Enter once OSC RIC is connected and running."
read -r

# Step 3: Launch srsGNB in a new tab
gnome-terminal --tab --title="srsGNB" -- bash -c "cd srsRAN_Project/build/apps/gnb && echo 'Starting srsGNB...' && sudo ./gnb -c gnb_zmq.yaml; exec bash" 2>/dev/null

# Wait for gNB to connect to OSC RIC and Open5GS 5GC
echo "Waiting for gNB to connect..."
echo "Check the OSC RIC terminal for 'ric_rtmgr_sim POST /ric/v1/handles/associate-ran-to-e2t' message."
echo "Press Enter once gNB is connected and running."
read -r

# Function to check if namespace exists
check_namespace_exists() {
    if ip netns list | grep -q "$1"; then
        return 0    # Namespace exists
    else
        return 1    # Namespace does not exist
    fi
}

# Step 4: Deploy UEs in their own terminal tabs based on num_ues argument
for (( i=1; i<=num_ues; i++ )); do
    namespace="ue$i"
    
    # Check if namespace already exists
    if check_namespace_exists "$namespace"; then
        echo "Namespace $namespace already exists. Skipping creation."
    else
        echo "Creating namespace $namespace..."
        sudo ip netns add "$namespace"
    fi
   
    gnome-terminal --tab --title="UE $i" -- bash -c "
        cd srsRAN_4G/build/srsue/src &&
        echo 'Deploying UE$i...' &&
        sudo ./srsue ue${i}_zmq.conf &&
        echo 'UE$i deployed. Press Enter to keep this terminal open.' &&
        read -r
        exec bash
    " 2>/dev/null
done

# Wait for UEs to show "Attaching UE..."
echo "Waiting for UEs to attach to the gNB..."
echo "Check each UE terminal for the 'Attaching UE...' message."
echo "Press Enter once all UEs are attached."
read -r

# Step 5: Launch GNU Radio for modulation in a new tab
gnome-terminal --tab --title="GNU Radio" -- bash -c "
    cd srsRAN_4G/build/srsue/src &&
    echo 'Launching GNU Radio for modulation...' &&
    python3 multi_ue_scenario.py;
    exec bash
" 2>/dev/null

# Wait for user to click Play in GNU Radio
echo "Launch GNU Radio and ensure modulation has started..."
echo "Press Enter once GNU Radio is running and all UEs have connected to Open5GS."
read -r

# Set up ue tunneling now that modulation has started
echo "All UEs connected... configuring default routes for UEs" 

# Default route from UE subnet to AMF/MME
sudo ip ro add 10.45.0.0/16 via 10.53.1.2

# Route table adds for each UE namespace to core network
for (( i=1; i<=num_ues; i++ )); do
    namespace="ue$i"
    sudo ip netns exec "$namespace" ip route add default via 10.45.1.1 dev tun_srsue   
done

echo "Deployment complete! UEs should now be connected to the gNB, and the network is ready."
echo "You can now simulate traffic with iperf or other tools."

# Check if the -xm flag was provided to automatically run monitoring xApps
if $xm_flag; then
    echo "Starting monitoring xApps... KPIMon = RIC Monitoring, Grafana = RAN Monitoring..."
    ./cu_xApps/launch-monitoring-xApps.sh $num_ues
else
    # Prompt the user to run the monitoring xApps (KPIMon and Grafana)
    read -p "Would you like to start monitoring xApps (KPIMon and Grafana)? [Y/n]: " response

    # Default to 'y' if no response is provided
    response=${response:-y}

    # Convert response to lowercase for consistent comparison
    response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

    # If the response is 'y', run the monitoring-xApps.sh script
    if [[ "$response" == "y" ]]; then
        echo "Starting xApps... KPIMon = RIC Monitoring, Grafana = RAN Monitoring..."
        ./cu_xApps/launch-monitoring-xApps.sh $num_ues
    else
        echo "Skipping monitoring xApps."
    fi
fi

# Check if the -rm flag was provided to automatically run resource management xApps
if $rm_flag; then
    echo "Starting resource management xApp..."
    ./cu_xApps/launch-prb-xApp.sh
else
    # Prompt the user to run the monitoring xApps (KPIMon and Grafana)
    read -p "Would you like to start the resource management xApp? [Y/n]: " response

    # Default to 'y' if no response is provided
    response=${response:-y}

    # Convert response to lowercase for consistent comparison
    response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

    # If the response is 'y', run the monitoring-xApps.sh script
    if [[ "$response" == "y" ]]; then
        echo "Starting xApp..."
        ./cu_xApps/launch-prb-xApp.sh
        
        read -p "Would you like to start the resource management xApp? [Y/n]: " response
        
        # Default to 'y' if no response is provided
        response=${response:-y}
        
        # Convert response to lowercase for consistent comparison
        response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
        
        if [[ "$response" == "y" ]]; then
            echo "Starting dynamic deep reinforcement learning PRB allocation..."
            gnome-terminal --tab --title="GNU Radio" -- bash -c "
                cd rl_prb_allocation &&
                echo 'Launching dynamic DRL PRB allocation...' &&
                python3 main.py;
                exec bash
            " 2>/dev/null
        else
            echo "Skipping deep reinforcement learning algorithm."
        fi
    else
        echo "Skipping resource management xApps."
    fi
fi

echo ""
echo ""
echo "----------------- RAN Digital Twin Deployment Complete -----------------"
echo ""

