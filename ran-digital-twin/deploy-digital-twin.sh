#!/bin/bash
#
# deploy-digital-twin.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory
# ORAN team
#
# Description: Automated deployment script for the RAN Digital Twin simulation. 
# This script initializes the software stack comprising Open5GS, OSC RIC, srsGNB, and srsUE components, with UE connections modulated via GNU Radio.
#
# Architecture:
# 1. Open5GS 5GC Core: MME/AMF/SGW/PGW (5G core)
# 2. OSC RIC: Orchestration and control via a modified RAN Intelligent Controller
# 3. srsGNB: Disaggregated CU/DU gNB connected to the OSC RIC and Open5GS
# 4. srsUE: Multiple UE instances, each running in its own network namespace
#
# Signal Modulation:
# - GNU Radio: Handles RF waveform modulation for all UEs
#
# Script Flow:
# - Takes the number of UEs as a CLI argument.
# - Launches Open5GS 5GC, OSC RIC, srsGNB, and deploys each UE in a separate terminal tab.
# - Prompts the user at critical steps to ensure each component is properly initialized before proceeding.
# - Handles synchronization between Open5GS, OSC RIC, srsGNB, and UEs.
# - Guides the user to launch GNU Radio for RF signal modulation and UE attachment.
#
# Pre-Conditions and Assumptions:
# 1. The user must have Docker, GNU Radio, and srsRAN installed and configured.
# 2. The user is running this script on a machine with static IP assignment and sufficient resources for virtualization.
# 3. The private IP subnets indicated by the simulation are reserved for Docker applications. Any conflict will cause the deployment to fail.
#
# Optional CLI Arguments:
# 1. -b: Runs the build script (build-digital-twin.sh) before deployment.
# 2. NUM_UES: Specify the total number of UEs to deploy. This argument is required and must be a whole number.
#
# Example Usage:
# ./deploy-digital-twin.sh -b 3
#
# This example builds the environment and deploys a network with 3 UEs.
#
# Notes:
# - Ensure each UE runs within its own network namespace before starting srsUE.
# - This script utilizes `gnome-terminal` for opening new tabs for each process.

# Function to check for required commands
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 could not be found. Please install it before running the script."
        exit 1
    fi
}

# Function to validate the CLI arguments
validate_cli() {
    if [[ $# -lt 1 || $# -gt 2 ]]; then
        echo "Usage: $0 [-b] <NUM_UES>"
        exit 1
    fi

    if [[ "$1" == "-b" ]]; then
        build_flag=true
        shift
    else
        build_flag=false
    fi

    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "Error: The number of UEs must be a whole number."
        exit 1
    fi

    num_ues=$1
}

# Validate the CLI arguments
validate_cli "$@"

# If -b flag is provided, run the build script before deployment
if $build_flag; then
    echo "Building digital twin environment..."
    ./build-digital-twin.sh
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
gnome-terminal --tab --title="Open5GS 5GC" -- bash -c "cd srsRAN_Project/docker && echo 'Starting Open5GS 5G Core...' && sudo docker compose up --build 5gc; exec bash"

# Wait for Open5GS to finish building
echo "Waiting for Open5GS to build and run..."
echo "Press Enter when Open5GS is running and ready."
read -r

# Step 2: Launch OSC RIC in a new tab
gnome-terminal --tab --title="OSC RIC" -- bash -c "cd oran-sc-ric && echo 'Starting OSC RIC...' && sudo docker compose up; exec bash"

# Wait for OSC RIC to connect
echo "Waiting for OSC RIC to connect to Open5GS..."
echo "Press Enter once OSC RIC is connected and running."
read -r

# Step 3: Launch srsGNB in a new tab
gnome-terminal --tab --title="srsGNB" -- bash -c "cd srsRAN_Project/build/apps/gnb && echo 'Starting srsGNB...' && sudo ./gnb -c gnb_zmq.yaml; exec bash"

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
    "
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
    sudo gnuradio-companion ./multi_ue_scenario.grc &&
    echo 'Click the Play button in GNU Radio to start modulation.'
    exec bash
"

# Wait for user to click Play in GNU Radio
echo "Launch GNU Radio and click 'Play' to start channel modulation."
echo "Press Enter once GNU Radio is running."
read -r

echo "Deployment complete! UEs should now be connected to the gNB, and the network is ready."
echo "You can now simulate traffic with iperf or other tools."

echo ""
echo ""
echo "----------------- RAN Digital Twin Deployment Complete -----------------"
echo ""

