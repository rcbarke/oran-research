#!/bin/bash
#
# srs-gnb.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Builds the srsgnb config within 
#
# Takes one CLI arguments... RIC_NETADDR.
#
# Leverages arguments to update all IPs to the given RIC_NETADDR.
#

# Function to display usage information
usage() {
    echo "Usage: $0 <RIC_NETADDR>"
    echo ""
    echo "Arguments:"
    echo "  RIC_NETADDR     The network address for the RIC."
    exit 1
}

# Check if two arguments are provided
if [[ $# -ne 1 ]]; then
    echo "Error: Invalid number of arguments."
    usage
fi

# Input variables
RIC_NETADDR=$1
RIC_RMR=$(echo $RIC_NETADDR | awk -F '.' '{print $1"."$2"."$3".10"}')
RIC_E2=$(echo $RIC_NETADDR | awk -F '.' '{print $1"."$2"."$3".1"}')
RIC_PORT=36421

# Path to the gnb_zmq.yaml configuration file
CONFIG_FILE="./configs/gnb_zmq.yaml"

# Ensure the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file $CONFIG_FILE does not exist."
    exit 1
fi

# Use sed to search and replace within the 'e2' section only
# - Start by searching for 'e2:', then update only lines under that section.
sed -i "/^e2:/,/^ *[^ ]/s|^ *addr:.*|  addr: $RIC_E2|g" $CONFIG_FILE
sed -i "/^e2:/,/^ *[^ ]/s|^ *bind_addr:.*|  bind_addr: $RIC_RMR|g" $CONFIG_FILE
sed -i "/^e2:/,/^ *[^ ]/s|^ *port:.*|  port: $RIC_PORT|g" $CONFIG_FILE

echo "Successfully updated the 'e2' section in $CONFIG_FILE with RIC_RMR=$RIC_RMR, RIC_E2=$RIC_E2, and RIC_PORT=$RIC_PORT."
