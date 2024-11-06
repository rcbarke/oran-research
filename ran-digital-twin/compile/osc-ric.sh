#!/bin/bash
#
# osc-ric.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Builds the OSC RIC on the local machine and updates its private IP subnet range.
#
# Takes two CLI arguments... RIC_NETADDR and RIC_SUBNET_MASK.
#
# Leverages arguments to update all IPs to the given RIC_NETADDR.
#

# Function to display usage information
usage() {
    echo "Usage: $0 <RIC_NETADDR> <RIC_SUBNET_MASK>"
    echo ""
    echo "Arguments:"
    echo "  RIC_NETADDR     The network address for the RIC."
    echo "  RIC_SUBNET_MASK The subnet mask for the RIC."
    exit 1
}

# Check if two arguments are provided
if [[ $# -ne 2 ]]; then
    echo "Error: Invalid number of arguments."
    usage
fi

# Input variables
RIC_NETADDR=$1
RIC_SUBNET_MASK=$2

# Function to mask the network address based on the subnet mask
mask_network_address() {
    local addr_octets=(${RIC_NETADDR//./ })  # Split RIC_NETADDR into octets
    local mask_octets=(${RIC_SUBNET_MASK//./ })  # Split RIC_SUBNET_MASK into octets

    local result=""
    for i in {0..3}; do
        # Apply bitwise AND between each octet of address and subnet mask
        masked_octet=$(( ${addr_octets[$i]} & ${mask_octets[$i]} ))
        
        # Append non-zero octets to the result string
        if [ "$masked_octet" -ne 0 ]; then
            result+="$masked_octet."
        fi
    done

    # Output the result string (with trailing dot)
    echo "$result"
}

# Call the masking function and store the result
masked_address=$(mask_network_address)

# Check if the oran-sc-ric directory exists, and if so, skip cloning
if [ -d "./oran-sc-ric" ] && [ "$(ls -A ./oran-sc-ric)" ]; then
    echo "OSC RIC directory already exists and is not empty. Skipping clone."
else
    # If the directory does not exist or is empty, proceed with cloning
    if [ -d "./oran-sc-ric" ]; then
        echo "OSC RIC directory exists but is empty. Proceeding with clone."
        rm -rf ./oran-sc-ric  # Clean up the empty directory
    fi
    
    echo "Cloning OSC RIC..."
    git clone https://github.com/srsran/oran-sc-ric
fi

# Proceed with updating IP addresses if the directory exists
if [ -d "./oran-sc-ric" ]; then
    cd ./oran-sc-ric
    
    # Replace IP addresses within the repository files
    FILES_TO_UPDATE="$(git grep -l "10.0.2.")"
    if [ -n "$FILES_TO_UPDATE" ]; then  
       echo "$FILES_TO_UPDATE" | xargs sed -i "s/10.0.2./${masked_address}/g"
       echo "Modified RIC IPs to $RIC_NETADDR $RIC_SUBNET_MASK..."
    fi;
    
    echo "OSC RIC build completed"
    
    # Return to the previous directory
    cd ..
    
    echo "Staging Clemson xApps into RIC..."
    cp -r ./cu_xApps/* ./oran-sc-ric/xApps/python/
    echo "Clemson xApps successfully staged"
else
    echo "Error: OSC RIC repository not found after clone attempt."
    exit 1
fi
