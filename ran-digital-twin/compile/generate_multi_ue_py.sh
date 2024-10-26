#!/bin/bash
#
# generate_multi_ue_py.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Generates a Python script (multi_ue_scenario.py) to configure a multi-UE scenario for GNU Radio.
# The number of UEs is passed in via the CLI. The generated Python script will include dynamically created blocks and connections for each UE, based on the provided number of UEs.
#
# The output file (multi_ue_scenario.py) is created in the configs directory.
#
# Usage: ./generate_multi_ue_py.sh <NUM_UES>
# Example: ./generate_multi_ue_py.sh 5
#

# Define output path
OUTPUT_FILE="./configs/multi_ue_scenario.py"

# Check if CLI argument for the number of UEs is provided
if [ -z "$1" ]; then
    echo "Error: Number of UEs not specified."
    echo "Usage: ./generate_multi_ue_py.sh <num_of_UEs>"
    exit 1
fi

# Check if the argument is a valid number
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: The argument must be a positive integer."
    exit 1
fi

NUM_UES=$1

# Ensure the ./configs directory exists
if [ ! -d "./configs" ]; then
    mkdir -p "./configs"
    echo "Created directory: ./configs"
fi

# Ensure the output file exists, create it if not
if [ ! -f "$OUTPUT_FILE" ]; then
    touch "$OUTPUT_FILE"
    echo "Created file: $OUTPUT_FILE"
fi

# Start writing the Python file
echo "Generating Python file with $NUM_UES UEs..."

# Write the file header to the output file
cat <<EOL > "$OUTPUT_FILE"
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: srsRAN_multi_UE
# GNU Radio version: 3.10.1.1

from gnuradio import blocks
from gnuradio import digital
from gnuradio import gr
from gnuradio.filter import firdes
from gnuradio.fft import window
import os
import sys
import signal
import fcntl
import json
import threading
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import zeromq




class multi_ue_scenario(gr.top_block):
EOL

# Write the beginning of the __init__ method and variables section to the output file
cat <<EOL >> "$OUTPUT_FILE"

    def __init__(self):
        gr.top_block.__init__(self, "srsRAN_multi_UE", catch_exceptions=True)

        ##################################################
        # Variables
        ##################################################
        self.zmq_timeout = zmq_timeout = 100
        self.zmq_hwm = zmq_hwm = -1
EOL

# Dynamically generate UE variables based on NUM_UES
for (( i=NUM_UES; i>=1; i-- )); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.ue${i}_slow_down_ratio = ue${i}_slow_down_ratio = 1
        self.ue${i}_path_loss_db = ue${i}_path_loss_db = 0
EOL
done

# Append the remaining static variables
cat <<EOL >> "$OUTPUT_FILE"
        self.samp_rate = samp_rate = 9360000
        self.gnb_slow_down_ratio = gnb_slow_down_ratio = 1
EOL

# Start writing the blocks section to the output file
cat <<EOL >> "$OUTPUT_FILE"

        ##################################################
        # Blocks
        ##################################################
EOL

# Dynamically generate each UE's zeromq tx and rx blocks based on NUM_UES
for (( i=NUM_UES; i>=1; i-- )); do
    ue_tx_port=$((2101 + (i - 1) * 100))
    ue_rx_port=$((2100 + (i - 1) * 100))
    cat <<EOL >> "$OUTPUT_FILE"
        self.zeromq_ue${i}_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:${ue_tx_port}', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue${i}_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:${ue_rx_port}', zmq_timeout, False, zmq_hwm)
EOL
done

# Append the gNB blocks with fixed ports
cat <<EOL >> "$OUTPUT_FILE"
        self.zeromq_gnb_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2000', zmq_timeout, False, zmq_hwm)
        self.zeromq_gnb_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2001', zmq_timeout, False, zmq_hwm)
EOL

# Start writing the add block to the output file
cat <<EOL >> "$OUTPUT_FILE"
        self.blocks_ue_tx_to_gnb_rx_add = blocks.add_vcc(1)
EOL

# Dynamically generate each UE's pathloss blocks
for (( i=NUM_UES; i>=1; i-- )); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.blocks_ue${i}_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue${i}_path_loss_db/20.0))
        self.blocks_ue${i}_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue${i}_path_loss_db/20.0))
EOL
done

# Dynamically generate throttle blocks for each UE
for (( i=NUM_UES; i>=1; i-- )); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.blocks_throttle_ue${i}_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue${i}_slow_down_ratio),True)
        self.blocks_throttle_ue${i}_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue${i}_slow_down_ratio),True)
EOL
done

# Add static throttle blocks for gNB
cat <<EOL >> "$OUTPUT_FILE"
        self.blocks_throttle_gnb_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*gnb_slow_down_ratio),True)
        self.blocks_throttle_gnb_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*gnb_slow_down_ratio),True)
EOL

# Generate the connections section header
cat <<EOL >> "$OUTPUT_FILE"

        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_throttle_gnb_rx, 0), (self.zeromq_gnb_rx, 0))
EOL

# Loop through each UE and create connections from gnb_tx to ue_rx_pathloss
for i in $(seq 1 $NUM_UES); do
  echo "        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue${i}_rx_pathloss, 0))" >> "$OUTPUT_FILE"
done

# Loop through each UE and complete DL path to UE rx
for i in $(seq 1 $NUM_UES); do
  echo "        self.connect((self.blocks_throttle_ue${i}_rx, 0), (self.zeromq_ue${i}_rx, 0))" >> "$OUTPUT_FILE"
  echo "        self.connect((self.blocks_throttle_ue${i}_tx, 0), (self.blocks_ue${i}_tx_pathloss, 0))" >> "$OUTPUT_FILE"
done

# Generate connections from UE pathloss blocks to throttle and gNB add block
for i in $(seq 1 $NUM_UES); do
  echo "        self.connect((self.blocks_ue${i}_rx_pathloss, 0), (self.blocks_throttle_ue${i}_rx, 0))" >> "$OUTPUT_FILE"
  echo "        self.connect((self.blocks_ue${i}_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, $((i-1))))" >> "$OUTPUT_FILE"
done

# Connect the UE TX to gNB RX add block to the gNB RX throttle
echo "        self.connect((self.blocks_ue_tx_to_gnb_rx_add, 0), (self.blocks_throttle_gnb_rx, 0))" >> "$OUTPUT_FILE"

# Connect the gNB TX zeromq block to its throttle
echo "        self.connect((self.zeromq_gnb_tx, 0), (self.blocks_throttle_gnb_tx, 0))" >> "$OUTPUT_FILE"

# Dynamically generate UE TX connections to throttles based on NUM_UES
for ((i=1; i<=NUM_UES; i++)); do
    echo "        self.connect((self.zeromq_ue${i}_tx, 0), (self.blocks_throttle_ue${i}_tx, 0))" >> "$OUTPUT_FILE"
done

# Append the final lines to finish the __init__ method
cat <<EOL >> "$OUTPUT_FILE"

        # Begin reading UE config file
        self.timer = None
        self.start_periodic_config_read()
EOL

# Append Configuration Read and Update Methods section
cat <<EOL >> "$OUTPUT_FILE"

    ##################################################
    # Configuration Read and Update Methods
    ##################################################    
    def start_periodic_config_read(self):
        """Start the periodic config file reading."""
        self.read_config()
        self.timer = threading.Timer(0.3, self.start_periodic_config_read)
        self.timer.start()

    def stop_timer(self):
        """Cancel the timer if it's running."""
        if self.timer is not None:
            self.timer.cancel()
EOL

# Append the read_config method
cat <<EOL >> "$OUTPUT_FILE"

    def read_config(self):
        """Read the UE configuration from ue_config.json."""
        config_path = os.path.join(os.path.dirname(sys.argv[0]), 'ue_config.json')
        try:
            with open(config_path, 'r') as config_file:
                fcntl.flock(config_file, fcntl.LOCK_EX)  # Lock the file for exclusive access
                config_data = json.load(config_file)
                fcntl.flock(config_file, fcntl.LOCK_UN)  # Unlock after reading
                # Update variables based on config
                self.set_ue_variables(config_data)
        except (FileNotFoundError, json.JSONDecodeError) as e:
            print(f"Error reading configuration file: {e}")
EOL

# Start the set_ue_variables method
cat <<'EOL' >> "$OUTPUT_FILE"

    def set_ue_variables(self, config_data):
        """Update the UE-specific variables based on the config data list."""
        # Iterate over each UE configuration and apply settings
        for ue_config in config_data:
            total_prb = 52  # 10MHz 1800 MHz n3 w/ 15kHz SCS & 12 channel symbols
            ue_id = ue_config.get("id")
            prb = ue_config.get("prb")
            pathloss = ue_config.get("pathloss")
EOL

# Dynamically generate elif statements for each UE
for ((i=1; i<=NUM_UES; i++)); do
  cat <<EOL >> "$OUTPUT_FILE"
            if ue_id == $i:
                self.set_ue${i}_slow_down_ratio(total_prb / prb)
                self.set_ue${i}_path_loss_db(pathloss)
                #print(f"UE${i} - PRB: {prb}, Pathloss: {pathloss} dB")
EOL
done

# Append the Variable Setter Methods section to the output file
cat <<'EOL' >> "$OUTPUT_FILE"

    ##################################################
    # Variable Setter Methods
    ##################################################
    def get_zmq_timeout(self):
        return self.zmq_timeout

    def set_zmq_timeout(self, zmq_timeout):
        self.zmq_timeout = zmq_timeout

    def get_zmq_hwm(self):
        return self.zmq_hwm

    def set_zmq_hwm(self, zmq_hwm):
        self.zmq_hwm = zmq_hwm
EOL

# Append dynamic UE getter and setter methods to the output file
for ((i=1; i<=NUM_UES; i++)); do
    cat <<EOL >> "$OUTPUT_FILE"

    def get_ue${i}_slow_down_ratio(self):
        return self.ue${i}_slow_down_ratio

    def set_ue${i}_slow_down_ratio(self, ue${i}_slow_down_ratio):
        self.ue${i}_slow_down_ratio = ue${i}_slow_down_ratio
        self.blocks_throttle_ue${i}_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue${i}_slow_down_ratio))
        self.blocks_throttle_ue${i}_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue${i}_slow_down_ratio))

    def get_ue${i}_path_loss_db(self):
        return self.ue${i}_path_loss_db

    def set_ue${i}_path_loss_db(self, ue${i}_path_loss_db):
        self.ue${i}_path_loss_db = ue${i}_path_loss_db
        self.blocks_ue${i}_rx_pathloss.set_k(10**(-1.0*self.ue${i}_path_loss_db/20.0))
        self.blocks_ue${i}_tx_pathloss.set_k(10**(-1.0*self.ue${i}_path_loss_db/20.0))
EOL
done

# Begin the static part of the get_samp_rate and set_samp_rate methods
cat <<EOL >> "$OUTPUT_FILE"

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_gnb_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.gnb_slow_down_ratio))
        self.blocks_throttle_gnb_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.gnb_slow_down_ratio))
EOL

# Dynamically add the UE-specific throttle blocks
for ((i=1; i<=NUM_UES; i++)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.blocks_throttle_ue${i}_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue${i}_slow_down_ratio))
        self.blocks_throttle_ue${i}_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue${i}_slow_down_ratio))
EOL
done

# Append the methods for gnb_slow_down_ratio to the output file
cat <<EOL >> "$OUTPUT_FILE"

    def get_gnb_slow_down_ratio(self):
        return self.gnb_slow_down_ratio

    def set_gnb_slow_down_ratio(self, gnb_slow_down_ratio):
        self.gnb_slow_down_ratio = gnb_slow_down_ratio
        self.blocks_throttle_gnb_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.gnb_slow_down_ratio))
        self.blocks_throttle_gnb_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.gnb_slow_down_ratio))
EOL

# Append the main function to the output file
cat <<EOL >> "$OUTPUT_FILE"

def main(top_block_cls=multi_ue_scenario, options=None):
    tb = top_block_cls()

    def sig_handler(sig=None, frame=None):
        tb.stop_timer()
        tb.stop()
        tb.wait()
        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()

    try:
        input('UE Modulation started. Press Enter to quit: ')
    except EOFError:
        pass
    tb.stop_timer()
    tb.stop()
    tb.wait()


if __name__ == '__main__':
    main()
EOL

# Make the output Python script executable
chmod +x $OUTPUT_FILE

# Print confirmation message
echo "Generated Python script: $OUTPUT_FILE"
