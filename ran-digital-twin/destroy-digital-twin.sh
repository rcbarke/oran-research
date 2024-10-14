#!/bin/bash
#
# destroy-digital-twin.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory
# ORAN team
#
# Description: Automated cleanup script for the RAN Digital Twin simulation environment. 
# This script destructively cleans up all resources associated with the RAN Digital Twin, 
# including Docker containers, Docker networks, namespaces, and relevant project directories.
#
# Cleaned Architecture Components:
# 1. Docker containers: Cleans up all containers created by Open5GS, OSC RIC, and other services.
# 2. Docker networks: Removes any non-default Docker networks created during the deployment.
# 3. Network namespaces: Removes namespaces for UEs created during the deployment (namespaces starting with "ue").
# 4. Project directories: Removes the following directories in the `ran-digital-twin` directory:
#    - srsRAN_Project
#    - srsRAN_4G
#    - oran-sc-ric
#
# Script Flow:
# - Prompts the user for confirmation before proceeding, as this action is destructive.
# - Stops and removes all Docker containers.
# - Removes non-default Docker networks.
# - Cleans up network namespaces starting with "ue".
# - Removes bridged network adapters (default: 10.53.1.0/24 for UEs and 192.168.63.0/24 for RIC).
# - Deletes the project directories mentioned above.
#
# Pre-Conditions and Assumptions:
# 1. This script assumes that the Docker environment and network configurations are not used for other critical services.
# 2. The user has sufficient privileges to delete Docker containers, networks, and namespaces.
# 3. This script is intended to clean up the resources specifically created by the RAN Digital Twin simulation.
#
# Example Usage:
# ./destroy-digital-twin.sh
#
# This example prompts the user for confirmation and then removes all relevant resources.
#
# Notes:
# - This script should be run after the simulation environment is no longer needed.
# - Re-running the build and deploy scripts will be required to restore the environment.

echo "---------------------------------------------------------------------"
echo "-------------------- destroy-digital-twin.sh ------------------------"
echo "---------------------------------------------------------------------"
echo ""

# Confirmation before proceeding
echo "WARNING: This script will destructively clean up all resources related to the RAN Digital Twin environment."
echo "All Docker containers, Docker networks, namespaces (starting with 'ue'), and project directories will be removed."
echo "You will need to re-run the build and deploy scripts if you wish to restore the environment."
read -p "Are you sure you want to proceed? (y/n): " confirmation

if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
    echo "Cleanup operation cancelled."
    exit 0
fi

# Function to check for required commands
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 could not be found. Please install it before running the script."
        exit 1
    fi
}

# Function to delete all non-default Docker containers
cleanup_docker_containers() {
    echo "Stopping and removing all non-default Docker containers..."
    docker ps -q | xargs -r docker stop  # Stop running containers
    docker ps -a -q | xargs -r docker rm  # Remove all containers
}

# Function to clean up all non-default Docker networks
cleanup_docker_networks() {
    echo "Removing non-default Docker networks..."
    default_networks=("bridge" "host" "none")
    docker network ls --format '{{.ID}} {{.Name}}' | while read -r id name; do
        if [[ ! " ${default_networks[@]} " =~ " ${name} " ]]; then
            echo "Removing network: $name ($id)"
            docker network rm "$id"
        fi
    done
}

# Function to clean up network namespaces (only those beginning with "ue")
cleanup_namespaces() {
    echo "Removing UE network namespaces..."
    for ns in $(ip netns list | grep '^ue'); do
        echo "Deleting namespace $ns"
        sudo ip netns del "$ns"
    done
}

# Function to clean up bridged network adapters
cleanup_bridged_network_adapters() {
    echo "Removing bridged network adapters..."
    adapters=("br-222ad3327a21" "br-3dc603795e56")
    for adapter in "${adapters[@]}"; do
        if ip link show "$adapter" &>/dev/null; then
            echo "Removing adapter $adapter..."
            sudo ip link set "$adapter" down
            sudo brctl delbr "$adapter"
        else
            echo "Adapter $adapter not found, skipping."
        fi
    done
}

# Function to clean up directories
cleanup_directories() {
    echo "Removing project directories..."
    rm -rf srsRAN_Project srsRAN_4G oran-sc-ric
}

# Check if Docker is installed
check_command docker

# Step 1: Clean up Docker containers
cleanup_docker_containers

# Step 2: Clean up non-default Docker networks
cleanup_docker_networks

# Step 3: Clean up network namespaces
cleanup_namespaces

# Step 4: Clean up bridged network adapters
cleanup_bridged_network_adapters

# Step 5: Remove directories
cleanup_directories

echo "---------------------------------------------------------------------"
echo "------------------- RAN Digital Twin Cleanup Complete ---------------"
echo "---------------------------------------------------------------------"

