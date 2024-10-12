#!/bin/bash
#
# open5gs.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Downloads and configures open5gs to the total amount of subscribers passed in
# via CLI.
#

# Function to display usage information
usage() {
    echo "Usage: $0 <TOTAL_UES>"
    echo "Example: $0 4"
    exit 1
}

# Check if the required argument is provided
if [ -z "$1" ]; then
    echo "Error: TOTAL_UES argument is required."
    usage
fi

# Assign the first argument to TOTAL_UES
TOTAL_UES="$1"

echo "$TOTAL_UES Total UEs on Network..."
# Add the rest of the script logic below
