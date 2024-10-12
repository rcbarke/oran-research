#!/bin/bash
#
# srs4g.sh
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
BASE_CONFIG="ue1_zmq.conf"

# Validate that the base config file exists
if [[ ! -f "$BASE_CONFIG" ]]; then
    echo "Error: Base configuration file '$BASE_CONFIG' not found."
    exit 1
fi

# Loop through and generate config files
for (( i=0; i<$NUM_UES; i++ )); do
    UE_INDEX=$((START_INDEX + i))  # Calculate the current UE index
    UE_CONFIG="ue${UE_INDEX}_zmq.conf"  # Name of the new UE config file

