#!/bin/bash

# Shell script to generate the multi_ue_scenario.py file

# Check for the number of UEs passed as argument
if [ -z "$1" ]; then
  echo "Usage: $0 <number_of_UEs>"
  exit 1
fi

# Number of UEs
num_ue=$1

# Output file name
output_file="multi_ue_scenario.py"

# Write the header of the Python script
cat > $output_file <<EOL
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: srsRAN_multi_UE
# GNU Radio version: 3.10.1.1

from packaging.version import Version as StrictVersion

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print("Warning: failed to XInitThreads()")

from gnuradio import blocks
from gnuradio import digital
from gnuradio import gr
from gnuradio.filter import firdes
from gnuradio.fft import window
import sys
import signal
from PyQt5 import Qt
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import zeromq
from gnuradio.qtgui import Range, RangeWidget
from PyQt5 import QtCore



from gnuradio import qtgui

class multi_ue_scenario(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "srsRAN_multi_UE", catch_exceptions=True)
        Qt.QWidget.__init__(self)
        self.setWindowTitle("srsRAN_multi_UE")
        qtgui.util.check_set_qss()
        try:
            self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
        except:
            pass
        self.top_scroll_layout = Qt.QVBoxLayout()
        self.setLayout(self.top_scroll_layout)
        self.top_scroll = Qt.QScrollArea()
        self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
        self.top_scroll_layout.addWidget(self.top_scroll)
        self.top_scroll.setWidgetResizable(True)
        self.top_widget = Qt.QWidget()
        self.top_scroll.setWidget(self.top_widget)
        self.top_layout = Qt.QVBoxLayout(self.top_widget)
        self.top_grid_layout = Qt.QGridLayout()
        self.top_layout.addLayout(self.top_grid_layout)

        self.settings = Qt.QSettings("GNU Radio", "multi_ue_scenario")

        try:
            if StrictVersion(Qt.qVersion()) < StrictVersion("5.0.0"):
                self.restoreGeometry(self.settings.value("geometry").toByteArray())
            else:
                self.restoreGeometry(self.settings.value("geometry"))
        except:
            pass

        ##################################################
        # Variables
        ##################################################
        self.zmq_timeout = zmq_timeout = 100
        self.zmq_hwm = zmq_hwm = -1
        self.ue5_path_loss_db = ue5_path_loss_db = 10e6
        self.ue4_path_loss_db = ue4_path_loss_db = 86.20800000000000000000
        self.ue3_path_loss_db = ue3_path_loss_db = 64.65600000000000000000
        self.ue2_path_loss_db = ue2_path_loss_db = 43.10400000000000000000
        self.ue1_path_loss_db = ue1_path_loss_db = 21.55200000000000000000
        self.samp_rate = samp_rate = 11520000
        self.constellation_qpsk = constellation_qpsk = digital.constellation_qpsk().base()

        ##################################################
        # Blocks
        ##################################################
        self._ue5_path_loss_db_range = Range(0, 100e6, 1, 10e6, 200)
        self._ue5_path_loss_db_win = RangeWidget(self._ue5_path_loss_db_range, self.set_ue5_path_loss_db, "UE5 Pathloss [dB]", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._ue5_path_loss_db_win)
        self._ue4_path_loss_db_range = Range(0, 107.76, 1, 86.20800000000000000000, 200)
        self._ue4_path_loss_db_win = RangeWidget(self._ue4_path_loss_db_range, self.set_ue4_path_loss_db, "UE4 Pathloss [dB]", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._ue4_path_loss_db_win)
        self._ue3_path_loss_db_range = Range(0, 107.76, 1, 64.65600000000000000000, 200)
        self._ue3_path_loss_db_win = RangeWidget(self._ue3_path_loss_db_range, self.set_ue3_path_loss_db, "UE3 Pathloss [dB]", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._ue3_path_loss_db_win)
        self._ue2_path_loss_db_range = Range(0, 107.76, 1, 43.10400000000000000000, 200)
        self._ue2_path_loss_db_win = RangeWidget(self._ue2_path_loss_db_range, self.set_ue2_path_loss_db, "UE2 Pathloss [dB]", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._ue2_path_loss_db_win)
        self._ue1_path_loss_db_range = Range(0, 107.76, 1, 21.55200000000000000000, 200)
        self._ue1_path_loss_db_win = RangeWidget(self._ue1_path_loss_db_range, self.set_ue1_path_loss_db, "UE1 Pathloss [dB]", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._ue1_path_loss_db_win)
        self.zeromq_ue5_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2501', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue5_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2500', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue4_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2401', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue4_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2400', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue3_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2301', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue3_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2300', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue2_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2201', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue2_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2200', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue1_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2101', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue1_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2100', zmq_timeout, False, zmq_hwm)
        self.zeromq_gnb_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2000', zmq_timeout, False, zmq_hwm)
        self.zeromq_gnb_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2001', zmq_timeout, False, zmq_hwm)
        self.digital_ofdm_tx_0_4_3_0 = digital.ofdm_tx(
            fft_len=1024,
            cp_len=72,
            packet_length_tag_key='length',
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_tx_0_4_3 = digital.ofdm_tx(
            fft_len=1024,
            cp_len=72,
            packet_length_tag_key='length',
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_tx_0_4_2 = digital.ofdm_tx(
            fft_len=1024,
            cp_len=72,
            packet_length_tag_key='length',
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_tx_0_4_1 = digital.ofdm_tx(
            fft_len=1024,
            cp_len=72,
            packet_length_tag_key='length',
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_tx_0_4_0 = digital.ofdm_tx(
            fft_len=1024,
            cp_len=72,
            packet_length_tag_key='length',
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_tx_0_4 = digital.ofdm_tx(
            fft_len=1024,
            cp_len=72,
            packet_length_tag_key='length',
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_1_0_4 = digital.ofdm_rx(
            fft_len=1024, cp_len=72,
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_1_0_3 = digital.ofdm_rx(
            fft_len=1024, cp_len=72,
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_1_0_2 = digital.ofdm_rx(
            fft_len=1024, cp_len=72,
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_1_0_1 = digital.ofdm_rx(
            fft_len=1024, cp_len=72,
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_1_0_0 = digital.ofdm_rx(
            fft_len=1024, cp_len=72,
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_1_0 = digital.ofdm_rx(
            fft_len=1024, cp_len=72,
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(-312, 0)) + list(range(1, 312))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * 1024,
            sync_word2=[1] * 1024,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_constellation_encoder_bc_0_4 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_encoder_bc_0_3 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_encoder_bc_0_2 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_encoder_bc_0_1 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_encoder_bc_0_0 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_encoder_bc_0 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_decoder_cb_0_4 = digital.constellation_decoder_cb(constellation_qpsk)
        self.digital_constellation_decoder_cb_0_3 = digital.constellation_decoder_cb(constellation_qpsk)
        self.digital_constellation_decoder_cb_0_2 = digital.constellation_decoder_cb(constellation_qpsk)
        self.digital_constellation_decoder_cb_0_1 = digital.constellation_decoder_cb(constellation_qpsk)
        self.digital_constellation_decoder_cb_0_0 = digital.constellation_decoder_cb(constellation_qpsk)
        self.digital_constellation_decoder_cb_0 = digital.constellation_decoder_cb(constellation_qpsk)
        self.blocks_ue_tx_to_gnb_rx_add = blocks.add_vcc(1)
        self.blocks_ue5_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue5_path_loss_db/20.0))
        self.blocks_ue5_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue5_path_loss_db/20.0))
        self.blocks_ue4_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue4_path_loss_db/20.0))
        self.blocks_ue4_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue4_path_loss_db/20.0))
        self.blocks_ue3_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue3_path_loss_db/20.0))
        self.blocks_ue3_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue3_path_loss_db/20.0))
        self.blocks_ue2_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue2_path_loss_db/20.0))
        self.blocks_ue2_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue2_path_loss_db/20.0))
        self.blocks_ue1_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue1_path_loss_db/20.0))
        self.blocks_ue1_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue1_path_loss_db/20.0))


        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_ue1_rx_pathloss, 0), (self.digital_ofdm_rx_1_0, 0))
        self.connect((self.blocks_ue1_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 0))
        self.connect((self.blocks_ue2_rx_pathloss, 0), (self.digital_ofdm_rx_1_0_0, 0))
        self.connect((self.blocks_ue2_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 1))
        self.connect((self.blocks_ue3_rx_pathloss, 0), (self.digital_ofdm_rx_1_0_1, 0))
        self.connect((self.blocks_ue3_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 2))
        self.connect((self.blocks_ue4_rx_pathloss, 0), (self.digital_ofdm_rx_1_0_2, 0))
        self.connect((self.blocks_ue4_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 3))
        self.connect((self.blocks_ue5_rx_pathloss, 0), (self.digital_ofdm_rx_1_0_3, 0))
        self.connect((self.blocks_ue5_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 4))
        self.connect((self.blocks_ue_tx_to_gnb_rx_add, 0), (self.digital_ofdm_rx_1_0_4, 0))
        self.connect((self.digital_constellation_decoder_cb_0, 0), (self.digital_ofdm_tx_0_4, 0))
        self.connect((self.digital_constellation_decoder_cb_0_0, 0), (self.digital_ofdm_tx_0_4_0, 0))
        self.connect((self.digital_constellation_decoder_cb_0_1, 0), (self.digital_ofdm_tx_0_4_1, 0))
        self.connect((self.digital_constellation_decoder_cb_0_2, 0), (self.digital_ofdm_tx_0_4_2, 0))
        self.connect((self.digital_constellation_decoder_cb_0_3, 0), (self.digital_ofdm_tx_0_4_3, 0))
        self.connect((self.digital_constellation_decoder_cb_0_4, 0), (self.digital_ofdm_tx_0_4_3_0, 0))
        self.connect((self.digital_constellation_encoder_bc_0, 0), (self.zeromq_ue1_rx, 0))
        self.connect((self.digital_constellation_encoder_bc_0_0, 0), (self.zeromq_ue2_rx, 0))
        self.connect((self.digital_constellation_encoder_bc_0_1, 0), (self.zeromq_ue3_rx, 0))
        self.connect((self.digital_constellation_encoder_bc_0_2, 0), (self.zeromq_ue4_rx, 0))
        self.connect((self.digital_constellation_encoder_bc_0_3, 0), (self.zeromq_ue5_rx, 0))
        self.connect((self.digital_constellation_encoder_bc_0_4, 0), (self.zeromq_gnb_rx, 0))
        self.connect((self.digital_ofdm_rx_1_0, 0), (self.digital_constellation_encoder_bc_0, 0))
        self.connect((self.digital_ofdm_rx_1_0_0, 0), (self.digital_constellation_encoder_bc_0_0, 0))
        self.connect((self.digital_ofdm_rx_1_0_1, 0), (self.digital_constellation_encoder_bc_0_1, 0))
        self.connect((self.digital_ofdm_rx_1_0_2, 0), (self.digital_constellation_encoder_bc_0_2, 0))
        self.connect((self.digital_ofdm_rx_1_0_3, 0), (self.digital_constellation_encoder_bc_0_3, 0))
        self.connect((self.digital_ofdm_rx_1_0_4, 0), (self.digital_constellation_encoder_bc_0_4, 0))
        self.connect((self.digital_ofdm_tx_0_4, 0), (self.blocks_ue1_rx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_0_4, 0), (self.blocks_ue2_rx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_0_4, 0), (self.blocks_ue3_rx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_0_4, 0), (self.blocks_ue4_rx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_0_4, 0), (self.blocks_ue5_rx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_0_4_0, 0), (self.blocks_ue1_tx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_0_4_1, 0), (self.blocks_ue2_tx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_0_4_2, 0), (self.blocks_ue3_tx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_0_4_3, 0), (self.blocks_ue4_tx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_0_4_3_0, 0), (self.blocks_ue5_tx_pathloss, 0))
        self.connect((self.zeromq_gnb_tx, 0), (self.digital_constellation_decoder_cb_0, 0))
        self.connect((self.zeromq_ue1_tx, 0), (self.digital_constellation_decoder_cb_0_0, 0))
        self.connect((self.zeromq_ue2_tx, 0), (self.digital_constellation_decoder_cb_0_1, 0))
        self.connect((self.zeromq_ue3_tx, 0), (self.digital_constellation_decoder_cb_0_2, 0))
        self.connect((self.zeromq_ue4_tx, 0), (self.digital_constellation_decoder_cb_0_3, 0))
        self.connect((self.zeromq_ue5_tx, 0), (self.digital_constellation_decoder_cb_0_4, 0))


    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "multi_ue_scenario")
        self.settings.setValue("geometry", self.saveGeometry())
        self.stop()
        self.wait()

        event.accept()

    def get_zmq_timeout(self):
        return self.zmq_timeout

    def set_zmq_timeout(self, zmq_timeout):
        self.zmq_timeout = zmq_timeout

    def get_zmq_hwm(self):
        return self.zmq_hwm

    def set_zmq_hwm(self, zmq_hwm):
        self.zmq_hwm = zmq_hwm

    def get_ue5_path_loss_db(self):
        return self.ue5_path_loss_db

    def set_ue5_path_loss_db(self, ue5_path_loss_db):
        self.ue5_path_loss_db = ue5_path_loss_db
        self.blocks_ue5_rx_pathloss.set_k(10**(-1.0*self.ue5_path_loss_db/20.0))
        self.blocks_ue5_tx_pathloss.set_k(10**(-1.0*self.ue5_path_loss_db/20.0))

    def get_ue4_path_loss_db(self):
        return self.ue4_path_loss_db

    def set_ue4_path_loss_db(self, ue4_path_loss_db):
        self.ue4_path_loss_db = ue4_path_loss_db
        self.blocks_ue4_rx_pathloss.set_k(10**(-1.0*self.ue4_path_loss_db/20.0))
        self.blocks_ue4_tx_pathloss.set_k(10**(-1.0*self.ue4_path_loss_db/20.0))

    def get_ue3_path_loss_db(self):
        return self.ue3_path_loss_db

    def set_ue3_path_loss_db(self, ue3_path_loss_db):
        self.ue3_path_loss_db = ue3_path_loss_db
        self.blocks_ue3_rx_pathloss.set_k(10**(-1.0*self.ue3_path_loss_db/20.0))
        self.blocks_ue3_tx_pathloss.set_k(10**(-1.0*self.ue3_path_loss_db/20.0))

    def get_ue2_path_loss_db(self):
        return self.ue2_path_loss_db

    def set_ue2_path_loss_db(self, ue2_path_loss_db):
        self.ue2_path_loss_db = ue2_path_loss_db
        self.blocks_ue2_rx_pathloss.set_k(10**(-1.0*self.ue2_path_loss_db/20.0))
        self.blocks_ue2_tx_pathloss.set_k(10**(-1.0*self.ue2_path_loss_db/20.0))

    def get_ue1_path_loss_db(self):
        return self.ue1_path_loss_db

    def set_ue1_path_loss_db(self, ue1_path_loss_db):
        self.ue1_path_loss_db = ue1_path_loss_db
        self.blocks_ue1_rx_pathloss.set_k(10**(-1.0*self.ue1_path_loss_db/20.0))
        self.blocks_ue1_tx_pathloss.set_k(10**(-1.0*self.ue1_path_loss_db/20.0))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate

    def get_constellation_qpsk(self):
        return self.constellation_qpsk

    def set_constellation_qpsk(self, constellation_qpsk):
        self.constellation_qpsk = constellation_qpsk




def main(top_block_cls=multi_ue_scenario, options=None):

    if StrictVersion("4.5.0") <= StrictVersion(Qt.qVersion()) < StrictVersion("5.0.0"):
        style = gr.prefs().get_string('qtgui', 'style', 'raster')
        Qt.QApplication.setGraphicsSystem(style)
    qapp = Qt.QApplication(sys.argv)

    tb = top_block_cls()

    tb.start()

    tb.show()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        Qt.QApplication.quit()

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    timer = Qt.QTimer()
    timer.start(500)
    timer.timeout.connect(lambda: None)

    qapp.exec_()

if __name__ == '__main__':
    main()
EOF


# Make the output Python file executable
chmod +x $output_file
echo "Generated $output_file for $num_ue UEs"
