#!/usr/bin/env python3

import time
import datetime
import argparse
import signal
from lib.xAppBase import xAppBase
import json
import subprocess

class MyXapp(xAppBase):
    def __init__(self, config, http_server_port, rmr_port):
        super(MyXapp, self).__init__(config, http_server_port, rmr_port)
        pass

    def my_subscription_callback(self, e2_agent_id, subscription_id, indication_hdr, indication_msg, kpm_report_style, ue_id):
        if self.initilization:
            meas_data = self.e2sm_kpm.extract_meas_data(indication_msg)
            for ue_id, ue_meas_data in meas_data["ueMeasData"].items():
                dl = ue_meas_data["measData"]["DRB.UEThpDl"][0]
                if self.current_user_id is None:
                    if dl > 20:
                        self.current_user_id = ue_id
                else:
                    if self.current_user_id == ue_id:
                        if dl < 3:
                            self.finished_transfer = True

        if self.log:
            meas_data = self.e2sm_kpm.extract_meas_data(indication_msg)
            for ue_id, ue_meas_data in meas_data["ueMeasData"].items():
                if self.counter > 0 or self.ue_dict[ue_id]["store"]:
                    dl = ue_meas_data["measData"]["DRB.UEThpDl"][0]
                    self.ue_dict[ue_id]["dl_thp"].append(dl)
                    if self.counter < 0 and dl < 3:
                        self.ue_dict[ue_id]["store"] = False
                        # Find the top 5 values in self.ue_dict[ue_id]["dl_thp"] and average them
                        average_top_5 = sum(sorted(self.ue_dict[ue_id]["dl_thp"], reverse=True)[:5]) / 5
                        key = next((k for k, v in self.user_map.items() if v == ue_id), None)
                        self.result.append([key, average_top_5])

                        self.remaining_cnt -= 1
            self.counter -= 1

            if self.remaining_cnt == 0:
                print("All UEs are done")
                self.log = False
                with open("/opt/xApps/res.json", "w") as file:
                    data = []
                    for ue_id, ue_data in self.result:
                        data.append({
                            "id": int(ue_id),
                            "dl_thp": ue_data,
                        })
                    json.dump(data, file)
                    
                            

    @xAppBase.start_function
    def start(self, e2_node_id, ue_id):
        self.initilization = False
        self.user_map = {}
        report_period = 125
        granul_period = 125
        subscription_callback = lambda agent, sub, hdr, msg: self.my_subscription_callback(agent, sub, hdr, msg, 5, None)
        ue_ids = [0,1,2,3,4,5,6,7,8,9,10,11]
        self.e2sm_kpm.subscribe_report_service_style_5(e2_node_id, report_period, ue_ids, ["DRB.UEThpDl"], granul_period, subscription_callback)

        # Initialization
        self.initilization = True
        for user in ue_ids:
            # Generate Traffic
            command = f"iperf -c 10.45.1.{user+3} -u -t 2 -b 10M"
            self.current_user = user
            self.current_user_id = None
            self.finished_transfer = False
            proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            try:
                proc.wait(timeout=10)  # Timeout after 40 seconds
            except subprocess.TimeoutExpired:
                proc.kill()
                raise TimeoutError(f"Timeout exceeded")
            while not self.finished_transfer:
                time.sleep(0.3)
            self.user_map[user+1] = self.current_user_id
        self.initilization = False
        print(self.user_map)

        with open("/opt/xApps/alloc.json", "r") as file:
            last_content = json.load(file)
        self.ue_dict = {}
        self.remaining_cnt = 0
        while self.running:
            #current_time = datetime.datetime.now()
            #self.e2sm_rc.control_slice_level_prb_quota(e2_node_id, ue_id, min_prb_ratio=1, max_prb_ratio=2, dedicated_prb_ratio=2, ack_request=1)
            with open("/opt/xApps/alloc.json", "r") as file:
                current_content = json.load(file)
                if current_content != last_content:
                    print("New content")
                    with open("/opt/xApps/res.json", "w") as file:
                        file.write("")
                    last_content = current_content
                    self.result = {}
                    for item in current_content:
                        if "version" in item:
                            continue
                        print(f"ID:{int(item['id'])}, MIN_PRB:{int(item['min_prb'])}, MAX_PRB:{int(item['max_prb'])}, DEDICATED_PRB:{int(item['ded_prb'])}") 
                        self.ue_dict[self.user_map[int(item['id'])]] = {
                            "dl_thp":[],
                            "store":True,
                        }
                        self.remaining_cnt += 1
                        self.e2sm_rc.control_slice_level_prb_quota(e2_node_id, 
                                                                   ue_id=self.user_map[int(item['id'])], 
                                                                   min_prb_ratio=int(item['min_prb']), 
                                                                   max_prb_ratio=int(item['max_prb']), 
                                                                   dedicated_prb_ratio=int(item['ded_prb']), 
                                                                   ack_request=1)
                    self.log = True
                    self.counter = 10
                    while self.log:
                        time.sleep(0.3)

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