#!/bin/bash
#
# generate_multi_ue_grc.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory
# ORAN team
#
# Description: This script generates a GNU Radio Companion (.grc) configuration for simulating a multi-UE scenario in a virtualized RAN (Radio Access Network) environment using srsRAN.
#
# Architecture:
# 1. srsRAN gNB: Disaggregated CU/DU with ZeroMQ message transport
# 2. Multiple srsUE Instances: Connected via ZeroMQ for each UE
#
# Signal Modulation:
# - gnuradio: Modulated RF waveform for all UEs with configurable path loss
#
# Features:
# 1. Dynamic generation of GNU Radio blocks for a configurable number of UEs.
# 2. Path loss control for each UE, calculated as a proportion of the maximum path loss
# 3. Throttling mechanism to simulate real-time processing with adjustable sample rate.
# 4. Configurable via CLI for the number of UEs to simulate.
#
# Script Flow:
# - Accepts the number of UEs as a CLI argument.
# - Dynamically generates the corresponding GNU Radio Companion (.grc) file with correct port assignments, path loss distribution, and connection between UEs and gNB.
# - Writes the generated configuration to ./configs/multi_ue_scenario.grc.
#
# Pre-Conditions and Assumptions:
# 1. GNU Radio and srsRAN are installed and configured on the host machine.
# 2. ZeroMQ is used for inter-process communication between gNB and UEs.
#
# Required CLI Arguments:
# 1. num_ues: Specify the total number of UEs to include in the simulation. Default = 3.

# Usage check
if [ -z "$1" ]; then
  echo "Usage: $0 <num_ues>"
  echo "Please provide the number of UEs as a required argument."
  exit 1
fi

# Variables for user-defined values
num_ues=$1
samp_rate=11520000
slow_down_ratio=4
max_path_loss=107.76

# Ensure the output directory exists
mkdir -p ./configs

# Redirect output to the GRC file
output_file="./configs/multi_ue_scenario.grc"
exec > $output_file

# Static Header Blocks
cat <<EOF
options:
  parameters:
    author: ''
    catch_exceptions: 'True'
    category: '[GRC Hier Blocks]'
    cmake_opt: ''
    comment: ''
    copyright: ''
    description: ''
    gen_cmake: 'On'
    gen_linking: dynamic
    generate_options: qt_gui
    hier_block_src_path: '.:'
    id: multi_ue_scenario
    max_nouts: '0'
    output_language: python
    placement: (0,0)
    qt_qss_theme: ''
    realtime_scheduling: ''
    run: 'True'
    run_command: '{python} -u {filename}'
    run_options: prompt
    sizing_mode: fixed
    thread_safe_setters: ''
    title: srsRAN_multi_UE
    window_size: (1000,1000)
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [8, 8]
    rotation: 0
    state: enabled
blocks:
- name: samp_rate
  id: variable
  parameters:
    comment: ''
    value: '$samp_rate'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [184, 12]
    rotation: 0
    state: enabled
- name: zmq_hwm
  id: variable
  parameters:
    comment: ''
    value: '-1'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [432, 12.0]
    rotation: 0
    state: enabled
- name: zmq_timeout
  id: variable
  parameters:
    comment: ''
    value: '100'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [304, 12.0]
    rotation: 0
    state: enabled

#### FLOW GRAPH 1: gnb_tx -> ue_rx
- name: zeromq_gnb_tx
  id: zeromq_req_source
  parameters:
    address: tcp://127.0.0.1:2000
    affinity: ''
    alias: ''
    comment: ''
    hwm: zmq_hwm
    maxoutbuf: '0'
    minoutbuf: '0'
    pass_tags: 'False'
    timeout: zmq_timeout
    type: complex
    vlen: '1'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [128, 156.0]
    rotation: 0
    state: true
- name: blocks_throttle_gnb_tx_to_ue_rx
  id: blocks_throttle
  parameters:
    affinity: ''
    alias: ''
    comment: ''
    ignoretag: 'True'
    maxoutbuf: '0'
    minoutbuf: '0'
    samples_per_second: 1.0*samp_rate/(1.0*slow_down_ratio)
    type: complex
    vlen: '1'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [392, 172.0]
    rotation: 0
    state: true
EOF

# Generate dynamic UE blocks for Flow Graph 1 (gnb_tx -> ue_rx)
for ((i=1; i<=$num_ues; i++))
do
  ue_port=$((2000 + $i*100))
  ue_rx_port=$((ue_port))
  ue_tx_port=$((ue_port + 1))

  cat <<EOF
### UE $i Rx Pathloss and Sink Blocks
- name: blocks_ue${i}_rx_pathloss
  id: blocks_multiply_const_vxx
  parameters:
    affinity: ''
    alias: ''
    comment: ''
    const: 10**(-1.0*ue${i}_path_loss_db/20.0)
    maxoutbuf: '0'
    minoutbuf: '0'
    type: complex
    vlen: '1'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [664, $((76 + ($i - 1)*96)).0]
    rotation: 0
    state: true

- name: zeromq_ue${i}_rx
  id: zeromq_rep_sink
  parameters:
    address: tcp://127.0.0.1:${ue_rx_port}
    affinity: ''
    alias: ''
    comment: ''
    hwm: zmq_hwm
    pass_tags: 'False'
    timeout: zmq_timeout
    type: complex
    vlen: '1'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [856, $((60 + ($i - 1)*96)).0]
    rotation: 0
    state: true
EOF
done

# Flow Graph 2: ue_tx -> gnb_rx
cat <<EOF
#### FLOW GRAPH 2: ue_tx -> gnb_rx
EOF

# Generate dynamic UE Tx blocks for Flow Graph 2 (ue_tx -> gnb_rx)
for ((i=1; i<=$num_ues; i++))
do
  ue_tx_port=$((2001 + i*100))

  cat <<EOF
### UE $i Tx Pathloss and Source Blocks
- name: zeromq_ue${i}_tx
  id: zeromq_req_source
  parameters:
    address: tcp://127.0.0.1:${ue_tx_port}
    affinity: ''
    alias: ''
    comment: ''
    hwm: zmq_hwm
    maxoutbuf: '0'
    minoutbuf: '0'
    pass_tags: 'False'
    timeout: zmq_timeout
    type: complex
    vlen: '1'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [128, $((332 + ($i - 1)*88)).0]
    rotation: 0
    state: true

- name: blocks_ue${i}_tx_pathloss
  id: blocks_multiply_const_vxx
  parameters:
    affinity: ''
    alias: ''
    comment: ''
    const: 10**(-1.0*ue${i}_path_loss_db/20.0)
    maxoutbuf: '0'
    minoutbuf: '0'
    type: complex
    vlen: '1'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [384, $((348 + ($i - 1)*88)).0]
    rotation: 0
    state: true
EOF
done

# Static blocks for gNB Rx (common to all UEs)
cat <<EOF
### gNB Rx Combine and Sink Block
- name: blocks_ue_tx_to_gnb_rx_add
  id: blocks_add_xx
  parameters:
    affinity: ''
    alias: ''
    comment: ''
    maxoutbuf: '0'
    minoutbuf: '0'
    num_inputs: '$num_ues'
    type: complex
    vlen: '1'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [648, 408.0]
    rotation: 0
    state: true

- name: zeromq_gnb_rx
  id: zeromq_rep_sink
  parameters:
    address: tcp://127.0.0.1:2001
    affinity: ''
    alias: ''
    comment: ''
    hwm: zmq_hwm
    pass_tags: 'False'
    timeout: zmq_timeout
    type: complex
    vlen: '1'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [856, 420.0]
    rotation: 0
    state: true
EOF

# QT GUI Blocks for controlling the simulation
cat <<EOF
#### QT GUI Blocks
### Static
- name: slow_down_ratio
  id: variable_qtgui_range
  parameters:
    comment: ''
    gui_hint: ''
    label: Time Slow Down Ratio
    min_len: '200'
    orient: QtCore.Qt.Horizontal
    rangeType: float
    start: '1'
    step: '1'
    stop: '32'
    value: '$slow_down_ratio'
    widget: counter_slider
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [1064, 468]
    rotation: 0
    state: true
EOF

# Generate dynamic UE pathloss blocks for QT GUI
for ((i=1; i<=$num_ues; i++))
do
  # Calculate path loss based on the formula i/n * max_path_loss
  default_path_loss=$(echo "$i/$num_ues * $max_path_loss" | bc -l)

  cat <<EOF
### UE $i Pathloss Control
- name: ue${i}_path_loss_db
  id: variable_qtgui_range
  parameters:
    comment: ''
    gui_hint: ''
    label: UE${i} Pathloss [dB]
    min_len: '200'
    orient: QtCore.Qt.Horizontal
    rangeType: float
    start: '0'
    step: '1'
    stop: '$max_path_loss'
    value: '${default_path_loss}'
    widget: counter_slider
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [1088, $((20 + ($i - 1)*150)).0]
    rotation: 0
    state: true
EOF
done

# Generate the connections for all UEs in the flow graphs
cat <<EOF
connections:
#### Flow Graph 1 Connections: gnb_tx to ue_rx
EOF

for ((i=1; i<=$num_ues; i++))
do
  cat <<EOF
- [zeromq_gnb_tx, '0', blocks_throttle_gnb_tx_to_ue_rx, '0']
- [blocks_throttle_gnb_tx_to_ue_rx, '0', blocks_ue${i}_rx_pathloss, '0']
- [blocks_ue${i}_rx_pathloss, '0', zeromq_ue${i}_rx, '0']
EOF
done

cat <<EOF
#### Flow Graph 2 Connections: ue_tx to gnb_rx
EOF

for ((i=1; i<=$num_ues; i++))
do
  cat <<EOF
- [zeromq_ue${i}_tx, '0', blocks_ue${i}_tx_pathloss, '0']
- [blocks_ue${i}_tx_pathloss, '0', blocks_ue_tx_to_gnb_rx_add, '$((i - 1))']
EOF
done

cat <<EOF
- [blocks_ue_tx_to_gnb_rx_add, '0', zeromq_gnb_rx, '0']

metadata:
  file_format: 1
EOF
