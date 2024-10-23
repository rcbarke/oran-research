#!/bin/bash

# Check if the number of UEs is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <number_of_UEs>"
  exit 1
fi

# Number of UEs to configure
num_ues=$1

# Output the first static part of the config
cat <<EOL
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
    value: '11520000'
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
EOL

# Generate the flow graph blocks for each UE
for i in $(seq 1 $num_ues); do
  y_offset_rx=$((76 + ($i - 1) * 96))
  y_offset_tx=$((332 + ($i - 1) * 96))
  ue_rx_port=$((2100 + ($i - 1) * 100))
  ue_tx_port=$((ue_rx_port + 1))

  cat <<EOL
### UE $i Rx Throttle and Pathloss
- name: ue${i}_rx_channel_rate
  id: blocks_throttle
  parameters:
    affinity: ''
    alias: ''
    comment: ''
    ignoretag: 'True'
    maxoutbuf: '0'
    minoutbuf: '0'
    samples_per_second: ue${i}_channel_rate
    type: complex
    vlen: '1'
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [500, $y_offset_rx]
    rotation: 0
    state: true
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
    coordinate: [664, $y_offset_rx]
    rotation: 0
    state: true
- name: zeromq_ue${i}_rx
  id: zeromq_rep_sink
  parameters:
    address: tcp://127.0.0.1:$ue_rx_port
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
    coordinate: [856, $((y_offset_rx - 16))]
    rotation: 0
    state: true

### UE $i Tx Throttle and Pathloss
- name: zeromq_ue${i}_tx
  id: zeromq_req_source
  parameters:
    address: tcp://127.0.0.1:$ue_tx_port
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
    coordinate: [128, $y_offset_tx]
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
    coordinate: [384, $((y_offset_tx + 16))]
    rotation: 0
    state: true
EOL
done

# Generate QT GUI variables
cat <<EOL
#### QT GUI Blocks
### QT GUI Variable for GNB Channel Rate
- name: gnb_channel_rate
  id: variable_qtgui_range
  parameters:
    comment: ''
    gui_hint: ''
    label: GNB Channel Rate
    min_len: '200'
    orient: QtCore.Qt.Horizontal
    rangeType: float
    start: '0'
    step: '1'
    stop: '32'
    value: '4'
    widget: counter_slider
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [1064, 40]
    rotation: 0
    state: true
EOL

# Loop for QT GUI Variables for UEs
for i in $(seq 1 $num_ues); do
  qt_coord_y_rate=$((80 + ($i - 1) * 40))
  qt_coord_y_pathloss=$((20 + ($i - 1) * 150))

  cat <<EOL
### QT GUI Variable for UE $i Channel Rate
- name: ue${i}_channel_rate
  id: variable_qtgui_range
  parameters:
    comment: ''
    gui_hint: ''
    label: UE$i Channel Rate
    min_len: '200'
    orient: QtCore.Qt.Horizontal
    rangeType: float
    start: '0'
    step: '1'
    stop: '32'
    value: '4'
    widget: counter_slider
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [1064, $qt_coord_y_rate]
    rotation: 0
    state: true

### UE $i Pathloss Control
- name: ue${i}_path_loss_db
  id: variable_qtgui_range
  parameters:
    comment: ''
    gui_hint: ''
    label: UE$i Pathloss [dB]
    min_len: '200'
    orient: QtCore.Qt.Horizontal
    rangeType: float
    start: '0'
    step: '1'
    stop: '107.76'
    value: '21.55200000000000000000'
    widget: counter_slider
  states:
    bus_sink: false
    bus_source: false
    bus_structure: null
    coordinate: [1088, $qt_coord_y_pathloss]
    rotation: 0
    state: true
EOL
done

# Final connection blocks
cat <<EOL
connections:
# gNB Tx to all UEs (Flow Graph 1)
- [zeromq_gnb_tx, '0', gnb_tx_channel_rate, '0']
EOL

# Generate the connections for UE Rx paths, referencing the correct outputs from gNB
for i in $(seq 1 $num_ues); do
  cat <<EOL
- [gnb_tx_channel_rate, '0', ue${i}_rx_channel_rate, '0']
- [ue${i}_rx_channel_rate, '0', blocks_ue${i}_rx_pathloss, '0']
- [blocks_ue${i}_rx_pathloss, '0', zeromq_ue${i}_rx, '0']
EOL
done

cat <<EOL
# UE Tx to gNB Rx (Flow Graph 2)
EOL

# Generate the connections for UE Tx paths to gNB
for i in $(seq 1 $num_ues); do
  cat <<EOL
- [zeromq_ue${i}_tx, '0', blocks_ue${i}_tx_pathloss, '0']
- [blocks_ue${i}_tx_pathloss, '0', ue${i}_tx_channel_rate, '0']
- [ue${i}_tx_channel_rate, '0', blocks_ue_tx_to_gnb_rx_add, '$(($i - 1))']
EOL
done

cat <<EOL
- [blocks_ue_tx_to_gnb_rx_add, '0', gnb_rx_channel_rate, '0']
- [gnb_rx_channel_rate, '0', zeromq_gnb_rx, '0']

metadata:
  file_format: 1
EOL

