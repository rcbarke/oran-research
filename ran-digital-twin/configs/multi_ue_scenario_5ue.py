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
        self.ue5_prb = ue5_prb = 2
        self.ue5_pathloss_db = ue5_pathloss_db = 20
        self.ue4_prb = ue4_prb = 2
        self.ue4_pathloss_db = ue4_pathloss_db = 20
        self.ue3_prb = ue3_prb = 2
        self.ue3_pathloss_db = ue3_pathloss_db = 20
        self.ue2_prb = ue2_prb = 2
        self.ue2_pathloss_db = ue2_pathloss_db = 20
        self.ue1_prb = ue1_prb = 2
        self.ue1_pathloss_db = ue1_pathloss_db = 20
        self.total_prb = total_prb = 52
        self.samp_rate = samp_rate = 11520000
        self.max_pathloss_db = max_pathloss_db = 107.76
        self.fft_length = fft_length = 1024
        self.constellation_qpsk = constellation_qpsk = digital.constellation_qpsk().base()

        ##################################################
        # Blocks
        ##################################################
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
        self.digital_ofdm_tx_ue5 = digital.ofdm_tx(
            fft_len=fft_length,
            cp_len=int(0.07*fft_length),
            packet_length_tag_key='length',
            occupied_carriers=[list(range(int((-1 * ue5_prb * 12) / 2), 0)) + list(range(1, int((1 * ue5_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_tx_ue4 = digital.ofdm_tx(
            fft_len=fft_length,
            cp_len=int(0.07*fft_length),
            packet_length_tag_key='length',
            occupied_carriers=[list(range(int((-1 * ue4_prb * 12) / 2), 0)) + list(range(1, int((1 * ue4_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_tx_ue3 = digital.ofdm_tx(
            fft_len=fft_length,
            cp_len=int(0.07*fft_length),
            packet_length_tag_key='length',
            occupied_carriers=[list(range(int((-1 * ue3_prb * 12) / 2), 0)) + list(range(1, int((1 * ue3_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_tx_ue2 = digital.ofdm_tx(
            fft_len=fft_length,
            cp_len=int(0.07*fft_length),
            packet_length_tag_key='length',
            occupied_carriers=[list(range(int((-1 * ue2_prb * 12) / 2), 0)) + list(range(1, int((1 * ue2_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_tx_ue1 = digital.ofdm_tx(
            fft_len=fft_length,
            cp_len=int(0.07*fft_length),
            packet_length_tag_key='length',
            occupied_carriers=[list(range(int((-1 * ue1_prb * 12) / 2), 0)) + list(range(1, int((1 * ue1_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            rolloff=0,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_tx_gnb = digital.ofdm_tx(
            fft_len=fft_length,
            cp_len=int(0.07*fft_length),
            packet_length_tag_key='length',
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
        self.digital_ofdm_rx_gnb = digital.ofdm_rx(
            fft_len=fft_length, cp_len=int(0.07*fft_length),
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(int((-1 * total_prb * 12) / 2), 0)) + list(range(1, int((1 * total_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_ue5 = digital.ofdm_rx(
            fft_len=fft_length, cp_len=int(0.07*fft_length),
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(int((-1 * ue5_prb * 12) / 2), 0)) + list(range(1, int((1 * ue5_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_ue4 = digital.ofdm_rx(
            fft_len=fft_length, cp_len=int(0.07*fft_length),
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(int((-1 * ue4_prb * 12) / 2), 0)) + list(range(1, int((1 * ue4_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_ue3 = digital.ofdm_rx(
            fft_len=fft_length, cp_len=int(0.07*fft_length),
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(int((-1 * ue3_prb * 12) / 2), 0)) + list(range(1, int((1 * ue3_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_ue2 = digital.ofdm_rx(
            fft_len=fft_length, cp_len=int(0.07*fft_length),
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(int((-1 * ue2_prb * 12) / 2), 0)) + list(range(1, int((1 * ue2_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_ofdm_rx_ue1 = digital.ofdm_rx(
            fft_len=fft_length, cp_len=int(0.07*fft_length),
            frame_length_tag_key='frame_'+"length",
            packet_length_tag_key="length",
            occupied_carriers=[list(range(int((-1 * ue1_prb * 12) / 2), 0)) + list(range(1, int((1 * ue1_prb * 12) / 2)))],
            pilot_carriers=[[ -21, -7, 7, 21 ]],
            pilot_symbols=[[1, 1, 1, -1]],
            sync_word1=[0] * fft_length,
            sync_word2=[1] * fft_length,
            bps_header=2,
            bps_payload=2,
            debug_log=False,
            scramble_bits=False)
        self.digital_constellation_encoder_gnb = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_encoder_ue5 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_encoder_ue4 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_encoder_ue3 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_encoder_ue2 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_encoder_ue1 = digital.constellation_encoder_bc(constellation_qpsk)
        self.digital_constellation_decoder_ue5 = digital.constellation_decoder_cb(constellation_qpsk)
        self.digital_constellation_decoder_ue4 = digital.constellation_decoder_cb(constellation_qpsk)
        self.digital_constellation_decoder_ue3 = digital.constellation_decoder_cb(constellation_qpsk)
        self.digital_constellation_decoder_ue2 = digital.constellation_decoder_cb(constellation_qpsk)
        self.digital_constellation_decoder_ue1 = digital.constellation_decoder_cb(constellation_qpsk)
        self.digital_constellation_decoder_gnb = digital.constellation_decoder_cb(constellation_qpsk)
        self.blocks_ue_tx_to_gnb_rx_add = blocks.add_vcc(1)
        self.blocks_ue5_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue5_pathloss_db/20.0))
        self.blocks_ue5_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue5_pathloss_db/20.0))
        self.blocks_ue4_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue4_pathloss_db/20.0))
        self.blocks_ue4_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue4_pathloss_db/20.0))
        self.blocks_ue3_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue3_pathloss_db/20.0))
        self.blocks_ue3_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue3_pathloss_db/20.0))
        self.blocks_ue2_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue2_pathloss_db/20.0))
        self.blocks_ue2_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue2_pathloss_db/20.0))
        self.blocks_ue1_tx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue1_pathloss_db/20.0))
        self.blocks_ue1_rx_pathloss = blocks.multiply_const_cc(10**(-1.0*ue1_pathloss_db/20.0))


        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_ue1_rx_pathloss, 0), (self.digital_ofdm_rx_ue1, 0))
        self.connect((self.blocks_ue1_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 0))
        self.connect((self.blocks_ue2_rx_pathloss, 0), (self.digital_ofdm_rx_ue2, 0))
        self.connect((self.blocks_ue2_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 1))
        self.connect((self.blocks_ue3_rx_pathloss, 0), (self.digital_ofdm_rx_ue3, 0))
        self.connect((self.blocks_ue3_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 2))
        self.connect((self.blocks_ue4_rx_pathloss, 0), (self.digital_ofdm_rx_ue4, 0))
        self.connect((self.blocks_ue4_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 3))
        self.connect((self.blocks_ue5_rx_pathloss, 0), (self.digital_ofdm_rx_ue5, 0))
        self.connect((self.blocks_ue5_tx_pathloss, 0), (self.blocks_ue_tx_to_gnb_rx_add, 4))
        self.connect((self.blocks_ue_tx_to_gnb_rx_add, 0), (self.digital_ofdm_rx_gnb, 0))
        self.connect((self.digital_constellation_decoder_gnb, 0), (self.digital_ofdm_tx_gnb, 0))
        self.connect((self.digital_constellation_decoder_ue1, 0), (self.digital_ofdm_tx_ue1, 0))
        self.connect((self.digital_constellation_decoder_ue2, 0), (self.digital_ofdm_tx_ue2, 0))
        self.connect((self.digital_constellation_decoder_ue3, 0), (self.digital_ofdm_tx_ue3, 0))
        self.connect((self.digital_constellation_decoder_ue4, 0), (self.digital_ofdm_tx_ue4, 0))
        self.connect((self.digital_constellation_decoder_ue5, 0), (self.digital_ofdm_tx_ue5, 0))
        self.connect((self.digital_constellation_encoder_ue1, 0), (self.zeromq_ue1_rx, 0))
        self.connect((self.digital_constellation_encoder_ue2, 0), (self.zeromq_ue2_rx, 0))
        self.connect((self.digital_constellation_encoder_ue3, 0), (self.zeromq_ue3_rx, 0))
        self.connect((self.digital_constellation_encoder_ue4, 0), (self.zeromq_ue4_rx, 0))
        self.connect((self.digital_constellation_encoder_ue5, 0), (self.zeromq_ue5_rx, 0))
        self.connect((self.digital_constellation_encoder_gnb, 0), (self.zeromq_gnb_rx, 0))
        self.connect((self.digital_ofdm_rx_ue1, 0), (self.digital_constellation_encoder_ue1, 0))
        self.connect((self.digital_ofdm_rx_ue2, 0), (self.digital_constellation_encoder_ue2, 0))
        self.connect((self.digital_ofdm_rx_ue3, 0), (self.digital_constellation_encoder_ue3, 0))
        self.connect((self.digital_ofdm_rx_ue4, 0), (self.digital_constellation_encoder_ue4, 0))
        self.connect((self.digital_ofdm_rx_ue5, 0), (self.digital_constellation_encoder_ue5, 0))
        self.connect((self.digital_ofdm_rx_gnb, 0), (self.digital_constellation_encoder_gnb, 0))
        self.connect((self.digital_ofdm_tx_gnb, 0), (self.blocks_ue1_rx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_gnb, 0), (self.blocks_ue2_rx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_gnb, 0), (self.blocks_ue3_rx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_gnb, 0), (self.blocks_ue4_rx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_gnb, 0), (self.blocks_ue5_rx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_ue1, 0), (self.blocks_ue1_tx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_ue2, 0), (self.blocks_ue2_tx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_ue3, 0), (self.blocks_ue3_tx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_ue4, 0), (self.blocks_ue4_tx_pathloss, 0))
        self.connect((self.digital_ofdm_tx_ue5, 0), (self.blocks_ue5_tx_pathloss, 0))
        self.connect((self.zeromq_gnb_tx, 0), (self.digital_constellation_decoder_gnb, 0))
        self.connect((self.zeromq_ue1_tx, 0), (self.digital_constellation_decoder_ue1, 0))
        self.connect((self.zeromq_ue2_tx, 0), (self.digital_constellation_decoder_ue2, 0))
        self.connect((self.zeromq_ue3_tx, 0), (self.digital_constellation_decoder_ue3, 0))
        self.connect((self.zeromq_ue4_tx, 0), (self.digital_constellation_decoder_ue4, 0))
        self.connect((self.zeromq_ue5_tx, 0), (self.digital_constellation_decoder_ue5, 0))
    
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
        """Update the UE-specific variables based on the config data."""
        # Example: Update prb and pathloss for each UE
        if '1' in config_data:
            self.set_ue1_prb(config_data['1']['prb'])
            self.set_ue1_pathloss_db(config_data['1']['pathloss'])
            # print(f"UE1 Pathloss: {config_data['1']['pathloss']} dB")  # Verifies file read functionality 
        if '2' in config_data:
            self.set_ue2_prb(config_data['2']['prb'])
            self.set_ue2_pathloss_db(config_data['2']['pathloss'])

        if '3' in config_data:
            self.set_ue3_prb(config_data['3']['prb'])
            self.set_ue3_pathloss_db(config_data['3']['pathloss'])

        if '4' in config_data:
            self.set_ue4_prb(config_data['4']['prb'])
            self.set_ue4_pathloss_db(config_data['4']['pathloss'])

        if '5' in config_data:
            self.set_ue5_prb(config_data['5']['prb'])
            self.set_ue5_pathloss_db(config_data['5']['pathloss'])
        pass

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

    def get_ue5_prb(self):
        return self.ue5_prb

    def set_ue5_prb(self, ue5_prb):
        self.ue5_prb = ue5_prb

    def get_ue5_pathloss_db(self):
        return self.ue5_pathloss_db

    def set_ue5_pathloss_db(self, ue5_pathloss_db):
        self.ue5_pathloss_db = ue5_pathloss_db
        self.blocks_ue5_rx_pathloss.set_k(10**(-1.0*self.ue5_pathloss_db/20.0))
        self.blocks_ue5_tx_pathloss.set_k(10**(-1.0*self.ue5_pathloss_db/20.0))

    def get_ue4_prb(self):
        return self.ue4_prb

    def set_ue4_prb(self, ue4_prb):
        self.ue4_prb = ue4_prb

    def get_ue4_pathloss_db(self):
        return self.ue4_pathloss_db

    def set_ue4_pathloss_db(self, ue4_pathloss_db):
        self.ue4_pathloss_db = ue4_pathloss_db
        self.blocks_ue4_rx_pathloss.set_k(10**(-1.0*self.ue4_pathloss_db/20.0))
        self.blocks_ue4_tx_pathloss.set_k(10**(-1.0*self.ue4_pathloss_db/20.0))

    def get_ue3_prb(self):
        return self.ue3_prb

    def set_ue3_prb(self, ue3_prb):
        self.ue3_prb = ue3_prb

    def get_ue3_pathloss_db(self):
        return self.ue3_pathloss_db

    def set_ue3_pathloss_db(self, ue3_pathloss_db):
        self.ue3_pathloss_db = ue3_pathloss_db
        self.blocks_ue3_rx_pathloss.set_k(10**(-1.0*self.ue3_pathloss_db/20.0))
        self.blocks_ue3_tx_pathloss.set_k(10**(-1.0*self.ue3_pathloss_db/20.0))

    def get_ue2_prb(self):
        return self.ue2_prb

    def set_ue2_prb(self, ue2_prb):
        self.ue2_prb = ue2_prb

    def get_ue2_pathloss_db(self):
        return self.ue2_pathloss_db

    def set_ue2_pathloss_db(self, ue2_pathloss_db):
        self.ue2_pathloss_db = ue2_pathloss_db
        self.blocks_ue2_rx_pathloss.set_k(10**(-1.0*self.ue2_pathloss_db/20.0))
        self.blocks_ue2_tx_pathloss.set_k(10**(-1.0*self.ue2_pathloss_db/20.0))

    def get_ue1_prb(self):
        return self.ue1_prb

    def set_ue1_prb(self, ue1_prb):
        self.ue1_prb = ue1_prb

    def get_ue1_pathloss_db(self):
        return self.ue1_pathloss_db

    def set_ue1_pathloss_db(self, ue1_pathloss_db):
        self.ue1_pathloss_db = ue1_pathloss_db
        self.blocks_ue1_rx_pathloss.set_k(10**(-1.0*self.ue1_pathloss_db/20.0))
        self.blocks_ue1_tx_pathloss.set_k(10**(-1.0*self.ue1_pathloss_db/20.0))

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
