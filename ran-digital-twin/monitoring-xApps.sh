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
# Monitoring xApps:
# 1. **KPIMon**: Tracks UE downlink and uplink throughput (DL/UL) and other performance metrics via a CLI in the OSC RIC container.
# 2. **Grafana**: Provides a web-based graphical dashboard for gNB performance monitoring (e.g., resource utilization, UE throughput).
#
# Script Flow:
# - Opens two gnome-terminal windows for the xApps: one for KPIMon running in the `python_xapp_runner` container and one for Grafana.
# - Waits for 10 seconds to allow Grafana to deploy, then automatically opens Firefox to the Grafana dashboard at `http://localhost:3300`.
#
# Pre-Conditions and Assumptions:
# 1. This script assumes that the RAN Digital Twin simulation is already running with all components (Open5GS, OSC RIC, srsGNB, and srsUE) properly deployed.
# 2. Docker and Firefox are installed and configured on the host machine.
# 3. Grafana has been set up and is accessible at `http://localhost:3300`.
#
# Dependencies:
# - **gnome-terminal**: Required for opening new terminals for KPIMon and Grafana.
# - **firefox**: Required for opening the Grafana dashboard in a web browser.
#
# Example Usage:
# - **./monitoring-xApps.sh**: Launches KPIMon and Grafana in separate terminal windows and opens the Grafana dashboard in Firefox.
#
# Notes:
# - This script assumes a 10-second delay is sufficient for Grafana to start. If the Grafana service takes longer, adjust the `sleep` duration accordingly.

# Check if gnome-terminal is installed
if ! command -v gnome-terminal &> /dev/null; then
    echo "Error: gnome-terminal could not be found. Please install it before running this script."
    exit 1
fi

if ! command -v firefox &> /dev/null; then
    echo "Error: firefox could not be found. Please install it before running this script."
    exit 1
fi

# Open KPIMon in a new gnome terminal
gnome-terminal --title="KPIMon" -- bash -c "
    cd ./oran-sc-ric &&
    echo 'Starting KPIMon...' &&
    sudo docker compose exec python_xapp_runner ./kpm_mon_xapp.py --metrics=DRB.UEThpDl,DRB.UEThpUl --kpm_report_style=5;
    exec bash
"

# Open Grafana in a new gnome terminal
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
