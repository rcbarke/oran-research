#!/bin/bash
#
# gnuradio.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Installs gnuradio, computes grc modulation graph for passed in number of UEs, and stages completed modulation config for deployment
#

# Validate that NUM_UEs argument is passed
if [ -z "$1" ]; then
  echo "Error: NUM_UEs argument is required."
  echo "Usage: ./gnuradio.sh <NUM_UEs>"
  exit 1
fi
NUM_UEs=$1

# Install gnuradio
sudo apt-get install -y gnuradio

# Generate UE config file
./compile/generate_ue_config_json.sh $NUM_UEs
echo "Generated ue_config JSON for $NUM_UEs UE PRB management..."


# Generate multi-UE scenario
./compile/generate_multi_ue_py.sh $NUM_UEs
echo "Generated gnuradio .py for modulating $NUM_UEs UEs..."

# Stage completed configuration file
GNU_PY="./configs/multi_ue_scenario.py"
UE_JSON="./configs/ue_config.json"
echo "Staging gnuradio files into ./srsRAN_4G/build/srsue/src/..."
cp "$GNU_PY" "./srsRAN_4G/build/srsue/src/"
cp "$UE_JSON" "./srsRAN_4G/build/srsue/src/"
