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

    def __init__(self):
        gr.top_block.__init__(self, "srsRAN_multi_UE", catch_exceptions=True)

        ##################################################
        # Variables
        ##################################################
        self.zmq_timeout = zmq_timeout = 100
        self.zmq_hwm = zmq_hwm = -1
        self.ue30_slow_down_ratio = ue30_slow_down_ratio = 1
        self.ue30_path_loss_db = ue30_path_loss_db = 0
        self.ue29_slow_down_ratio = ue29_slow_down_ratio = 1
        self.ue29_path_loss_db = ue29_path_loss_db = 0
        self.ue28_slow_down_ratio = ue28_slow_down_ratio = 1
        self.ue28_path_loss_db = ue28_path_loss_db = 0
        self.ue27_slow_down_ratio = ue27_slow_down_ratio = 1
        self.ue27_path_loss_db = ue27_path_loss_db = 0
        self.ue26_slow_down_ratio = ue26_slow_down_ratio = 1
        self.ue26_path_loss_db = ue26_path_loss_db = 0
        self.ue25_slow_down_ratio = ue25_slow_down_ratio = 1
        self.ue25_path_loss_db = ue25_path_loss_db = 0
        self.ue24_slow_down_ratio = ue24_slow_down_ratio = 1
        self.ue24_path_loss_db = ue24_path_loss_db = 0
        self.ue23_slow_down_ratio = ue23_slow_down_ratio = 1
        self.ue23_path_loss_db = ue23_path_loss_db = 0
        self.ue22_slow_down_ratio = ue22_slow_down_ratio = 1
        self.ue22_path_loss_db = ue22_path_loss_db = 0
        self.ue21_slow_down_ratio = ue21_slow_down_ratio = 1
        self.ue21_path_loss_db = ue21_path_loss_db = 0
        self.ue20_slow_down_ratio = ue20_slow_down_ratio = 1
        self.ue20_path_loss_db = ue20_path_loss_db = 0
        self.ue19_slow_down_ratio = ue19_slow_down_ratio = 1
        self.ue19_path_loss_db = ue19_path_loss_db = 0
        self.ue18_slow_down_ratio = ue18_slow_down_ratio = 1
        self.ue18_path_loss_db = ue18_path_loss_db = 0
        self.ue17_slow_down_ratio = ue17_slow_down_ratio = 1
        self.ue17_path_loss_db = ue17_path_loss_db = 0
        self.ue16_slow_down_ratio = ue16_slow_down_ratio = 1
        self.ue16_path_loss_db = ue16_path_loss_db = 0
        self.ue15_slow_down_ratio = ue15_slow_down_ratio = 1
        self.ue15_path_loss_db = ue15_path_loss_db = 0
        self.ue14_slow_down_ratio = ue14_slow_down_ratio = 1
        self.ue14_path_loss_db = ue14_path_loss_db = 0
        self.ue13_slow_down_ratio = ue13_slow_down_ratio = 1
        self.ue13_path_loss_db = ue13_path_loss_db = 0
        self.ue12_slow_down_ratio = ue12_slow_down_ratio = 1
        self.ue12_path_loss_db = ue12_path_loss_db = 0
        self.ue11_slow_down_ratio = ue11_slow_down_ratio = 1
        self.ue11_path_loss_db = ue11_path_loss_db = 0
        self.ue10_slow_down_ratio = ue10_slow_down_ratio = 1
        self.ue10_path_loss_db = ue10_path_loss_db = 0
        self.ue9_slow_down_ratio = ue9_slow_down_ratio = 1
        self.ue9_path_loss_db = ue9_path_loss_db = 0
        self.ue8_slow_down_ratio = ue8_slow_down_ratio = 1
        self.ue8_path_loss_db = ue8_path_loss_db = 0
        self.ue7_slow_down_ratio = ue7_slow_down_ratio = 1
        self.ue7_path_loss_db = ue7_path_loss_db = 0
        self.ue6_slow_down_ratio = ue6_slow_down_ratio = 1
        self.ue6_path_loss_db = ue6_path_loss_db = 0
        self.ue5_slow_down_ratio = ue5_slow_down_ratio = 1
        self.ue5_path_loss_db = ue5_path_loss_db = 0
        self.ue4_slow_down_ratio = ue4_slow_down_ratio = 1
        self.ue4_path_loss_db = ue4_path_loss_db = 0
        self.ue3_slow_down_ratio = ue3_slow_down_ratio = 1
        self.ue3_path_loss_db = ue3_path_loss_db = 0
        self.ue2_slow_down_ratio = ue2_slow_down_ratio = 1
        self.ue2_path_loss_db = ue2_path_loss_db = 0
        self.ue1_slow_down_ratio = ue1_slow_down_ratio = 1
        self.ue1_path_loss_db = ue1_path_loss_db = 0
        self.samp_rate = samp_rate = 9360000
        self.gnb_slow_down_ratio = gnb_slow_down_ratio = 1

        ##################################################
        # Blocks
        ##################################################
        self.zeromq_ue30_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:5001', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue30_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:5000', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue29_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4901', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue29_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4900', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue28_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4801', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue28_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4800', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue27_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4701', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue27_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4700', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue26_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4601', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue26_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4600', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue25_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4501', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue25_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4500', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue24_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4401', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue24_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4400', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue23_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4301', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue23_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4300', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue22_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4201', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue22_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4200', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue21_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4101', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue21_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4100', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue20_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4001', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue20_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:4000', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue19_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3901', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue19_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3900', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue18_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3801', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue18_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3800', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue17_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3701', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue17_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3700', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue16_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3601', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue16_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3600', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue15_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3501', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue15_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3500', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue14_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3401', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue14_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3400', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue13_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3301', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue13_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3300', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue12_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3201', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue12_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3200', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue11_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3101', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue11_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3100', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue10_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3001', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue10_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:3000', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue9_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2901', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue9_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2900', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue8_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2801', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue8_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2800', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue7_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2701', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue7_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2700', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue6_tx = zeromq.req_source(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2601', zmq_timeout, False, zmq_hwm)
        self.zeromq_ue6_rx = zeromq.rep_sink(gr.sizeof_gr_complex, 1, 'tcp://127.0.0.1:2600', zmq_timeout, False, zmq_hwm)
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
        self.blocks_ue_tx_to_gnb_rx_add = blocks.add_vcc(1)
        self.blocks_ue30_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue30_path_loss_db/20.0))
        self.blocks_ue30_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue30_path_loss_db/20.0))
        self.blocks_ue29_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue29_path_loss_db/20.0))
        self.blocks_ue29_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue29_path_loss_db/20.0))
        self.blocks_ue28_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue28_path_loss_db/20.0))
        self.blocks_ue28_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue28_path_loss_db/20.0))
        self.blocks_ue27_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue27_path_loss_db/20.0))
        self.blocks_ue27_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue27_path_loss_db/20.0))
        self.blocks_ue26_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue26_path_loss_db/20.0))
        self.blocks_ue26_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue26_path_loss_db/20.0))
        self.blocks_ue25_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue25_path_loss_db/20.0))
        self.blocks_ue25_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue25_path_loss_db/20.0))
        self.blocks_ue24_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue24_path_loss_db/20.0))
        self.blocks_ue24_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue24_path_loss_db/20.0))
        self.blocks_ue23_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue23_path_loss_db/20.0))
        self.blocks_ue23_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue23_path_loss_db/20.0))
        self.blocks_ue22_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue22_path_loss_db/20.0))
        self.blocks_ue22_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue22_path_loss_db/20.0))
        self.blocks_ue21_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue21_path_loss_db/20.0))
        self.blocks_ue21_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue21_path_loss_db/20.0))
        self.blocks_ue20_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue20_path_loss_db/20.0))
        self.blocks_ue20_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue20_path_loss_db/20.0))
        self.blocks_ue19_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue19_path_loss_db/20.0))
        self.blocks_ue19_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue19_path_loss_db/20.0))
        self.blocks_ue18_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue18_path_loss_db/20.0))
        self.blocks_ue18_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue18_path_loss_db/20.0))
        self.blocks_ue17_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue17_path_loss_db/20.0))
        self.blocks_ue17_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue17_path_loss_db/20.0))
        self.blocks_ue16_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue16_path_loss_db/20.0))
        self.blocks_ue16_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue16_path_loss_db/20.0))
        self.blocks_ue15_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue15_path_loss_db/20.0))
        self.blocks_ue15_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue15_path_loss_db/20.0))
        self.blocks_ue14_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue14_path_loss_db/20.0))
        self.blocks_ue14_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue14_path_loss_db/20.0))
        self.blocks_ue13_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue13_path_loss_db/20.0))
        self.blocks_ue13_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue13_path_loss_db/20.0))
        self.blocks_ue12_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue12_path_loss_db/20.0))
        self.blocks_ue12_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue12_path_loss_db/20.0))
        self.blocks_ue11_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue11_path_loss_db/20.0))
        self.blocks_ue11_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue11_path_loss_db/20.0))
        self.blocks_ue10_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue10_path_loss_db/20.0))
        self.blocks_ue10_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue10_path_loss_db/20.0))
        self.blocks_ue9_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue9_path_loss_db/20.0))
        self.blocks_ue9_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue9_path_loss_db/20.0))
        self.blocks_ue8_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue8_path_loss_db/20.0))
        self.blocks_ue8_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue8_path_loss_db/20.0))
        self.blocks_ue7_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue7_path_loss_db/20.0))
        self.blocks_ue7_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue7_path_loss_db/20.0))
        self.blocks_ue6_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue6_path_loss_db/20.0))
        self.blocks_ue6_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue6_path_loss_db/20.0))
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
        self.blocks_throttle_ue30_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue30_slow_down_ratio),True)
        self.blocks_throttle_ue30_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue30_slow_down_ratio),True)
        self.blocks_throttle_ue29_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue29_slow_down_ratio),True)
        self.blocks_throttle_ue29_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue29_slow_down_ratio),True)
        self.blocks_throttle_ue28_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue28_slow_down_ratio),True)
        self.blocks_throttle_ue28_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue28_slow_down_ratio),True)
        self.blocks_throttle_ue27_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue27_slow_down_ratio),True)
        self.blocks_throttle_ue27_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue27_slow_down_ratio),True)
        self.blocks_throttle_ue26_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue26_slow_down_ratio),True)
        self.blocks_throttle_ue26_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue26_slow_down_ratio),True)
        self.blocks_throttle_ue25_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue25_slow_down_ratio),True)
        self.blocks_throttle_ue25_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue25_slow_down_ratio),True)
        self.blocks_throttle_ue24_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue24_slow_down_ratio),True)
        self.blocks_throttle_ue24_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue24_slow_down_ratio),True)
        self.blocks_throttle_ue23_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue23_slow_down_ratio),True)
        self.blocks_throttle_ue23_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue23_slow_down_ratio),True)
        self.blocks_throttle_ue22_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue22_slow_down_ratio),True)
        self.blocks_throttle_ue22_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue22_slow_down_ratio),True)
        self.blocks_throttle_ue21_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue21_slow_down_ratio),True)
        self.blocks_throttle_ue21_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue21_slow_down_ratio),True)
        self.blocks_throttle_ue20_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue20_slow_down_ratio),True)
        self.blocks_throttle_ue20_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue20_slow_down_ratio),True)
        self.blocks_throttle_ue19_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue19_slow_down_ratio),True)
        self.blocks_throttle_ue19_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue19_slow_down_ratio),True)
        self.blocks_throttle_ue18_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue18_slow_down_ratio),True)
        self.blocks_throttle_ue18_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue18_slow_down_ratio),True)
        self.blocks_throttle_ue17_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue17_slow_down_ratio),True)
        self.blocks_throttle_ue17_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue17_slow_down_ratio),True)
        self.blocks_throttle_ue16_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue16_slow_down_ratio),True)
        self.blocks_throttle_ue16_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue16_slow_down_ratio),True)
        self.blocks_throttle_ue15_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue15_slow_down_ratio),True)
        self.blocks_throttle_ue15_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue15_slow_down_ratio),True)
        self.blocks_throttle_ue14_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue14_slow_down_ratio),True)
        self.blocks_throttle_ue14_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue14_slow_down_ratio),True)
        self.blocks_throttle_ue13_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue13_slow_down_ratio),True)
        self.blocks_throttle_ue13_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue13_slow_down_ratio),True)
        self.blocks_throttle_ue12_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue12_slow_down_ratio),True)
        self.blocks_throttle_ue12_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue12_slow_down_ratio),True)
        self.blocks_throttle_ue11_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue11_slow_down_ratio),True)
        self.blocks_throttle_ue11_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue11_slow_down_ratio),True)
        self.blocks_throttle_ue10_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue10_slow_down_ratio),True)
        self.blocks_throttle_ue10_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue10_slow_down_ratio),True)
        self.blocks_throttle_ue9_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue9_slow_down_ratio),True)
        self.blocks_throttle_ue9_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue9_slow_down_ratio),True)
        self.blocks_throttle_ue8_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue8_slow_down_ratio),True)
        self.blocks_throttle_ue8_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue8_slow_down_ratio),True)
        self.blocks_throttle_ue7_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue7_slow_down_ratio),True)
        self.blocks_throttle_ue7_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue7_slow_down_ratio),True)
        self.blocks_throttle_ue6_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue6_slow_down_ratio),True)
        self.blocks_throttle_ue6_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue6_slow_down_ratio),True)
        self.blocks_throttle_ue5_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue5_slow_down_ratio),True)
        self.blocks_throttle_ue5_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue5_slow_down_ratio),True)
        self.blocks_throttle_ue4_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue4_slow_down_ratio),True)
        self.blocks_throttle_ue4_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue4_slow_down_ratio),True)
        self.blocks_throttle_ue3_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue3_slow_down_ratio),True)
        self.blocks_throttle_ue3_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue3_slow_down_ratio),True)
        self.blocks_throttle_ue2_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue2_slow_down_ratio),True)
        self.blocks_throttle_ue2_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue2_slow_down_ratio),True)
        self.blocks_throttle_ue1_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue1_slow_down_ratio),True)
        self.blocks_throttle_ue1_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*ue1_slow_down_ratio),True)
        self.blocks_throttle_gnb_tx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*gnb_slow_down_ratio),True)
        self.blocks_throttle_gnb_rx = blocks.throttle(gr.sizeof_gr_complex*1, 1.0*samp_rate/(1.0*gnb_slow_down_ratio),True)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_throttle_gnb_rx, 0), (self.zeromq_gnb_rx, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue1_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue2_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue3_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue4_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue5_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue6_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue7_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue8_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue9_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue10_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue11_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue12_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue13_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue14_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue15_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue16_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue17_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue18_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue19_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue20_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue21_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue22_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue23_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue24_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue25_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue26_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue27_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue28_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue29_rx_pathloss, 0))
        self.connect((self.blocks_throttle_gnb_tx, 0), (self.blocks_ue30_rx_pathloss, 0))
        self.connect((self.blocks_throttle_ue1_rx, 0), (self.zeromq_ue1_rx, 0))
        self.connect((self.blocks_throttle_ue1_tx, 0), (self.blocks_ue1_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue2_rx, 0), (self.zeromq_ue2_rx, 0))
        self.connect((self.blocks_throttle_ue2_tx, 0), (self.blocks_ue2_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue3_rx, 0), (self.zeromq_ue3_rx, 0))
        self.connect((self.blocks_throttle_ue3_tx, 0), (self.blocks_ue3_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue4_rx, 0), (self.zeromq_ue4_rx, 0))
        self.connect((self.blocks_throttle_ue4_tx, 0), (self.blocks_ue4_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue5_rx, 0), (self.zeromq_ue5_rx, 0))
        self.connect((self.blocks_throttle_ue5_tx, 0), (self.blocks_ue5_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue6_rx, 0), (self.zeromq_ue6_rx, 0))
        self.connect((self.blocks_throttle_ue6_tx, 0), (self.blocks_ue6_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue7_rx, 0), (self.zeromq_ue7_rx, 0))
        self.connect((self.blocks_throttle_ue7_tx, 0), (self.blocks_ue7_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue8_rx, 0), (self.zeromq_ue8_rx, 0))
        self.connect((self.blocks_throttle_ue8_tx, 0), (self.blocks_ue8_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue9_rx, 0), (self.zeromq_ue9_rx, 0))
        self.connect((self.blocks_throttle_ue9_tx, 0), (self.blocks_ue9_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue10_rx, 0), (self.zeromq_ue10_rx, 0))
        self.connect((self.blocks_throttle_ue10_tx, 0), (self.blocks_ue10_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue11_rx, 0), (self.zeromq_ue11_rx, 0))
        self.connect((self.blocks_throttle_ue11_tx, 0), (self.blocks_ue11_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue12_rx, 0), (self.zeromq_ue12_rx, 0))
        self.connect((self.blocks_throttle_ue12_tx, 0), (self.blocks_ue12_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue13_rx, 0), (self.zeromq_ue13_rx, 0))
        self.connect((self.blocks_throttle_ue13_tx, 0), (self.blocks_ue13_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue14_rx, 0), (self.zeromq_ue14_rx, 0))
        self.connect((self.blocks_throttle_ue14_tx, 0), (self.blocks_ue14_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue15_rx, 0), (self.zeromq_ue15_rx, 0))
        self.connect((self.blocks_throttle_ue15_tx, 0), (self.blocks_ue15_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue16_rx, 0), (self.zeromq_ue16_rx, 0))
        self.connect((self.blocks_throttle_ue16_tx, 0), (self.blocks_ue16_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue17_rx, 0), (self.zeromq_ue17_rx, 0))
        self.connect((self.blocks_throttle_ue17_tx, 0), (self.blocks_ue17_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue18_rx, 0), (self.zeromq_ue18_rx, 0))
        self.connect((self.blocks_throttle_ue18_tx, 0), (self.blocks_ue18_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue19_rx, 0), (self.zeromq_ue19_rx, 0))
        self.connect((self.blocks_throttle_ue19_tx, 0), (self.blocks_ue19_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue20_rx, 0), (self.zeromq_ue20_rx, 0))
        self.connect((self.blocks_throttle_ue20_tx, 0), (self.blocks_ue20_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue21_rx, 0), (self.zeromq_ue21_rx, 0))
        self.connect((self.blocks_throttle_ue21_tx, 0), (self.blocks_ue21_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue22_rx, 0), (self.zeromq_ue22_rx, 0))
        self.connect((self.blocks_throttle_ue22_tx, 0), (self.blocks_ue22_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue23_rx, 0), (self.zeromq_ue23_rx, 0))
        self.connect((self.blocks_throttle_ue23_tx, 0), (self.blocks_ue23_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue24_rx, 0), (self.zeromq_ue24_rx, 0))
        self.connect((self.blocks_throttle_ue24_tx, 0), (self.blocks_ue24_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue25_rx, 0), (self.zeromq_ue25_rx, 0))
        self.connect((self.blocks_throttle_ue25_tx, 0), (self.blocks_ue25_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue26_rx, 0), (self.zeromq_ue26_rx, 0))
        self.connect((self.blocks_throttle_ue26_tx, 0), (self.blocks_ue26_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue27_rx, 0), (self.zeromq_ue27_rx, 0))
        self.connect((self.blocks_throttle_ue27_tx, 0), (self.blocks_ue27_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue28_rx, 0), (self.zeromq_ue28_rx, 0))
        self.connect((self.blocks_throttle_ue28_tx, 0), (self.blocks_ue28_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue29_rx, 0), (self.zeromq_ue29_rx, 0))
        self.connect((self.blocks_throttle_ue29_tx, 0), (self.blocks_ue29_tx_pathloss, 0))
        self.connect((self.blocks_throttle_ue30_rx, 0), (self.zeromq_ue30_rx, 0))
        self.connect((self.blocks_throttle_ue30_tx, 0), (self.blocks_ue30_tx_pathloss, 0))
        self.connect((self.blocks_ue1_rx_pathloss, 0), (self.blocks_throttle_ue1_rx, 0))
        self.connect((self.blocks_ue1_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 0))
        self.connect((self.blocks_ue2_rx_pathloss, 0), (self.blocks_throttle_ue2_rx, 0))
        self.connect((self.blocks_ue2_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 1))
        self.connect((self.blocks_ue3_rx_pathloss, 0), (self.blocks_throttle_ue3_rx, 0))
        self.connect((self.blocks_ue3_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 2))
        self.connect((self.blocks_ue4_rx_pathloss, 0), (self.blocks_throttle_ue4_rx, 0))
        self.connect((self.blocks_ue4_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 3))
        self.connect((self.blocks_ue5_rx_pathloss, 0), (self.blocks_throttle_ue5_rx, 0))
        self.connect((self.blocks_ue5_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 4))
        self.connect((self.blocks_ue6_rx_pathloss, 0), (self.blocks_throttle_ue6_rx, 0))
        self.connect((self.blocks_ue6_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 5))
        self.connect((self.blocks_ue7_rx_pathloss, 0), (self.blocks_throttle_ue7_rx, 0))
        self.connect((self.blocks_ue7_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 6))
        self.connect((self.blocks_ue8_rx_pathloss, 0), (self.blocks_throttle_ue8_rx, 0))
        self.connect((self.blocks_ue8_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 7))
        self.connect((self.blocks_ue9_rx_pathloss, 0), (self.blocks_throttle_ue9_rx, 0))
        self.connect((self.blocks_ue9_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 8))
        self.connect((self.blocks_ue10_rx_pathloss, 0), (self.blocks_throttle_ue10_rx, 0))
        self.connect((self.blocks_ue10_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 9))
        self.connect((self.blocks_ue11_rx_pathloss, 0), (self.blocks_throttle_ue11_rx, 0))
        self.connect((self.blocks_ue11_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 10))
        self.connect((self.blocks_ue12_rx_pathloss, 0), (self.blocks_throttle_ue12_rx, 0))
        self.connect((self.blocks_ue12_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 11))
        self.connect((self.blocks_ue13_rx_pathloss, 0), (self.blocks_throttle_ue13_rx, 0))
        self.connect((self.blocks_ue13_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 12))
        self.connect((self.blocks_ue14_rx_pathloss, 0), (self.blocks_throttle_ue14_rx, 0))
        self.connect((self.blocks_ue14_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 13))
        self.connect((self.blocks_ue15_rx_pathloss, 0), (self.blocks_throttle_ue15_rx, 0))
        self.connect((self.blocks_ue15_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 14))
        self.connect((self.blocks_ue16_rx_pathloss, 0), (self.blocks_throttle_ue16_rx, 0))
        self.connect((self.blocks_ue16_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 15))
        self.connect((self.blocks_ue17_rx_pathloss, 0), (self.blocks_throttle_ue17_rx, 0))
        self.connect((self.blocks_ue17_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 16))
        self.connect((self.blocks_ue18_rx_pathloss, 0), (self.blocks_throttle_ue18_rx, 0))
        self.connect((self.blocks_ue18_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 17))
        self.connect((self.blocks_ue19_rx_pathloss, 0), (self.blocks_throttle_ue19_rx, 0))
        self.connect((self.blocks_ue19_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 18))
        self.connect((self.blocks_ue20_rx_pathloss, 0), (self.blocks_throttle_ue20_rx, 0))
        self.connect((self.blocks_ue20_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 19))
        self.connect((self.blocks_ue21_rx_pathloss, 0), (self.blocks_throttle_ue21_rx, 0))
        self.connect((self.blocks_ue21_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 20))
        self.connect((self.blocks_ue22_rx_pathloss, 0), (self.blocks_throttle_ue22_rx, 0))
        self.connect((self.blocks_ue22_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 21))
        self.connect((self.blocks_ue23_rx_pathloss, 0), (self.blocks_throttle_ue23_rx, 0))
        self.connect((self.blocks_ue23_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 22))
        self.connect((self.blocks_ue24_rx_pathloss, 0), (self.blocks_throttle_ue24_rx, 0))
        self.connect((self.blocks_ue24_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 23))
        self.connect((self.blocks_ue25_rx_pathloss, 0), (self.blocks_throttle_ue25_rx, 0))
        self.connect((self.blocks_ue25_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 24))
        self.connect((self.blocks_ue26_rx_pathloss, 0), (self.blocks_throttle_ue26_rx, 0))
        self.connect((self.blocks_ue26_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 25))
        self.connect((self.blocks_ue27_rx_pathloss, 0), (self.blocks_throttle_ue27_rx, 0))
        self.connect((self.blocks_ue27_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 26))
        self.connect((self.blocks_ue28_rx_pathloss, 0), (self.blocks_throttle_ue28_rx, 0))
        self.connect((self.blocks_ue28_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 27))
        self.connect((self.blocks_ue29_rx_pathloss, 0), (self.blocks_throttle_ue29_rx, 0))
        self.connect((self.blocks_ue29_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 28))
        self.connect((self.blocks_ue30_rx_pathloss, 0), (self.blocks_throttle_ue30_rx, 0))
        self.connect((self.blocks_ue30_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 29))
        self.connect((self.blocks_ue_tx_to_gnb_rx_add, 0), (self.blocks_throttle_gnb_rx, 0))
        self.connect((self.zeromq_gnb_tx, 0), (self.blocks_throttle_gnb_tx, 0))
        self.connect((self.zeromq_ue1_tx, 0), (self.blocks_throttle_ue1_tx, 0))
        self.connect((self.zeromq_ue2_tx, 0), (self.blocks_throttle_ue2_tx, 0))
        self.connect((self.zeromq_ue3_tx, 0), (self.blocks_throttle_ue3_tx, 0))
        self.connect((self.zeromq_ue4_tx, 0), (self.blocks_throttle_ue4_tx, 0))
        self.connect((self.zeromq_ue5_tx, 0), (self.blocks_throttle_ue5_tx, 0))
        self.connect((self.zeromq_ue6_tx, 0), (self.blocks_throttle_ue6_tx, 0))
        self.connect((self.zeromq_ue7_tx, 0), (self.blocks_throttle_ue7_tx, 0))
        self.connect((self.zeromq_ue8_tx, 0), (self.blocks_throttle_ue8_tx, 0))
        self.connect((self.zeromq_ue9_tx, 0), (self.blocks_throttle_ue9_tx, 0))
        self.connect((self.zeromq_ue10_tx, 0), (self.blocks_throttle_ue10_tx, 0))
        self.connect((self.zeromq_ue11_tx, 0), (self.blocks_throttle_ue11_tx, 0))
        self.connect((self.zeromq_ue12_tx, 0), (self.blocks_throttle_ue12_tx, 0))
        self.connect((self.zeromq_ue13_tx, 0), (self.blocks_throttle_ue13_tx, 0))
        self.connect((self.zeromq_ue14_tx, 0), (self.blocks_throttle_ue14_tx, 0))
        self.connect((self.zeromq_ue15_tx, 0), (self.blocks_throttle_ue15_tx, 0))
        self.connect((self.zeromq_ue16_tx, 0), (self.blocks_throttle_ue16_tx, 0))
        self.connect((self.zeromq_ue17_tx, 0), (self.blocks_throttle_ue17_tx, 0))
        self.connect((self.zeromq_ue18_tx, 0), (self.blocks_throttle_ue18_tx, 0))
        self.connect((self.zeromq_ue19_tx, 0), (self.blocks_throttle_ue19_tx, 0))
        self.connect((self.zeromq_ue20_tx, 0), (self.blocks_throttle_ue20_tx, 0))
        self.connect((self.zeromq_ue21_tx, 0), (self.blocks_throttle_ue21_tx, 0))
        self.connect((self.zeromq_ue22_tx, 0), (self.blocks_throttle_ue22_tx, 0))
        self.connect((self.zeromq_ue23_tx, 0), (self.blocks_throttle_ue23_tx, 0))
        self.connect((self.zeromq_ue24_tx, 0), (self.blocks_throttle_ue24_tx, 0))
        self.connect((self.zeromq_ue25_tx, 0), (self.blocks_throttle_ue25_tx, 0))
        self.connect((self.zeromq_ue26_tx, 0), (self.blocks_throttle_ue26_tx, 0))
        self.connect((self.zeromq_ue27_tx, 0), (self.blocks_throttle_ue27_tx, 0))
        self.connect((self.zeromq_ue28_tx, 0), (self.blocks_throttle_ue28_tx, 0))
        self.connect((self.zeromq_ue29_tx, 0), (self.blocks_throttle_ue29_tx, 0))
        self.connect((self.zeromq_ue30_tx, 0), (self.blocks_throttle_ue30_tx, 0))

        # Begin reading UE config file
        self.timer = None
        self.start_periodic_config_read()

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

    def set_ue_variables(self, config_data):
        """Update the UE-specific variables based on the config data list."""
        # Iterate over each UE configuration and apply settings
        for ue_config in config_data:
            total_prb = 52  # 10MHz 1800 MHz n3 w/ 15kHz SCS & 12 channel symbols
            ue_id = ue_config.get("id")
            prb = ue_config.get("prb")
            pathloss = ue_config.get("pathloss")
            if ue_id == 1:
                self.set_ue1_slow_down_ratio(total_prb / prb)
                self.set_ue1_path_loss_db(pathloss)
                #print(f"UE1 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 2:
                self.set_ue2_slow_down_ratio(total_prb / prb)
                self.set_ue2_path_loss_db(pathloss)
                #print(f"UE2 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 3:
                self.set_ue3_slow_down_ratio(total_prb / prb)
                self.set_ue3_path_loss_db(pathloss)
                #print(f"UE3 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 4:
                self.set_ue4_slow_down_ratio(total_prb / prb)
                self.set_ue4_path_loss_db(pathloss)
                #print(f"UE4 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 5:
                self.set_ue5_slow_down_ratio(total_prb / prb)
                self.set_ue5_path_loss_db(pathloss)
                #print(f"UE5 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 6:
                self.set_ue6_slow_down_ratio(total_prb / prb)
                self.set_ue6_path_loss_db(pathloss)
                #print(f"UE6 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 7:
                self.set_ue7_slow_down_ratio(total_prb / prb)
                self.set_ue7_path_loss_db(pathloss)
                #print(f"UE7 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 8:
                self.set_ue8_slow_down_ratio(total_prb / prb)
                self.set_ue8_path_loss_db(pathloss)
                #print(f"UE8 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 9:
                self.set_ue9_slow_down_ratio(total_prb / prb)
                self.set_ue9_path_loss_db(pathloss)
                #print(f"UE9 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 10:
                self.set_ue10_slow_down_ratio(total_prb / prb)
                self.set_ue10_path_loss_db(pathloss)
                #print(f"UE10 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 11:
                self.set_ue11_slow_down_ratio(total_prb / prb)
                self.set_ue11_path_loss_db(pathloss)
                #print(f"UE11 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 12:
                self.set_ue12_slow_down_ratio(total_prb / prb)
                self.set_ue12_path_loss_db(pathloss)
                #print(f"UE12 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 13:
                self.set_ue13_slow_down_ratio(total_prb / prb)
                self.set_ue13_path_loss_db(pathloss)
                #print(f"UE13 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 14:
                self.set_ue14_slow_down_ratio(total_prb / prb)
                self.set_ue14_path_loss_db(pathloss)
                #print(f"UE14 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 15:
                self.set_ue15_slow_down_ratio(total_prb / prb)
                self.set_ue15_path_loss_db(pathloss)
                #print(f"UE15 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 16:
                self.set_ue16_slow_down_ratio(total_prb / prb)
                self.set_ue16_path_loss_db(pathloss)
                #print(f"UE16 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 17:
                self.set_ue17_slow_down_ratio(total_prb / prb)
                self.set_ue17_path_loss_db(pathloss)
                #print(f"UE17 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 18:
                self.set_ue18_slow_down_ratio(total_prb / prb)
                self.set_ue18_path_loss_db(pathloss)
                #print(f"UE18 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 19:
                self.set_ue19_slow_down_ratio(total_prb / prb)
                self.set_ue19_path_loss_db(pathloss)
                #print(f"UE19 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 20:
                self.set_ue20_slow_down_ratio(total_prb / prb)
                self.set_ue20_path_loss_db(pathloss)
                #print(f"UE20 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 21:
                self.set_ue21_slow_down_ratio(total_prb / prb)
                self.set_ue21_path_loss_db(pathloss)
                #print(f"UE21 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 22:
                self.set_ue22_slow_down_ratio(total_prb / prb)
                self.set_ue22_path_loss_db(pathloss)
                #print(f"UE22 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 23:
                self.set_ue23_slow_down_ratio(total_prb / prb)
                self.set_ue23_path_loss_db(pathloss)
                #print(f"UE23 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 24:
                self.set_ue24_slow_down_ratio(total_prb / prb)
                self.set_ue24_path_loss_db(pathloss)
                #print(f"UE24 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 25:
                self.set_ue25_slow_down_ratio(total_prb / prb)
                self.set_ue25_path_loss_db(pathloss)
                #print(f"UE25 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 26:
                self.set_ue26_slow_down_ratio(total_prb / prb)
                self.set_ue26_path_loss_db(pathloss)
                #print(f"UE26 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 27:
                self.set_ue27_slow_down_ratio(total_prb / prb)
                self.set_ue27_path_loss_db(pathloss)
                #print(f"UE27 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 28:
                self.set_ue28_slow_down_ratio(total_prb / prb)
                self.set_ue28_path_loss_db(pathloss)
                #print(f"UE28 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 29:
                self.set_ue29_slow_down_ratio(total_prb / prb)
                self.set_ue29_path_loss_db(pathloss)
                #print(f"UE29 - PRB: {prb}, Pathloss: {pathloss} dB")
            if ue_id == 30:
                self.set_ue30_slow_down_ratio(total_prb / prb)
                self.set_ue30_path_loss_db(pathloss)
                #print(f"UE30 - PRB: {prb}, Pathloss: {pathloss} dB")

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

    def get_ue1_slow_down_ratio(self):
        return self.ue1_slow_down_ratio

    def set_ue1_slow_down_ratio(self, ue1_slow_down_ratio):
        self.ue1_slow_down_ratio = ue1_slow_down_ratio
        self.blocks_throttle_ue1_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue1_slow_down_ratio))
        self.blocks_throttle_ue1_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue1_slow_down_ratio))

    def get_ue1_path_loss_db(self):
        return self.ue1_path_loss_db

    def set_ue1_path_loss_db(self, ue1_path_loss_db):
        self.ue1_path_loss_db = ue1_path_loss_db
        self.blocks_ue1_rx_pathloss.set_k(10**(-1.0*self.ue1_path_loss_db/20.0))
        self.blocks_ue1_tx_pathloss.set_k(10**(-1.0*self.ue1_path_loss_db/20.0))

    def get_ue2_slow_down_ratio(self):
        return self.ue2_slow_down_ratio

    def set_ue2_slow_down_ratio(self, ue2_slow_down_ratio):
        self.ue2_slow_down_ratio = ue2_slow_down_ratio
        self.blocks_throttle_ue2_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue2_slow_down_ratio))
        self.blocks_throttle_ue2_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue2_slow_down_ratio))

    def get_ue2_path_loss_db(self):
        return self.ue2_path_loss_db

    def set_ue2_path_loss_db(self, ue2_path_loss_db):
        self.ue2_path_loss_db = ue2_path_loss_db
        self.blocks_ue2_rx_pathloss.set_k(10**(-1.0*self.ue2_path_loss_db/20.0))
        self.blocks_ue2_tx_pathloss.set_k(10**(-1.0*self.ue2_path_loss_db/20.0))

    def get_ue3_slow_down_ratio(self):
        return self.ue3_slow_down_ratio

    def set_ue3_slow_down_ratio(self, ue3_slow_down_ratio):
        self.ue3_slow_down_ratio = ue3_slow_down_ratio
        self.blocks_throttle_ue3_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue3_slow_down_ratio))
        self.blocks_throttle_ue3_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue3_slow_down_ratio))

    def get_ue3_path_loss_db(self):
        return self.ue3_path_loss_db

    def set_ue3_path_loss_db(self, ue3_path_loss_db):
        self.ue3_path_loss_db = ue3_path_loss_db
        self.blocks_ue3_rx_pathloss.set_k(10**(-1.0*self.ue3_path_loss_db/20.0))
        self.blocks_ue3_tx_pathloss.set_k(10**(-1.0*self.ue3_path_loss_db/20.0))

    def get_ue4_slow_down_ratio(self):
        return self.ue4_slow_down_ratio

    def set_ue4_slow_down_ratio(self, ue4_slow_down_ratio):
        self.ue4_slow_down_ratio = ue4_slow_down_ratio
        self.blocks_throttle_ue4_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue4_slow_down_ratio))
        self.blocks_throttle_ue4_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue4_slow_down_ratio))

    def get_ue4_path_loss_db(self):
        return self.ue4_path_loss_db

    def set_ue4_path_loss_db(self, ue4_path_loss_db):
        self.ue4_path_loss_db = ue4_path_loss_db
        self.blocks_ue4_rx_pathloss.set_k(10**(-1.0*self.ue4_path_loss_db/20.0))
        self.blocks_ue4_tx_pathloss.set_k(10**(-1.0*self.ue4_path_loss_db/20.0))

    def get_ue5_slow_down_ratio(self):
        return self.ue5_slow_down_ratio

    def set_ue5_slow_down_ratio(self, ue5_slow_down_ratio):
        self.ue5_slow_down_ratio = ue5_slow_down_ratio
        self.blocks_throttle_ue5_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue5_slow_down_ratio))
        self.blocks_throttle_ue5_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue5_slow_down_ratio))

    def get_ue5_path_loss_db(self):
        return self.ue5_path_loss_db

    def set_ue5_path_loss_db(self, ue5_path_loss_db):
        self.ue5_path_loss_db = ue5_path_loss_db
        self.blocks_ue5_rx_pathloss.set_k(10**(-1.0*self.ue5_path_loss_db/20.0))
        self.blocks_ue5_tx_pathloss.set_k(10**(-1.0*self.ue5_path_loss_db/20.0))

    def get_ue6_slow_down_ratio(self):
        return self.ue6_slow_down_ratio

    def set_ue6_slow_down_ratio(self, ue6_slow_down_ratio):
        self.ue6_slow_down_ratio = ue6_slow_down_ratio
        self.blocks_throttle_ue6_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue6_slow_down_ratio))
        self.blocks_throttle_ue6_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue6_slow_down_ratio))

    def get_ue6_path_loss_db(self):
        return self.ue6_path_loss_db

    def set_ue6_path_loss_db(self, ue6_path_loss_db):
        self.ue6_path_loss_db = ue6_path_loss_db
        self.blocks_ue6_rx_pathloss.set_k(10**(-1.0*self.ue6_path_loss_db/20.0))
        self.blocks_ue6_tx_pathloss.set_k(10**(-1.0*self.ue6_path_loss_db/20.0))

    def get_ue7_slow_down_ratio(self):
        return self.ue7_slow_down_ratio

    def set_ue7_slow_down_ratio(self, ue7_slow_down_ratio):
        self.ue7_slow_down_ratio = ue7_slow_down_ratio
        self.blocks_throttle_ue7_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue7_slow_down_ratio))
        self.blocks_throttle_ue7_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue7_slow_down_ratio))

    def get_ue7_path_loss_db(self):
        return self.ue7_path_loss_db

    def set_ue7_path_loss_db(self, ue7_path_loss_db):
        self.ue7_path_loss_db = ue7_path_loss_db
        self.blocks_ue7_rx_pathloss.set_k(10**(-1.0*self.ue7_path_loss_db/20.0))
        self.blocks_ue7_tx_pathloss.set_k(10**(-1.0*self.ue7_path_loss_db/20.0))

    def get_ue8_slow_down_ratio(self):
        return self.ue8_slow_down_ratio

    def set_ue8_slow_down_ratio(self, ue8_slow_down_ratio):
        self.ue8_slow_down_ratio = ue8_slow_down_ratio
        self.blocks_throttle_ue8_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue8_slow_down_ratio))
        self.blocks_throttle_ue8_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue8_slow_down_ratio))

    def get_ue8_path_loss_db(self):
        return self.ue8_path_loss_db

    def set_ue8_path_loss_db(self, ue8_path_loss_db):
        self.ue8_path_loss_db = ue8_path_loss_db
        self.blocks_ue8_rx_pathloss.set_k(10**(-1.0*self.ue8_path_loss_db/20.0))
        self.blocks_ue8_tx_pathloss.set_k(10**(-1.0*self.ue8_path_loss_db/20.0))

    def get_ue9_slow_down_ratio(self):
        return self.ue9_slow_down_ratio

    def set_ue9_slow_down_ratio(self, ue9_slow_down_ratio):
        self.ue9_slow_down_ratio = ue9_slow_down_ratio
        self.blocks_throttle_ue9_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue9_slow_down_ratio))
        self.blocks_throttle_ue9_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue9_slow_down_ratio))

    def get_ue9_path_loss_db(self):
        return self.ue9_path_loss_db

    def set_ue9_path_loss_db(self, ue9_path_loss_db):
        self.ue9_path_loss_db = ue9_path_loss_db
        self.blocks_ue9_rx_pathloss.set_k(10**(-1.0*self.ue9_path_loss_db/20.0))
        self.blocks_ue9_tx_pathloss.set_k(10**(-1.0*self.ue9_path_loss_db/20.0))

    def get_ue10_slow_down_ratio(self):
        return self.ue10_slow_down_ratio

    def set_ue10_slow_down_ratio(self, ue10_slow_down_ratio):
        self.ue10_slow_down_ratio = ue10_slow_down_ratio
        self.blocks_throttle_ue10_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue10_slow_down_ratio))
        self.blocks_throttle_ue10_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue10_slow_down_ratio))

    def get_ue10_path_loss_db(self):
        return self.ue10_path_loss_db

    def set_ue10_path_loss_db(self, ue10_path_loss_db):
        self.ue10_path_loss_db = ue10_path_loss_db
        self.blocks_ue10_rx_pathloss.set_k(10**(-1.0*self.ue10_path_loss_db/20.0))
        self.blocks_ue10_tx_pathloss.set_k(10**(-1.0*self.ue10_path_loss_db/20.0))

    def get_ue11_slow_down_ratio(self):
        return self.ue11_slow_down_ratio

    def set_ue11_slow_down_ratio(self, ue11_slow_down_ratio):
        self.ue11_slow_down_ratio = ue11_slow_down_ratio
        self.blocks_throttle_ue11_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue11_slow_down_ratio))
        self.blocks_throttle_ue11_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue11_slow_down_ratio))

    def get_ue11_path_loss_db(self):
        return self.ue11_path_loss_db

    def set_ue11_path_loss_db(self, ue11_path_loss_db):
        self.ue11_path_loss_db = ue11_path_loss_db
        self.blocks_ue11_rx_pathloss.set_k(10**(-1.0*self.ue11_path_loss_db/20.0))
        self.blocks_ue11_tx_pathloss.set_k(10**(-1.0*self.ue11_path_loss_db/20.0))

    def get_ue12_slow_down_ratio(self):
        return self.ue12_slow_down_ratio

    def set_ue12_slow_down_ratio(self, ue12_slow_down_ratio):
        self.ue12_slow_down_ratio = ue12_slow_down_ratio
        self.blocks_throttle_ue12_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue12_slow_down_ratio))
        self.blocks_throttle_ue12_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue12_slow_down_ratio))

    def get_ue12_path_loss_db(self):
        return self.ue12_path_loss_db

    def set_ue12_path_loss_db(self, ue12_path_loss_db):
        self.ue12_path_loss_db = ue12_path_loss_db
        self.blocks_ue12_rx_pathloss.set_k(10**(-1.0*self.ue12_path_loss_db/20.0))
        self.blocks_ue12_tx_pathloss.set_k(10**(-1.0*self.ue12_path_loss_db/20.0))

    def get_ue13_slow_down_ratio(self):
        return self.ue13_slow_down_ratio

    def set_ue13_slow_down_ratio(self, ue13_slow_down_ratio):
        self.ue13_slow_down_ratio = ue13_slow_down_ratio
        self.blocks_throttle_ue13_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue13_slow_down_ratio))
        self.blocks_throttle_ue13_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue13_slow_down_ratio))

    def get_ue13_path_loss_db(self):
        return self.ue13_path_loss_db

    def set_ue13_path_loss_db(self, ue13_path_loss_db):
        self.ue13_path_loss_db = ue13_path_loss_db
        self.blocks_ue13_rx_pathloss.set_k(10**(-1.0*self.ue13_path_loss_db/20.0))
        self.blocks_ue13_tx_pathloss.set_k(10**(-1.0*self.ue13_path_loss_db/20.0))

    def get_ue14_slow_down_ratio(self):
        return self.ue14_slow_down_ratio

    def set_ue14_slow_down_ratio(self, ue14_slow_down_ratio):
        self.ue14_slow_down_ratio = ue14_slow_down_ratio
        self.blocks_throttle_ue14_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue14_slow_down_ratio))
        self.blocks_throttle_ue14_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue14_slow_down_ratio))

    def get_ue14_path_loss_db(self):
        return self.ue14_path_loss_db

    def set_ue14_path_loss_db(self, ue14_path_loss_db):
        self.ue14_path_loss_db = ue14_path_loss_db
        self.blocks_ue14_rx_pathloss.set_k(10**(-1.0*self.ue14_path_loss_db/20.0))
        self.blocks_ue14_tx_pathloss.set_k(10**(-1.0*self.ue14_path_loss_db/20.0))

    def get_ue15_slow_down_ratio(self):
        return self.ue15_slow_down_ratio

    def set_ue15_slow_down_ratio(self, ue15_slow_down_ratio):
        self.ue15_slow_down_ratio = ue15_slow_down_ratio
        self.blocks_throttle_ue15_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue15_slow_down_ratio))
        self.blocks_throttle_ue15_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue15_slow_down_ratio))

    def get_ue15_path_loss_db(self):
        return self.ue15_path_loss_db

    def set_ue15_path_loss_db(self, ue15_path_loss_db):
        self.ue15_path_loss_db = ue15_path_loss_db
        self.blocks_ue15_rx_pathloss.set_k(10**(-1.0*self.ue15_path_loss_db/20.0))
        self.blocks_ue15_tx_pathloss.set_k(10**(-1.0*self.ue15_path_loss_db/20.0))

    def get_ue16_slow_down_ratio(self):
        return self.ue16_slow_down_ratio

    def set_ue16_slow_down_ratio(self, ue16_slow_down_ratio):
        self.ue16_slow_down_ratio = ue16_slow_down_ratio
        self.blocks_throttle_ue16_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue16_slow_down_ratio))
        self.blocks_throttle_ue16_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue16_slow_down_ratio))

    def get_ue16_path_loss_db(self):
        return self.ue16_path_loss_db

    def set_ue16_path_loss_db(self, ue16_path_loss_db):
        self.ue16_path_loss_db = ue16_path_loss_db
        self.blocks_ue16_rx_pathloss.set_k(10**(-1.0*self.ue16_path_loss_db/20.0))
        self.blocks_ue16_tx_pathloss.set_k(10**(-1.0*self.ue16_path_loss_db/20.0))

    def get_ue17_slow_down_ratio(self):
        return self.ue17_slow_down_ratio

    def set_ue17_slow_down_ratio(self, ue17_slow_down_ratio):
        self.ue17_slow_down_ratio = ue17_slow_down_ratio
        self.blocks_throttle_ue17_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue17_slow_down_ratio))
        self.blocks_throttle_ue17_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue17_slow_down_ratio))

    def get_ue17_path_loss_db(self):
        return self.ue17_path_loss_db

    def set_ue17_path_loss_db(self, ue17_path_loss_db):
        self.ue17_path_loss_db = ue17_path_loss_db
        self.blocks_ue17_rx_pathloss.set_k(10**(-1.0*self.ue17_path_loss_db/20.0))
        self.blocks_ue17_tx_pathloss.set_k(10**(-1.0*self.ue17_path_loss_db/20.0))

    def get_ue18_slow_down_ratio(self):
        return self.ue18_slow_down_ratio

    def set_ue18_slow_down_ratio(self, ue18_slow_down_ratio):
        self.ue18_slow_down_ratio = ue18_slow_down_ratio
        self.blocks_throttle_ue18_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue18_slow_down_ratio))
        self.blocks_throttle_ue18_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue18_slow_down_ratio))

    def get_ue18_path_loss_db(self):
        return self.ue18_path_loss_db

    def set_ue18_path_loss_db(self, ue18_path_loss_db):
        self.ue18_path_loss_db = ue18_path_loss_db
        self.blocks_ue18_rx_pathloss.set_k(10**(-1.0*self.ue18_path_loss_db/20.0))
        self.blocks_ue18_tx_pathloss.set_k(10**(-1.0*self.ue18_path_loss_db/20.0))

    def get_ue19_slow_down_ratio(self):
        return self.ue19_slow_down_ratio

    def set_ue19_slow_down_ratio(self, ue19_slow_down_ratio):
        self.ue19_slow_down_ratio = ue19_slow_down_ratio
        self.blocks_throttle_ue19_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue19_slow_down_ratio))
        self.blocks_throttle_ue19_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue19_slow_down_ratio))

    def get_ue19_path_loss_db(self):
        return self.ue19_path_loss_db

    def set_ue19_path_loss_db(self, ue19_path_loss_db):
        self.ue19_path_loss_db = ue19_path_loss_db
        self.blocks_ue19_rx_pathloss.set_k(10**(-1.0*self.ue19_path_loss_db/20.0))
        self.blocks_ue19_tx_pathloss.set_k(10**(-1.0*self.ue19_path_loss_db/20.0))

    def get_ue20_slow_down_ratio(self):
        return self.ue20_slow_down_ratio

    def set_ue20_slow_down_ratio(self, ue20_slow_down_ratio):
        self.ue20_slow_down_ratio = ue20_slow_down_ratio
        self.blocks_throttle_ue20_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue20_slow_down_ratio))
        self.blocks_throttle_ue20_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue20_slow_down_ratio))

    def get_ue20_path_loss_db(self):
        return self.ue20_path_loss_db

    def set_ue20_path_loss_db(self, ue20_path_loss_db):
        self.ue20_path_loss_db = ue20_path_loss_db
        self.blocks_ue20_rx_pathloss.set_k(10**(-1.0*self.ue20_path_loss_db/20.0))
        self.blocks_ue20_tx_pathloss.set_k(10**(-1.0*self.ue20_path_loss_db/20.0))

    def get_ue21_slow_down_ratio(self):
        return self.ue21_slow_down_ratio

    def set_ue21_slow_down_ratio(self, ue21_slow_down_ratio):
        self.ue21_slow_down_ratio = ue21_slow_down_ratio
        self.blocks_throttle_ue21_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue21_slow_down_ratio))
        self.blocks_throttle_ue21_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue21_slow_down_ratio))

    def get_ue21_path_loss_db(self):
        return self.ue21_path_loss_db

    def set_ue21_path_loss_db(self, ue21_path_loss_db):
        self.ue21_path_loss_db = ue21_path_loss_db
        self.blocks_ue21_rx_pathloss.set_k(10**(-1.0*self.ue21_path_loss_db/20.0))
        self.blocks_ue21_tx_pathloss.set_k(10**(-1.0*self.ue21_path_loss_db/20.0))

    def get_ue22_slow_down_ratio(self):
        return self.ue22_slow_down_ratio

    def set_ue22_slow_down_ratio(self, ue22_slow_down_ratio):
        self.ue22_slow_down_ratio = ue22_slow_down_ratio
        self.blocks_throttle_ue22_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue22_slow_down_ratio))
        self.blocks_throttle_ue22_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue22_slow_down_ratio))

    def get_ue22_path_loss_db(self):
        return self.ue22_path_loss_db

    def set_ue22_path_loss_db(self, ue22_path_loss_db):
        self.ue22_path_loss_db = ue22_path_loss_db
        self.blocks_ue22_rx_pathloss.set_k(10**(-1.0*self.ue22_path_loss_db/20.0))
        self.blocks_ue22_tx_pathloss.set_k(10**(-1.0*self.ue22_path_loss_db/20.0))

    def get_ue23_slow_down_ratio(self):
        return self.ue23_slow_down_ratio

    def set_ue23_slow_down_ratio(self, ue23_slow_down_ratio):
        self.ue23_slow_down_ratio = ue23_slow_down_ratio
        self.blocks_throttle_ue23_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue23_slow_down_ratio))
        self.blocks_throttle_ue23_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue23_slow_down_ratio))

    def get_ue23_path_loss_db(self):
        return self.ue23_path_loss_db

    def set_ue23_path_loss_db(self, ue23_path_loss_db):
        self.ue23_path_loss_db = ue23_path_loss_db
        self.blocks_ue23_rx_pathloss.set_k(10**(-1.0*self.ue23_path_loss_db/20.0))
        self.blocks_ue23_tx_pathloss.set_k(10**(-1.0*self.ue23_path_loss_db/20.0))

    def get_ue24_slow_down_ratio(self):
        return self.ue24_slow_down_ratio

    def set_ue24_slow_down_ratio(self, ue24_slow_down_ratio):
        self.ue24_slow_down_ratio = ue24_slow_down_ratio
        self.blocks_throttle_ue24_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue24_slow_down_ratio))
        self.blocks_throttle_ue24_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue24_slow_down_ratio))

    def get_ue24_path_loss_db(self):
        return self.ue24_path_loss_db

    def set_ue24_path_loss_db(self, ue24_path_loss_db):
        self.ue24_path_loss_db = ue24_path_loss_db
        self.blocks_ue24_rx_pathloss.set_k(10**(-1.0*self.ue24_path_loss_db/20.0))
        self.blocks_ue24_tx_pathloss.set_k(10**(-1.0*self.ue24_path_loss_db/20.0))

    def get_ue25_slow_down_ratio(self):
        return self.ue25_slow_down_ratio

    def set_ue25_slow_down_ratio(self, ue25_slow_down_ratio):
        self.ue25_slow_down_ratio = ue25_slow_down_ratio
        self.blocks_throttle_ue25_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue25_slow_down_ratio))
        self.blocks_throttle_ue25_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue25_slow_down_ratio))

    def get_ue25_path_loss_db(self):
        return self.ue25_path_loss_db

    def set_ue25_path_loss_db(self, ue25_path_loss_db):
        self.ue25_path_loss_db = ue25_path_loss_db
        self.blocks_ue25_rx_pathloss.set_k(10**(-1.0*self.ue25_path_loss_db/20.0))
        self.blocks_ue25_tx_pathloss.set_k(10**(-1.0*self.ue25_path_loss_db/20.0))

    def get_ue26_slow_down_ratio(self):
        return self.ue26_slow_down_ratio

    def set_ue26_slow_down_ratio(self, ue26_slow_down_ratio):
        self.ue26_slow_down_ratio = ue26_slow_down_ratio
        self.blocks_throttle_ue26_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue26_slow_down_ratio))
        self.blocks_throttle_ue26_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue26_slow_down_ratio))

    def get_ue26_path_loss_db(self):
        return self.ue26_path_loss_db

    def set_ue26_path_loss_db(self, ue26_path_loss_db):
        self.ue26_path_loss_db = ue26_path_loss_db
        self.blocks_ue26_rx_pathloss.set_k(10**(-1.0*self.ue26_path_loss_db/20.0))
        self.blocks_ue26_tx_pathloss.set_k(10**(-1.0*self.ue26_path_loss_db/20.0))

    def get_ue27_slow_down_ratio(self):
        return self.ue27_slow_down_ratio

    def set_ue27_slow_down_ratio(self, ue27_slow_down_ratio):
        self.ue27_slow_down_ratio = ue27_slow_down_ratio
        self.blocks_throttle_ue27_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue27_slow_down_ratio))
        self.blocks_throttle_ue27_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue27_slow_down_ratio))

    def get_ue27_path_loss_db(self):
        return self.ue27_path_loss_db

    def set_ue27_path_loss_db(self, ue27_path_loss_db):
        self.ue27_path_loss_db = ue27_path_loss_db
        self.blocks_ue27_rx_pathloss.set_k(10**(-1.0*self.ue27_path_loss_db/20.0))
        self.blocks_ue27_tx_pathloss.set_k(10**(-1.0*self.ue27_path_loss_db/20.0))

    def get_ue28_slow_down_ratio(self):
        return self.ue28_slow_down_ratio

    def set_ue28_slow_down_ratio(self, ue28_slow_down_ratio):
        self.ue28_slow_down_ratio = ue28_slow_down_ratio
        self.blocks_throttle_ue28_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue28_slow_down_ratio))
        self.blocks_throttle_ue28_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue28_slow_down_ratio))

    def get_ue28_path_loss_db(self):
        return self.ue28_path_loss_db

    def set_ue28_path_loss_db(self, ue28_path_loss_db):
        self.ue28_path_loss_db = ue28_path_loss_db
        self.blocks_ue28_rx_pathloss.set_k(10**(-1.0*self.ue28_path_loss_db/20.0))
        self.blocks_ue28_tx_pathloss.set_k(10**(-1.0*self.ue28_path_loss_db/20.0))

    def get_ue29_slow_down_ratio(self):
        return self.ue29_slow_down_ratio

    def set_ue29_slow_down_ratio(self, ue29_slow_down_ratio):
        self.ue29_slow_down_ratio = ue29_slow_down_ratio
        self.blocks_throttle_ue29_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue29_slow_down_ratio))
        self.blocks_throttle_ue29_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue29_slow_down_ratio))

    def get_ue29_path_loss_db(self):
        return self.ue29_path_loss_db

    def set_ue29_path_loss_db(self, ue29_path_loss_db):
        self.ue29_path_loss_db = ue29_path_loss_db
        self.blocks_ue29_rx_pathloss.set_k(10**(-1.0*self.ue29_path_loss_db/20.0))
        self.blocks_ue29_tx_pathloss.set_k(10**(-1.0*self.ue29_path_loss_db/20.0))

    def get_ue30_slow_down_ratio(self):
        return self.ue30_slow_down_ratio

    def set_ue30_slow_down_ratio(self, ue30_slow_down_ratio):
        self.ue30_slow_down_ratio = ue30_slow_down_ratio
        self.blocks_throttle_ue30_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue30_slow_down_ratio))
        self.blocks_throttle_ue30_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue30_slow_down_ratio))

    def get_ue30_path_loss_db(self):
        return self.ue30_path_loss_db

    def set_ue30_path_loss_db(self, ue30_path_loss_db):
        self.ue30_path_loss_db = ue30_path_loss_db
        self.blocks_ue30_rx_pathloss.set_k(10**(-1.0*self.ue30_path_loss_db/20.0))
        self.blocks_ue30_tx_pathloss.set_k(10**(-1.0*self.ue30_path_loss_db/20.0))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_gnb_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.gnb_slow_down_ratio))
        self.blocks_throttle_gnb_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.gnb_slow_down_ratio))
        self.blocks_throttle_ue1_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue1_slow_down_ratio))
        self.blocks_throttle_ue1_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue1_slow_down_ratio))
        self.blocks_throttle_ue2_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue2_slow_down_ratio))
        self.blocks_throttle_ue2_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue2_slow_down_ratio))
        self.blocks_throttle_ue3_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue3_slow_down_ratio))
        self.blocks_throttle_ue3_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue3_slow_down_ratio))
        self.blocks_throttle_ue4_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue4_slow_down_ratio))
        self.blocks_throttle_ue4_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue4_slow_down_ratio))
        self.blocks_throttle_ue5_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue5_slow_down_ratio))
        self.blocks_throttle_ue5_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue5_slow_down_ratio))
        self.blocks_throttle_ue6_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue6_slow_down_ratio))
        self.blocks_throttle_ue6_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue6_slow_down_ratio))
        self.blocks_throttle_ue7_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue7_slow_down_ratio))
        self.blocks_throttle_ue7_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue7_slow_down_ratio))
        self.blocks_throttle_ue8_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue8_slow_down_ratio))
        self.blocks_throttle_ue8_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue8_slow_down_ratio))
        self.blocks_throttle_ue9_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue9_slow_down_ratio))
        self.blocks_throttle_ue9_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue9_slow_down_ratio))
        self.blocks_throttle_ue10_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue10_slow_down_ratio))
        self.blocks_throttle_ue10_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue10_slow_down_ratio))
        self.blocks_throttle_ue11_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue11_slow_down_ratio))
        self.blocks_throttle_ue11_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue11_slow_down_ratio))
        self.blocks_throttle_ue12_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue12_slow_down_ratio))
        self.blocks_throttle_ue12_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue12_slow_down_ratio))
        self.blocks_throttle_ue13_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue13_slow_down_ratio))
        self.blocks_throttle_ue13_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue13_slow_down_ratio))
        self.blocks_throttle_ue14_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue14_slow_down_ratio))
        self.blocks_throttle_ue14_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue14_slow_down_ratio))
        self.blocks_throttle_ue15_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue15_slow_down_ratio))
        self.blocks_throttle_ue15_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue15_slow_down_ratio))
        self.blocks_throttle_ue16_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue16_slow_down_ratio))
        self.blocks_throttle_ue16_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue16_slow_down_ratio))
        self.blocks_throttle_ue17_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue17_slow_down_ratio))
        self.blocks_throttle_ue17_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue17_slow_down_ratio))
        self.blocks_throttle_ue18_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue18_slow_down_ratio))
        self.blocks_throttle_ue18_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue18_slow_down_ratio))
        self.blocks_throttle_ue19_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue19_slow_down_ratio))
        self.blocks_throttle_ue19_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue19_slow_down_ratio))
        self.blocks_throttle_ue20_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue20_slow_down_ratio))
        self.blocks_throttle_ue20_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue20_slow_down_ratio))
        self.blocks_throttle_ue21_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue21_slow_down_ratio))
        self.blocks_throttle_ue21_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue21_slow_down_ratio))
        self.blocks_throttle_ue22_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue22_slow_down_ratio))
        self.blocks_throttle_ue22_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue22_slow_down_ratio))
        self.blocks_throttle_ue23_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue23_slow_down_ratio))
        self.blocks_throttle_ue23_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue23_slow_down_ratio))
        self.blocks_throttle_ue24_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue24_slow_down_ratio))
        self.blocks_throttle_ue24_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue24_slow_down_ratio))
        self.blocks_throttle_ue25_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue25_slow_down_ratio))
        self.blocks_throttle_ue25_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue25_slow_down_ratio))
        self.blocks_throttle_ue26_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue26_slow_down_ratio))
        self.blocks_throttle_ue26_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue26_slow_down_ratio))
        self.blocks_throttle_ue27_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue27_slow_down_ratio))
        self.blocks_throttle_ue27_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue27_slow_down_ratio))
        self.blocks_throttle_ue28_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue28_slow_down_ratio))
        self.blocks_throttle_ue28_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue28_slow_down_ratio))
        self.blocks_throttle_ue29_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue29_slow_down_ratio))
        self.blocks_throttle_ue29_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue29_slow_down_ratio))
        self.blocks_throttle_ue30_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue30_slow_down_ratio))
        self.blocks_throttle_ue30_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.ue30_slow_down_ratio))

    def get_gnb_slow_down_ratio(self):
        return self.gnb_slow_down_ratio

    def set_gnb_slow_down_ratio(self, gnb_slow_down_ratio):
        self.gnb_slow_down_ratio = gnb_slow_down_ratio
        self.blocks_throttle_gnb_rx.set_sample_rate(1.0*self.samp_rate/(1.0*self.gnb_slow_down_ratio))
        self.blocks_throttle_gnb_tx.set_sample_rate(1.0*self.samp_rate/(1.0*self.gnb_slow_down_ratio))

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
