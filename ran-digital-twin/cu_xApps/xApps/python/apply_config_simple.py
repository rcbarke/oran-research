#!/usr/bin/env python3

import time
import datetime
import argparse
import signal
from lib.xAppBase import xAppBase
import json

class MyXapp(xAppBase):
    def __init__(self, config, http_server_port, rmr_port):
        super(MyXapp, self).__init__(config, http_server_port, rmr_port)
        pass                

    @xAppBase.start_function
    def start(self, e2_node_id, ue_id):
        with open("/opt/xApps/alloc.json", "r") as file:
            last_content = json.load(file)
        self.ue_dict = {}
        while self.running:
            with open("/opt/xApps/alloc.json", "r") as file:
                current_content = json.load(file)
                if current_content != last_content:
                    print("New content")
                    last_content = current_content
                    for item in current_content:
                        if "version" in item:
                            continue
                        print(f"ID:{int(item['id']-1)}, MIN_PRB:{int(item['min_prb'])}, MAX_PRB:{int(item['max_prb'])}, DEDICATED_PRB:{int(item['ded_prb'])}") 
                        self.e2sm_rc.control_slice_level_prb_quota(e2_node_id, 
                                                                   ue_id=int(item['id']-1), 
                                                                   min_prb_ratio=int(item['min_prb']), 
                                                                   max_prb_ratio=int(item['max_prb']), 
                                                                   dedicated_prb_ratio=int(item['ded_prb']), 
                                                                   ack_request=1)
            time.sleep(0.3)



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='My example xApp')
    parser.add_argument("--config", type=str, default='', help="xApp config file path")
    parser.add_argument("--http_server_port", type=int, default=8090, help="HTTP server listen port")
    parser.add_argument("--rmr_port", type=int, default=4560, help="RMR port")
    parser.add_argument("--e2_node_id", type=str, default='gnbd_001_001_00019b_0', help="E2 Node ID")
    parser.add_argument("--ran_func_id", type=int, default=3, help="E2SM RC RAN function ID")
    parser.add_argument("--ue_id", type=int, default=0, help="UE ID")


    args = parser.parse_args()
    config = args.config
    e2_node_id = args.e2_node_id 
    ran_func_id = args.ran_func_id
    ue_id = args.ue_id

    # Create MyXapp.
    myXapp = MyXapp(config, args.http_server_port, args.rmr_port)
    myXapp.e2sm_rc.set_ran_func_id(ran_func_id)

    # Connect exit signals.
    signal.signal(signal.SIGQUIT, myXapp.signal_handler)
    signal.signal(signal.SIGTERM, myXapp.signal_handler)
    signal.signal(signal.SIGINT, myXapp.signal_handler)

    # Start xApp.
    myXapp.start(e2_node_id, ue_id)