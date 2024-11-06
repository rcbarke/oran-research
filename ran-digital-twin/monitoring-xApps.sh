#!/bin/bash
#
# monitoring-xApps.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory
# ORAN team
#
# Description:
# This script launches two gnome-terminal windows for monitoring KPIMon and Grafana in real-time during the RAN Digital Twin simulation. KPIMon monitors UE throughput metrics, while Grafana provides a graphical interface for gNB performance metrics via a web browser dashboard.
#
# Usage:
# ./monitoring-xApps.sh <NUM_UEs>
# - <NUM_UEs>: Number of UEs to monitor
#
# Example:
# ./monitoring-xApps.sh 10

# Check if NUM_UEs is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <NUM_UEs>"
    echo "Example: $0 10"
    exit 1
fi

NUM_UEs=$1

# Generate UE_STR as "0,1,2,...,N-1"
UE_STR=$(seq -s, 0 $((NUM_UEs - 1)))

# Check if gnome-terminal is installed
if ! command -v gnome-terminal &> /dev/null; then
    echo "Error: gnome-terminal could not be found. Please install it before running this script."
    exit 1
fi

# Check if Firefox is installed
if ! command -v firefox &> /dev/null; then
    echo "Error: firefox could not be found. Please install it before running this script."
    exit 1
fi

# Open KPIMon in a new gnome-terminal window
gnome-terminal --title="KPIMon" -- bash -c "
    cd ./oran-sc-ric &&
    echo 'Starting KPIMon for $NUM_UEs UEs...' &&
    sudo docker compose exec python_xapp_runner ./cu_kpm_mon_xapp.py --metrics=DRB.UEThpDl,DRB.UEThpUl --kpm_report_style=5 --ue_ids=$UE_STR --refresh_rate=125;
    exec bash
"

# Open Grafana in a new gnome-terminal window
gnome-terminal --tab --title="Grafana" -- bash -c "
    cd srsRAN_Project &&
    echo 'Starting Grafana monitoring dashboard...' &&
    sudo docker compose -f docker/docker-compose.yml up grafana;
    exec bash
"

# Sleep for 10 seconds to give Grafana time to start
echo "Waiting 10 seconds for Grafana to start..."
sleep 10

# Launch Firefox to open Grafana dashboard
echo "Opening Grafana in Firefox at http://localhost:3300"
firefox http://localhost:10300 &

echo "Monitoring xApps have been launched in separate terminals."
