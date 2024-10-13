#!/bin/bash
#
# gnuradio.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Installs gnuradio
#

# Install gnuradio
sudo apt-get install gnuradio

GNURADIO_CONFIG="./configs/multi_ue_scenario.grc"
echo "Staging gnuradio .grc into ./srsRAN_4G/build/srsue/src/..."
cp "$GNURADIO_CONFIG" "./srsRAN_4G/build/srsue/src/"
echo "Need to modify this script to modify ${GNURADIO_CONFIG} for all built UEs..."
