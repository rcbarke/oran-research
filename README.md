# oran-research
Clemson ORAN Research

This repository contains various ORAN research efforts performed at Clemson University. A full list of tutorials and open source code references, including original sources, can be found documented here:
https://docs.google.com/document/d/1kQapbXp-blz8dMFz4gnLTi-H0D61d1tMv0XCwmHoadU/edit#heading=h.nt2tvvyymnyk

Given the initial goal is to learn the open source frameworks, this repo leverages git submodules pointing back to the authors for now. When we begin heavily modifying code from specific sources, we can clone copies into the repo.

Many of the initial references originate from a combination of OpenRAN Gym and Northeastern University. See:

https://www.nsnam.org/

https://openrangym.com/

---  Software Radio Systems LTE eNodeB  ---

Couldn't open , trying /root/.config/srsran/enb.conf
Reading configuration file /root/.config/srsran/enb.conf...
Couldn't open sib.conf, trying /root/.config/srsran/sib.conf
Couldn't open rr.conf, trying /root/.config/srsran/rr.conf
Couldn't open rb.conf, trying /root/.config/srsran/rb.conf

Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.

2024-09-25T02:31:59.078994 [ENB    ] [I] Using binary srsenb with arguments: --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=10.0.2.15 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006 
2024-09-25T02:31:59.121763 [ENB    ] [I] Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.
2024-09-25T02:31:59.122371 [ENB    ] [I] Using sync queue size of one for ZMQ based radio.
Failed to initiate S1 connection. Attempting reconnection in 10 seconds
Failed to bind on address 10.0.2.15, port 2152: Cannot assign requested address
Error initializing EUTRA stack.
2024-09-25T02:31:59.191882 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T02:31:59.191885 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T02:31:59.191907 [COMN   ] [E] [    0] Failed to bind on address 10.0.2.15: Cannot assign requested address errno 99
2024-09-25T02:31:59.191998 [COMN   ] [W] [    0] RxSockets: The socket fd=-1 to be removed does not exist
2024-09-25T02:31:59.192009 [COMN   ] [E] [    0] Failed to bind on address 10.0.2.15: Cannot assign requested address errno 99
Opening 2 channels in RF device=zmq with args=fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6
Available RF device list: UHD  zmq 
CHx base_srate=23.04e6
CHx id=enb
Current sample rate is 1.92 MHz with a base rate of 23.04 MHz (x12 decimation)
CH0 rx_port=tcp://localhost:2001
CH0 tx_port=tcp://*:2000
CH0 fail_on_disconnect=true
CH1 rx_port=tcp://localhost:2101
CH1 tx_port=tcp://*:2100
2024-09-25T02:31:59.356488 [RIC    ] [D] [    0] log_level = debug

2024-09-25T02:31:59.356492 [E2SM   ] [I] [    0] kpm: building function list

2024-09-25T02:31:59.359024 [RIC    ] [I] [    0] added model ORAN-E2SM-KPM

2024-09-25T02:31:59.359045 [RIC    ] [I] [    0] added model ORAN-E2SM-gNB-NRT

2024-09-25T02:31:59.359047 [RIC    ] [D] [    0] model ORAN-E2SM-KPM function ORAN-E2SM-KPM (function_id 0) enabled and registered

2024-09-25T02:31:59.359048 [RIC    ] [D] [    0] model ORAN-E2SM-gNB-NRT function ORAN-E2SM-gNB-NRT (function_id 1) enabled and registered

2024-09-25T02:31:59.359048 [RIC    ] [D] [    0] RIC state -> INITIALIZED

2024-09-25T02:31:59.364287 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T02:31:59.364297 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T02:31:59.364320 [COMN   ] [D] [    0] Successfully bound to address 10.0.2.101:5006
2024-09-25T02:31:59.365010 [COMN   ] [I] [    0] Failed to establish socket connection to 10.0.2.15
2024-09-25T02:31:59.365452 [RIC    ] [E] [    0] failed to connect to 10.0.2.15
2024-09-25T02:31:59.365469 [RIC    ] [I] [    0] resetting agent connection (reconnect enabled)

2024-09-25T02:31:59.365470 [RIC    ] [I] [    0] pushing connection_reset (1)

2024-09-25T02:31:59.365471 [RIC    ] [I] [    0] pushed connection_reset (2)

2024-09-25T02:31:59.365473 [RIC    ] [I] [    0] stopping agent

2024-09-25T02:31:59.365485 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T02:31:59.365581 [COMN   ] [D] [    0] RxSockets: closed.
2024-09-25T02:31:59.365852 [RIC    ] [D] [    0] RIC state -> INITIALIZED

2024-09-25T02:31:59.365853 [RIC    ] [I] [    0] exiting agent thread

2024-09-25T02:32:01.378897 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T02:32:01.379977 [COMN   ] [D] [    0] RxSockets: closed.
srsRAN crashed... backtrace saved in './srsRAN.backtrace.crash'...
---  exiting  ---

export E2NODE_IP=`hostname -I | cut -f1 -d' '`  # This should be the IP of VM2, e.g., 10.0.2.101
export E2NODE_PORT=5006
export E2TERM_IP=localhost  # Use localhost for the port-forwarded service

sudo srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args="fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6" --ric.agent.remote_ipv4_addr=localhost --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=${E2NODE_IP} --ric.agent.local_port=${E2NODE_PORT}

srsran1@srsRAN1:~$ sudo srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args="fail_on_disconnect=true,tx_port0=tcp://:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6" --ric.agent.remote_ipv4_addr=localhost --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=${E2NODE_IP} --ric.agent.local_port=${E2NODE_PORT}
---  Software Radio Systems LTE eNodeB  ---

Couldn't open , trying /root/.config/srsran/enb.conf
Reading configuration file /root/.config/srsran/enb.conf...
Couldn't open sib.conf, trying /root/.config/srsran/sib.conf
Couldn't open rr.conf, trying /root/.config/srsran/rr.conf
Couldn't open rb.conf, trying /root/.config/srsran/rb.conf

Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.

2024-09-25T02:47:33.559594 [ENB    ] [I] Using binary srsenb with arguments: --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=localhost --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006 
2024-09-25T02:47:33.598328 [ENB    ] [I] Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.
2024-09-25T02:47:33.599218 [ENB    ] [I] Using sync queue size of one for ZMQ based radio.
bind(): Cannot assign requested address
Failed to initiate S1 connection. Attempting reconnection in 10 seconds
bind(): Cannot assign requested address
Failed to bind on address 10.0.2.15, port 2152: Cannot assign requested address
Error initializing EUTRA stack.
2024-09-25T02:47:33.674870 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T02:47:33.674873 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T02:47:33.674894 [COMN   ] [E] [    0] Failed to bind on address 10.0.2.15: Cannot assign requested address errno 99
2024-09-25T02:47:33.674953 [COMN   ] [W] [    0] RxSockets: The socket fd=-1 to be removed does not exist
2024-09-25T02:47:33.674965 [COMN   ] [E] [    0] Failed to bind on address 10.0.2.15: Cannot assign requested address errno 99
Opening 2 channels in RF device=zmq with args=fail_on_disconnect=true,tx_port0=tcp://:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6
Available RF device list: UHD  zmq 
CHx base_srate=23.04e6
CHx id=enb
Current sample rate is 1.92 MHz with a base rate of 23.04 MHz (x12 decimation)
CH0 rx_port=tcp://localhost:2001
CH0 tx_port=tcp://:2000
CH0 fail_on_disconnect=true
Error: binding transmitter socket (tcp://:2000): No such device
[zmq] Error: opening transmitter
Error initializing radio.
2024-09-25T02:47:33.780358 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T02:47:33.781103 [COMN   ] [D] [    0] RxSockets: closed.

sudo srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args="fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6" --ric.agent.remote_ipv4_addr=10.99.193.2 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=${E2NODE_IP} --ric.agent.local_port=${E2NODE_PORT}

srsran1@srsRAN1:~$ sudo srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args="fail_on_disconnect=true,tx_port0=tcp://:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6" --ric.agent.remote_ipv4_addr=10.99.193.2 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=${E2NODE_IP} --ric.agent.local_port=${E2NODE_PORT}
---  Software Radio Systems LTE eNodeB  ---

Couldn't open , trying /root/.config/srsran/enb.conf
Reading configuration file /root/.config/srsran/enb.conf...
Couldn't open sib.conf, trying /root/.config/srsran/sib.conf
Couldn't open rr.conf, trying /root/.config/srsran/rr.conf
Couldn't open rb.conf, trying /root/.config/srsran/rb.conf

Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.

2024-09-25T02:50:05.223408 [ENB    ] [I] Using binary srsenb with arguments: --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=10.99.193.2 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006 
2024-09-25T02:50:05.266037 [ENB    ] [I] Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.
2024-09-25T02:50:05.266723 [ENB    ] [I] Using sync queue size of one for ZMQ based radio.
bind(): Cannot assign requested address
Failed to initiate S1 connection. Attempting reconnection in 10 seconds
bind(): Cannot assign requested address
Failed to bind on address 10.0.2.15, port 2152: Cannot assign requested address
Error initializing EUTRA stack.
2024-09-25T02:50:05.344561 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T02:50:05.344563 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T02:50:05.344584 [COMN   ] [E] [    0] Failed to bind on address 10.0.2.15: Cannot assign requested address errno 99
2024-09-25T02:50:05.344648 [COMN   ] [W] [    0] RxSockets: The socket fd=-1 to be removed does not exist
2024-09-25T02:50:05.344660 [COMN   ] [E] [    0] Failed to bind on address 10.0.2.15: Cannot assign requested address errno 99
Opening 2 channels in RF device=zmq with args=fail_on_disconnect=true,tx_port0=tcp://:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6
Available RF device list: UHD  zmq 
CHx base_srate=23.04e6
CHx id=enb
Current sample rate is 1.92 MHz with a base rate of 23.04 MHz (x12 decimation)
CH0 rx_port=tcp://localhost:2001
CH0 tx_port=tcp://:2000
CH0 fail_on_disconnect=true
Error: binding transmitter socket (tcp://:2000): No such device
[zmq] Error: opening transmitter
Error initializing radio.
2024-09-25T02:50:05.456627 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T02:50:05.459944 [COMN   ] [D] [    0] RxSockets: closed.

sudo srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args="fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6" --ric.agent.remote_ipv4_addr=localhost --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006
