#!/bin/bash
#
# srsue.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Generates srsUE configuration files based on the number of UEs and starting index passed in as arguments.
#

# Check for correct number of arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <NUM_UES> <START_INDEX>"
    exit 1
fi

# Arguments
NUM_UES=$1      # Number of UEs to generate
START_INDEX=$2  # Starting index for UE config files

# Base configuration file
BASE_CONFIG="./configs/ue_template_zmq.conf"

# Validate that the base config file exists
if [[ ! -f "$BASE_CONFIG" ]]; then
    echo "Error: Base configuration file '$BASE_CONFIG' not found."
    exit 1
fi

# Remove all existing uex configuration files before generating new ones
echo "Removing existing UE configuration files..."
rm -f ./configs/ue[0-9]*_zmq.conf

# Loop through and generate config files for each UE
for (( i=0; i<$NUM_UES; i++ )); do
    UE_INDEX=$((START_INDEX + i))  # Calculate the current UE index (one-based index)
    UE_CONFIG="./configs/ue${UE_INDEX}_zmq.conf"  # Name of the new UE config file

    # Copy the base config file to a new file
    cp "$BASE_CONFIG" "$UE_CONFIG"

    # Calculate tx_port and rx_port
    TX_PORT=$((2101 + (UE_INDEX - 1) * 100))  # tx_port pattern: 2101, 2201, 2301, ...
    RX_PORT=$((2100 + (UE_INDEX - 1) * 100))  # rx_port pattern: 2100, 2200, 2300, ...

    # Update the device_args in the [rf] class with the calculated tx_port and rx_port
    sed -i "/^\[rf\]/,/^\[.*\]/s|tx_port=tcp://127.0.0.1:2101|tx_port=tcp://127.0.0.1:$TX_PORT|g" "$UE_CONFIG"
    sed -i "/^\[rf\]/,/^\[.*\]/s|rx_port=tcp://127.0.0.1:2100|rx_port=tcp://127.0.0.1:$RX_PORT|g" "$UE_CONFIG"

    # Update the [pcap] class with the appropriate UE numbers
    sed -i "/^\[pcap\]/,/^\[.*\]/s|ue1_mac.pcap|ue${UE_INDEX}_mac.pcap|g" "$UE_CONFIG"
    sed -i "/^\[pcap\]/,/^\[.*\]/s|ue1_mac_nr.pcap|ue${UE_INDEX}_mac_nr.pcap|g" "$UE_CONFIG"
    sed -i "/^\[pcap\]/,/^\[.*\]/s|ue1_nas.pcap|ue${UE_INDEX}_nas.pcap|g" "$UE_CONFIG"

    # Update the [log] class with the appropriate UE log filename
    sed -i "/^\[log\]/,/^\[.*\]/s|ue1.log|ue${UE_INDEX}.log|g" "$UE_CONFIG"

    # Update the [gw] class with the correct netns for each UE
    echo "Updating netns field for UE${UE_INDEX}..."

    # This sed line will now correctly replace the whole netns line, ensuring the update is applied
    sed -i "s|^netns = ue1|netns = ue${UE_INDEX}|g" "$UE_CONFIG"

    echo "Generated configuration for UE${UE_INDEX}: ${UE_CONFIG}"
done

echo "Successfully generated $NUM_UES UE configuration files starting from index $START_INDEX."

