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
# Subscriber db is built within ./configs/subscriber_db.csv
#
# srsRANProject is cloned and built if not present or force built
#
# Subscriber db is staged to ./srsProject/docker/open5gs/subscriber.csv
#
# ./srsProject/docker/open5gs/open5gs.env is configured to point to the staged database
#

# Function to build the subscriber database based on TOTAL_UEs
build_subscriber_db() {
    local TOTAL_UEs=$1

    echo "Building $CONFIG_FILE with $TOTAL_UEs UEs"

    # Get the directory where the script is located
    SCRIPT_DIR="$(dirname "$(realpath "$0")")"

    # Define paths for the config file and temp file
    CONFIG_FILE="$SCRIPT_DIR/../configs/subscriber_db.csv"
    TEMP_FILE="$SCRIPT_DIR/../configs/subscriber_db_temp.csv"

    # Ensure the configs directory exists
    CONFIG_DIR="$(dirname "$CONFIG_FILE")"
    if [ ! -d "$CONFIG_DIR" ]; then
        echo "Error: Directory $CONFIG_DIR does not exist. Creating it now..."
        mkdir -p "$CONFIG_DIR"
    fi

    # Create or clear the temp file
    > "$TEMP_FILE"

    # Check if the config file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Error: Config file $CONFIG_FILE does not exist."
        exit 1
    fi

    # Copy the first 15 lines (comments) directly to the temp file
    head -n 15 "$CONFIG_FILE" >> "$TEMP_FILE"

    # Row indices for specific UEs
    UE0_LINE=16
    UE1_LINE=17

    # Extract and write ue0 (reserved)
    sed -n "${UE0_LINE}p" $CONFIG_FILE >> $TEMP_FILE

    # Extract ue1 as template
    TEMPLATE_LINE=$(sed -n "${UE1_LINE}p" $CONFIG_FILE)

    # Extract relevant fields from the template (using cut for easier column parsing)
    TEMPLATE_UE_ID=$(echo $TEMPLATE_LINE | cut -d ',' -f1)
    TEMPLATE_IMSI=$(echo $TEMPLATE_LINE | cut -d ',' -f2)
    TEMPLATE_KEY=$(echo $TEMPLATE_LINE | cut -d ',' -f3)
    TEMPLATE_IP=$(echo $TEMPLATE_LINE | cut -d ',' -f8)
    TEMPLATE_PORT=$(echo $TEMPLATE_LINE | cut -d ',' -f6)

    # Common fields
    TEMPLATE_OPC=$(echo $TEMPLATE_LINE | cut -d ',' -f4)
    TEMPLATE_AUTH=$(echo $TEMPLATE_LINE | cut -d ',' -f5)
    TEMPLATE_AMBR=$(echo $TEMPLATE_LINE | cut -d ',' -f7)  # AMBR remains common across UEs

    # Write ue1 as is
    echo $TEMPLATE_LINE >> $TEMP_FILE

    # Increment and write additional UEs from ue2 to ue(TOTAL_UEs)
    for (( i=2; i<=$TOTAL_UEs; i++ )); do
        # Increment the ueX field (e.g., ue01 -> ue02)
        NEW_UE_ID="ue$(printf "%02d" $i)"

        # Increment IMSI by 1 for each UE, ensuring 15 digits are preserved
        NEW_IMSI=$(printf "%015d" $((10#$TEMPLATE_IMSI + i - 1)))

        # Increment Key by 1 for each UE (preserving the format and total length)
        NEW_KEY=$(printf "%032s" "00112233445566778899aabb$(printf "%08x" $((0x${TEMPLATE_KEY:24} + i - 1)))")
        
        # Port remains 9001 for all UEs beyond ue00
        NEW_PORT="9001"

        # Increment IP address, ensuring that each part is correctly incremented
        NEW_IP=$(echo $TEMPLATE_IP | awk -F '.' '{print $1"."$2"."$3"."($4+'$i'-1)}')

        # Replace the unique fields in the template line with incremented values
        NEW_UE_LINE="$NEW_UE_ID,$NEW_IMSI,$NEW_KEY,$TEMPLATE_OPC,$TEMPLATE_AUTH,$NEW_PORT,$TEMPLATE_AMBR,$NEW_IP"

        # Write the new UE line to the temporary file
        echo $NEW_UE_LINE >> $TEMP_FILE
    done

    # Overwrite the original file with the updated content
    mv $TEMP_FILE $CONFIG_FILE

    echo "Successfully built $CONFIG_FILE with $TOTAL_UEs."
}

# Function to build the srsProject repo with ZEROMQ Enabled
build_srsran_project() {
    echo "srsRAN Project build initiated..."
    
    # Check if the oran-sc-ric directory exists, and if so, skip cloning
    if [ -d "./srsRAN_Project" ]; then
        echo "srsRAN Project directory already exists. Skipping clone."
        cd srsRAN_Project/build
    else
        # Clone the repository
        echo "Cloning srsRAN_Project..."
        git clone https://github.com/srsRAN/srsRAN_Project.git
        cd srsRAN_Project
        mkdir build
        cd build
    fi
    
    # Compile and build srsRAN_Project with ZeroMQ
    cmake ../ -DENABLE_EXPORT=ON -DENABLE_ZEROMQ=ON
    make -j`nproc`
    cd ../../
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

# Check for TOTAL_UEs argument
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <TOTAL_UEs> <BUILD_SRSP>"
    exit 1
fi

# Build subscriber database
build_subscriber_db $1
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
SRSBUILD="./srsRAN_Project/build" 

# Build srsran_project
if [[ $2 == "T" || ! -d "$SRSBUILD" || -z "$(ls -A "$SRSBUILD" 2>/dev/null)" ]]; then
    # Force build, build folder does not exist, or build folder is empty
    build_srsran_project
fi

# Configure subscriber database
config_subscriber_db
