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

# Generate multi-UE scenario
./compile/generate_multi_ue_grc.sh $NUM_UEs
echo "Generated gnuradio .grc for modulating $NUM_UEs UEs..."

# Stage completed configuration file
GNURADIO_CONFIG="./configs/multi_ue_scenario.grc"
echo "Staging gnuradio .grc into ./srsRAN_4G/build/srsue/src/..."
cp "$GNURADIO_CONFIG" "./srsRAN_4G/build/srsue/src/"
