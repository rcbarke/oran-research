#!/bin/bash
#
# generate_ue_config_json.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Generates a JSON configuration file (ue_config.json) with specified UEs. Each UE entry
# includes PRB (Physical Resource Block) and pathloss values, both of which are initialized to 2 and 20, respectively.
# The number of UEs is passed in via the CLI.
#
# The output file (ue_config.json) is created in the configs directory.
#
# Usage: ./generate_ue_config_json.sh <NUM_UES>
# Example: ./generate_ue_config_json.sh 5
#

# Check if the user provided the required argument (number of UEs)
if [ $# -ne 1 ]; then
    echo "Usage: $0 <NUM_UES>"
    echo "Example: $0 5"
    exit 1
fi

# Get the number of UEs from the first argument
NUM_UES=$1

# Ensure NUM_UES is a positive integer
if ! [[ "$NUM_UES" =~ ^[0-9]+$ ]]; then
    echo "Error: NUM_UES must be a positive integer."
    exit 1
fi

# Define the output file
OUTPUT_FILE="./configs/ue_config.json"

# Start writing the JSON structure
cat <<EOL > "$OUTPUT_FILE"
{
EOL

# Loop to generate config for each UE
for ((i=1; i<=NUM_UES; i++)); do
    if [ $i -eq $NUM_UES ]; then
        # If it's the last UE, don't add a trailing comma
        cat <<EOL >> "$OUTPUT_FILE"
    "${i}": {
        "prb": 2,
        "pathloss": 20
    }
EOL
    else
        # For all other UEs, add a trailing comma
        cat <<EOL >> "$OUTPUT_FILE"
    "${i}": {
        "prb": 2,
        "pathloss": 20
    },
EOL
    fi
done

# Close the JSON structure
cat <<EOL >> "$OUTPUT_FILE"
}
EOL

# Print success message
echo "ue_config.json file with $NUM_UES UEs generated successfully!"
