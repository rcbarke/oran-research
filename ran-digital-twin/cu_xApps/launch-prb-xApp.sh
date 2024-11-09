#
# launch-prb-xApp.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: This script checks if `gnome-terminal` is installed and launches 
# the PRB (Physical Resource Block) Management xApp in a new gnome-terminal window. 
# The xApp configures network parameters using `apply_config.py`, which loads 
# settings from `allloc.json`. This setup is essential for managing resource 
# allocation within the ORAN SC RIC (RAN Intelligent Controller).
#
# Usage: ./launch_prb_xapp.sh
# 
# Requirements: `gnome-terminal` and `docker` with appropriate configurations 
# for executing `apply_config.py` within the `oran-sc-ric` Docker environment.
#

# Supress GTK error
export NO_AT_BRIDGE=1

# Check if gnome-terminal is installed
if ! command -v gnome-terminal &> /dev/null; then
    echo "Error: gnome-terminal could not be found. Please install it before running this script."
    exit 1
fi

# Open Resource Management xApp in a new gnome-terminal window
gnome-terminal --title="PRB xApp" -- bash -c "
    cd ./oran-sc-ric &&
    echo 'Starting PRB Management xApp...' &&
    echo 'Modify network parameters from oran-sc-ric/xApps/python/alloc.json...' &&
    sudo docker compose exec python_xapp_runner ./apply_config.py 
    exec bash
" 2>/dev/null

echo "PRB Management xApps have been launched in separate terminals."
