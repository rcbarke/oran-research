#!/bin/bash
#
# open5gs.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Configures Open5GS subscriber database by reading from a subscriber_template_db.csv file.
# The template has 4 entries: ue00 (reserved) and ue1-ue3, with ue1 used as the template for generating more UEs.
#
# Subscriber db is built within ./configs/subscriber_db.csv based on the number of UEs passed in via CLI.
#
# Usage: ./open5gs.sh <TOTAL_UEs> <START_INDEX>
#

# Function to build the subscriber database based on TOTAL_UEs and START_INDEX
build_subscriber_db() {
    local TOTAL_UEs=$1
    local START_INDEX=$2

    echo "Building $CONFIG_FILE with $TOTAL_UEs UEs starting from index $START_INDEX"

    # Get the directory where the script is located
    SCRIPT_DIR="$(dirname "$(realpath "$0")")"

    # Define paths for the config file and template file
    TEMPLATE_FILE="$SCRIPT_DIR/../configs/subscriber_template_db.csv"
    CONFIG_FILE="$SCRIPT_DIR/../configs/subscriber_db.csv"

    # Ensure the configs directory exists
    CONFIG_DIR="$(dirname "$CONFIG_FILE")"
    if [ ! -d "$CONFIG_DIR" ]; then
        echo "Error: Directory $CONFIG_DIR does not exist. Creating it now..."
        mkdir -p "$CONFIG_DIR"
    fi

    # Create or clear the output file
    > "$CONFIG_FILE"

    # Check if the template file exists
    if [ ! -f "$TEMPLATE_FILE" ]; then
        echo "Error: Template file $TEMPLATE_FILE does not exist."
        exit 1
    fi

    # Copy the comments and the ue0 (reserved) line to the config file
    head -n 16 "$TEMPLATE_FILE" >> "$CONFIG_FILE"

    # Extract ue1 as the template
    TEMPLATE_LINE=$(sed -n "17p" "$TEMPLATE_FILE")

    # Extract relevant fields from the template (using cut for easier column parsing)
    TEMPLATE_IMSI=$(echo "$TEMPLATE_LINE" | cut -d ',' -f2)
    TEMPLATE_KEY=$(echo "$TEMPLATE_LINE" | cut -d ',' -f3)
    TEMPLATE_OPC=$(echo "$TEMPLATE_LINE" | cut -d ',' -f4)
    TEMPLATE_AUTH=$(echo "$TEMPLATE_LINE" | cut -d ',' -f5)
    TEMPLATE_PORT=$(echo "$TEMPLATE_LINE" | cut -d ',' -f6)
    TEMPLATE_AMBR=$(echo "$TEMPLATE_LINE" | cut -d ',' -f7)
    TEMPLATE_IP=$(echo "$TEMPLATE_LINE" | cut -d ',' -f8)

    # Write ue1 if the start index is less than or equal to 1 and within range
    if (( START_INDEX == 1 )); then
        echo "$TEMPLATE_LINE" >> "$CONFIG_FILE"
    fi

    # Generate additional UEs starting from the START_INDEX
    for (( i=START_INDEX; i<START_INDEX+TOTAL_UEs; i++ )); do
        UE_INDEX=$i

        # Increment the ueX field (e.g., ue10, ue11, etc.)
        NEW_UE_ID="ue$(printf "%02d" $UE_INDEX)"

        # Increment IMSI by the UE_INDEX value, ensuring 15 digits are preserved
        NEW_IMSI=$(printf "%015d" $((10#$TEMPLATE_IMSI + UE_INDEX - 1)))

        # Increment Key by the UE_INDEX value (preserving the format and total length)
        NEW_KEY=$(printf "%032s" "00112233445566778899aabb$(printf "%08x" $((0x${TEMPLATE_KEY:24} + UE_INDEX - 1)))")

        # Increment IP address for each UE
        NEW_IP=$(echo "$TEMPLATE_IP" | awk -F '.' '{print $1"."$2"."$3"."($4+'$UE_INDEX'-1)}')

        # Replace the unique fields in the template line with incremented values
        NEW_UE_LINE="$NEW_UE_ID,$NEW_IMSI,$NEW_KEY,$TEMPLATE_OPC,$TEMPLATE_AUTH,$TEMPLATE_PORT,$TEMPLATE_AMBR,$NEW_IP"

        # Write the new UE line to the config file
        echo "$NEW_UE_LINE" >> "$CONFIG_FILE"
    done

    echo "Successfully built $CONFIG_FILE with $TOTAL_UEs UEs starting from index $START_INDEX."
}

# Function to configure the subscriber database with the built file
config_subscriber_db() {
    # Ensure the source file exists
    if [ ! -f "./configs/subscriber_db.csv" ]; then
        echo "Error: subscriber_db.csv file not found."
        exit 1
    fi
    
    # Copy the file
    echo "Staging subscriber_db.csv into open5gs."
    cp "./configs/subscriber_db.csv" "./srsRAN_Project/docker/open5gs/subscriber_db.csv"
    
    # Set env file
    set_env_file
}

# Function to build the srsProject repo with ZEROMQ Enabled
set_env_file() {
    ENV_FILE="./srsRAN_Project/docker/open5gs/open5gs.env"

    # Check if the file exists
    if [ ! -f "$ENV_FILE" ]; then
        echo "Error: File $ENV_FILE does not exist."
        exit 1
    fi

    # Replace the SUBSCRIBER_DB line or add if it doesn't exist
    sed -i 's/^SUBSCRIBER_DB=.*/SUBSCRIBER_DB=subscriber_db.csv/' "$ENV_FILE"

    # Comment out the TZ line if it isn't already commented
    sed -i 's/^TZ=/#TZ=/' "$ENV_FILE"

    echo "Successfully updated $ENV_FILE."
}

# Check for TOTAL_UEs and START_INDEX arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <TOTAL_UEs> <START_INDEX>"
    exit 1
fi

# Build subscriber database
build_subscriber_db "$1" "$2"

# Configure subscriber database
config_subscriber_db

