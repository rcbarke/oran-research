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

# Function to get USIM data from subscriber_db.csv and update the configuration file
get_usim() {
    local UE_INDEX=$1       # UE index passed in from the loop
    local UE_CONFIG=$2      # Configuration file to write the values to
    local SUB_DB="./configs/subscriber_db.csv"  # Path to subscriber_db.csv file
    local BASE_CONFIG="./configs/ue_template_zmq.conf"  # Template config to get IMEI base value

    # Validate that the subscriber_db.csv file exists
    if [[ ! -f "$SUB_DB" ]]; then
        echo "Error: Subscriber database file '$SUB_DB' not found."
        exit 1
    fi

    # Validate that the base config file exists for IMEI generation
    if [[ ! -f "$BASE_CONFIG" ]]; then
        echo "Error: Base configuration file '$BASE_CONFIG' not found."
        exit 1
    fi

    # Find the row corresponding to the current UE_INDEX
    USIM_LINE=$(grep "ue$(printf "%02d" "$UE_INDEX")" "$SUB_DB")

    if [[ -z "$USIM_LINE" ]]; then
        echo "Error: No matching USIM entry found for ue${UE_INDEX} in '$SUB_DB'."
        exit 1
    fi

    # Extract the necessary fields from the subscriber_db.csv (IMSI, Key, OP/OPc)
    IMSI=$(echo "$USIM_LINE" | cut -d ',' -f2)
    K=$(echo "$USIM_LINE" | cut -d ',' -f3)
    OPC=$(echo "$USIM_LINE" | cut -d ',' -f5)

    # Generate IMEI based on the template and increment for each UE
    IMEI_BASE=$(grep "imei = " "$BASE_CONFIG" | cut -d '=' -f2 | tr -d '[:space:]')
    IMEI=$(printf "%015d" $((IMEI_BASE + UE_INDEX - 1)))

    # Escape any special characters in the values
    IMSI_ESCAPED=$(echo "$IMSI" | sed 's/[&/\]/\\&/g')
    K_ESCAPED=$(echo "$K" | sed 's/[&/\]/\\&/g')
    OPC_ESCAPED=$(echo "$OPC" | sed 's/[&/\]/\\&/g')
    IMEI_ESCAPED=$(echo "$IMEI" | sed 's/[&/\]/\\&/g')

    # Update the [usim] section in the configuration file using the escaped values
    sed -i "\|\[usim\]|,\|\[.*\]|s|imsi = .*|imsi = $IMSI_ESCAPED|g" "$UE_CONFIG"
    sed -i "\|\[usim\]|,\|\[.*\]|s|k    = .*|k    = $K_ESCAPED|g" "$UE_CONFIG"
    sed -i "\|\[usim\]|,\|\[.*\]|s|opc  = .*|opc  = $OPC_ESCAPED|g" "$UE_CONFIG"
    sed -i "\|\[usim\]|,\|\[.*\]|s|imei = .*|imei = $IMEI_ESCAPED|g" "$UE_CONFIG"

    echo "Updated USIM for UE${UE_INDEX} in ${UE_CONFIG}"
}

# Function to generate UEs
generate_ues() {
    local NUM_UES=$1      # Number of UEs to generate
    local START_INDEX=$2   # Starting index for UE config files

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
    rm -f ./srsRAN_4G/build/srsue/src/ue[0-9]*_zmq.conf
    
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

        # Update the netns for the UE
        sed -i "s|^netns = ue1|netns = ue${UE_INDEX}|g" "$UE_CONFIG"

        # Call get_usim function to update the USIM values for this UE
        get_usim "$UE_INDEX" "$UE_CONFIG"
        echo "Generated configuration for UE${UE_INDEX}: ${UE_CONFIG}"
        
        echo "Staging srsue configs into ./srsRAN_4G/build/srsue/src/..."
        cp "$UE_CONFIG" "./srsRAN_4G/build/srsue/src/"
    done

    echo "Successfully generated $NUM_UES UE configuration files starting from index $START_INDEX."
}

# Check for correct number of arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <NUM_UES> <START_INDEX>"
    exit 1
fi

# Call the function to generate UEs
generate_ues "$1" "$2"
