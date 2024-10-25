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
# This script generates a multi-UE Python scenario using QPSK modulation (Quadrature Phase Shift Keying). QPSK is a type of phase modulation technique where the data is transmitted by varying the phase of the carrier signal. 
# This modulation is used in digital communication systems, including LTE and 5G networks, to achieve higher data rates while maintaining robustness in noisy communication channels.
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

# Write the Python file header
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

EOL

# Append the class definition and initial static variables
cat <<EOL >> "$OUTPUT_FILE"

class multi_ue_scenario(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "srsRAN_multi_UE", catch_exceptions=True)
        
        ##################################################
        # Variables
        ##################################################
        self.zmq_timeout = zmq_timeout = 100
        self.zmq_hwm = zmq_hwm = -1
EOL

# Dynamically generate UE variables based on NUM_UES
for ((i=1; i<=NUM_UES; i++)); do
    echo "        self.ue${i}_prb = ue${i}_prb = 2" >> "$OUTPUT_FILE"
    echo "        self.ue${i}_pathloss_db = ue${i}_pathloss_db = 20" >> "$OUTPUT_FILE"
done

# Append the remaining static variables
cat <<EOL >> "$OUTPUT_FILE"
        self.total_prb = total_prb = 52
        self.samp_rate = samp_rate = 11520000
        self.max_pathloss_db = max_pathloss_db = 107.76
        self.fft_length = fft_length = 1024
        self.constellation_qpsk = constellation_qpsk = digital.constellation_qpsk().base()

EOL

# Append the blocks section header
cat <<EOL >> "$OUTPUT_FILE"

        ##################################################
        # Blocks
        ##################################################
EOL

# Append the ZeroMQ blocks for the gNB (static)
cat <<EOL >> "$OUTPUT_FILE"
        self.zeromq_gnb_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2000', zmq_timeout, False, zmq_hwm)
        self.zeromq_gnb_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2001', zmq_timeout, False, zmq_hwm)
EOL

# Dynamically generate ZeroMQ blocks for each UE
for ((i=1; i<=NUM_UES; i++)); do
    ue_tx_port=$((2001 + i * 100))  # Calculate tx port for UE
    ue_rx_port=$((2000 + i * 100))  # Calculate rx port for UE

    # Append the dynamically generated ZeroMQ blocks for the current UE
    echo "        self.zeromq_ue${i}_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:${ue_tx_port}', zmq_timeout, False, zmq_hwm)" >> "$OUTPUT_FILE"
    echo "        self.zeromq_ue${i}_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:${ue_rx_port}', zmq_timeout, False, zmq_hwm)" >> "$OUTPUT_FILE"
done

# Append the digital OFDM TX blocks section
cat <<EOL >> "$OUTPUT_FILE"

        ##################################################
        # OFDM TX Blocks
        ##################################################
EOL

# Dynamically generate OFDM TX blocks for each UE
for ((i=NUM_UES; i>=1; i--)); do
    prb_var="ue${i}_prb"

    cat <<EOL >> "$OUTPUT_FILE"
        self.digital_ofdm_tx_ue${i} = digital.ofdm_tx(
            fft_len=fft_length,
            cp_len=int(0.07*fft_length),
            packet_length_tag_key='packet_len',
            occupied_carriers=[list(range(int((-1 * ${prb_var} * 12) / 2), 0)) + list(range(1, int((1 * ${prb_var} * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
EOL
done

# Append the OFDM TX block for gNB (static)
cat <<EOL >> "$OUTPUT_FILE"
        self.digital_ofdm_tx_gnb = digital.ofdm_tx(
            fft_len=fft_length,
            cp_len=int(0.07*fft_length),
            packet_length_tag_key='packet_len',
            occupied_carriers=[list(range(int((-1 * total_prb * 12) / 2), 0)) + list(range(1, int((1 * total_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
EOL

# Append the digital OFDM RX blocks section
cat <<EOL >> "$OUTPUT_FILE"

        ##################################################
        # OFDM RX Blocks
        ##################################################
EOL

# Dynamically generate OFDM RX blocks for each UE
for ((i=NUM_UES; i>=1; i--)); do
    prb_var="ue${i}_prb"

    cat <<EOL >> "$OUTPUT_FILE"
        self.digital_ofdm_rx_ue${i} = digital.ofdm_rx(
            fft_len=fft_length, cp_len=int(0.07*fft_length),
            frame_length_tag_key='frame_len',
            packet_length_tag_key='packet_len',
            occupied_carriers=[list(range(int((-1 * ${prb_var} * 12) / 2), 0)) + list(range(1, int((1 * ${prb_var} * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
EOL
done

# Append the OFDM RX block for gNB (static)
cat <<EOL >> "$OUTPUT_FILE"
        self.digital_ofdm_rx_gnb = digital.ofdm_rx(
            fft_len=fft_length, cp_len=int(0.07*fft_length),
            frame_length_tag_key='frame_len',
            packet_length_tag_key='packet_len',
            occupied_carriers=[list(range(int((-1 * total_prb * 12) / 2), 0)) + list(range(1, int((1 * total_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
EOL

# Append the digital constellation encoder blocks section
cat <<EOL >> "$OUTPUT_FILE"

        ##################################################
        # Constellation Encoder Blocks
        ##################################################
EOL

# Dynamically generate constellation encoder blocks for each UE
for ((i=NUM_UES; i>=1; i--)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.digital_constellation_encoder_ue${i} = digital.constellation_encoder_bc(constellation_qpsk)
EOL
done

# Append the constellation encoder block for gNB (static)
cat <<EOL >> "$OUTPUT_FILE"
        self.digital_constellation_encoder_gnb = digital.constellation_encoder_bc(constellation_qpsk)
EOL

# Append the digital constellation decoder blocks section
cat <<EOL >> "$OUTPUT_FILE"

        ##################################################
        # Constellation Decoder Blocks
        ##################################################
EOL

# Dynamically generate constellation decoder blocks for each UE
for ((i=NUM_UES; i>=1; i--)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.digital_constellation_decoder_ue${i} = digital.constellation_decoder_cb(constellation_qpsk)
EOL
done

# Append the constellation decoder block for gNB (static)
cat <<EOL >> "$OUTPUT_FILE"
        self.digital_constellation_decoder_gnb = digital.constellation_decoder_cb(constellation_qpsk)
EOL

# Append the block and pathloss section
cat <<EOL >> "$OUTPUT_FILE"

        ##################################################
        # Add Block and Pathloss Blocks
        ##################################################
        self.blocks_ue_tx_to_gnb_rx_add = blocks.add_vcc(1)
EOL

# Dynamically generate pathloss blocks for each UE
for ((i=NUM_UES; i>=1; i--)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.blocks_ue${i}_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue${i}_pathloss_db/20.0))
        self.blocks_ue${i}_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue${i}_pathloss_db/20.0))
EOL
done

# Append the connections section to the output file
cat <<EOL >> "$OUTPUT_FILE"

        ##################################################
        # Connections
        ##################################################
EOL

# Dynamically generate the connections for each UE
for ((i=1; i<=NUM_UES; i++)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.blocks_ue${i}_rx_pathloss, 0), (self.digital_ofdm_rx_ue${i}, 0))
        self.connect((self.blocks_ue${i}_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, $((i-1))))
EOL
done

# Add the static connection for gNB RX
cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.blocks_ue_tx_to_gnb_rx_add, 0), (self.digital_ofdm_rx_gnb, 0))
EOL

# Append the connections for the constellation decoders
cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.digital_constellation_decoder_gnb, 0), (self.digital_ofdm_tx_gnb, 0))
EOL

# Dynamically generate the constellation decoder connections for each UE
for ((i=1; i<=NUM_UES; i++)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.digital_constellation_decoder_ue${i}, 0), (self.digital_ofdm_tx_ue${i}, 0))
EOL
done

# Append the connections for the constellation encoders
cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.digital_constellation_encoder_gnb, 0), (self.zeromq_gnb_rx, 0))
EOL

# Dynamically generate the constellation encoder connections for each UE
for ((i=1; i<=NUM_UES; i++)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.digital_constellation_encoder_ue${i}, 0), (self.zeromq_ue${i}_rx, 0))
EOL
done

# Append the static connection for gnb OFDM RX to constellation encoder
cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.digital_ofdm_rx_gnb, 0), (self.digital_constellation_encoder_gnb, 0))
EOL

# Dynamically generate the OFDM RX connections for each UE
for ((i=1; i<=NUM_UES; i++)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.digital_ofdm_rx_ue${i}, 0), (self.digital_constellation_encoder_ue${i}, 0))
EOL
done

# Dynamically generate the OFDM TX connections from gnb to each UE RX pathloss block
for ((i=1; i<=NUM_UES; i++)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.digital_ofdm_tx_gnb, 0), (self.blocks_ue${i}_rx_pathloss, 0))
EOL
done

# Dynamically generate the OFDM TX UE connections
for ((i=1; i<=NUM_UES; i++)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.digital_ofdm_tx_ue${i}, 0), (self.blocks_ue${i}_tx_pathloss, 0))
EOL
done

# ZeroMQ TX connections for gNB
cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.zeromq_gnb_tx, 0), (self.digital_constellation_decoder_gnb, 0))
EOL

# Dynamically generate the ZeroMQ TX connections for UEs
for ((i=1; i<=NUM_UES; i++)); do
    cat <<EOL >> "$OUTPUT_FILE"
        self.connect((self.zeromq_ue${i}_tx, 0), (self.digital_constellation_decoder_ue${i}, 0))
EOL
done

# Begin reading UE config file
cat <<EOL >> "$OUTPUT_FILE"
        # Begin reading UE config file
        self.timer = None
        self.start_periodic_config_read()  
EOL

cat <<'EOL' >> "$OUTPUT_FILE"

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

cat <<'EOL' >> "$OUTPUT_FILE"

    def set_ue_variables(self, config_data):
        """Update the UE-specific variables based on the config data."""
        # Example: Update prb and pathloss for each UE
EOL


for ((i=1; i<=NUM_UES; i++))
do
    if [[ $i -eq 1 ]]; then
        cat <<EOL >> "$OUTPUT_FILE"
        if '$i' in config_data:
            self.set_ue${i}_prb(config_data['$i']['prb'])
            self.set_ue${i}_pathloss_db(config_data['$i']['pathloss'])
            # print(f"UE${i} Pathloss: {config_data['$i']['pathloss']} dB")  # Verifies file read functionality 
EOL
    else
        cat <<EOL >> "$OUTPUT_FILE"
        if '$i' in config_data:
            self.set_ue${i}_prb(config_data['$i']['prb'])
            self.set_ue${i}_pathloss_db(config_data['$i']['pathloss'])
EOL
    fi
done

cat <<EOL >> "$OUTPUT_FILE"
        pass
EOL

cat <<EOL >> "$OUTPUT_FILE"

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

for i in $(seq 1 $NUM_UES); do
  cat <<EOL >> "$OUTPUT_FILE"
    def get_ue${i}_prb(self):
        return self.ue${i}_prb

    def set_ue${i}_prb(self, ue${i}_prb):
        self.ue${i}_prb = ue${i}_prb

    def get_ue${i}_pathloss_db(self):
        return self.ue${i}_pathloss_db

    def set_ue${i}_pathloss_db(self, ue${i}_pathloss_db):
        self.ue${i}_pathloss_db = ue${i}_pathloss_db
        self.blocks_ue${i}_rx_pathloss.set_k(10**(-1.0*self.ue${i}_pathloss_db/20.0))
        self.blocks_ue${i}_tx_pathloss.set_k(10**(-1.0*self.ue${i}_pathloss_db/20.0))
EOL
done

cat <<EOL >> "$OUTPUT_FILE"
    def get_total_prb(self):
        return self.total_prb

    def set_total_prb(self, total_prb):
        self.total_prb = total_prb

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate

    def get_max_pathloss_db(self):
        return self.max_pathloss_db

    def set_max_pathloss_db(self, max_pathloss_db):
        self.max_pathloss_db = max_pathloss_db

    def get_fft_length(self):
        return self.fft_length

    def set_fft_length(self, fft_length):
        self.fft_length = fft_length

    def get_constellation_qpsk(self):
        return self.constellation_qpsk

    def set_constellation_qpsk(self, constellation_qpsk):
        self.constellation_qpsk = constellation_qpsk
EOL

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
