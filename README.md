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

sudo srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args="fail_on_disconnect=true,tx_port0=tcp://:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6" --ric.agent.remote_ipv4_addr=localhost --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006
---  Software Radio Systems LTE eNodeB  ---

Couldn't open , trying /root/.config/srsran/enb.conf
Reading configuration file /root/.config/srsran/enb.conf...
Couldn't open sib.conf, trying /root/.config/srsran/sib.conf
Couldn't open rr.conf, trying /root/.config/srsran/rr.conf
Couldn't open rb.conf, trying /root/.config/srsran/rb.conf

Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.

2024-09-25T02:53:10.901351 [ENB    ] [I] Using binary srsenb with arguments: --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=localhost --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006 
2024-09-25T02:53:10.939223 [ENB    ] [I] Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.
2024-09-25T02:53:10.939838 [ENB    ] [I] Using sync queue size of one for ZMQ based radio.
bind(): Cannot assign requested address
2024-09-25T02:53:11.007921 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T02:53:11.007924 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T02:53:11.007946 [COMN   ] [E] [    0] Failed to bind on address 10.0.2.15: Cannot assign requested address errno 99
Failed to initiate S1 connection. Attempting reconnection in 10 seconds
bind(): Cannot assign requested address
Failed to bind on address 10.0.2.15, port 2152: Cannot assign requested address
Error initializing EUTRA stack.
2024-09-25T02:53:11.008006 [COMN   ] [W] [    0] RxSockets: The socket fd=-1 to be removed does not exist
2024-09-25T02:53:11.008017 [COMN   ] [E] [    0] Failed to bind on address 10.0.2.15: Cannot assign requested address errno 99
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
2024-09-25T02:53:11.107806 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T02:53:11.108580 [COMN   ] [D] [    0] RxSockets: closed.



srsran1@srsRAN1:~$ sudo srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args="fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6" --ric.agent.remote_ipv4_addr=${E2TERM_IP} --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=${E2NODE_IP} --ric.agent.local_port=${E2NODE_PORT}
[sudo] password for srsran1: 
---  Software Radio Systems LTE eNodeB  ---

Couldn't open , trying /root/.config/srsran/enb.conf
Reading configuration file /root/.config/srsran/enb.conf...
Couldn't open sib.conf, trying /root/.config/srsran/sib.conf
Couldn't open rr.conf, trying /root/.config/srsran/rr.conf
Couldn't open rb.conf, trying /root/.config/srsran/rb.conf

Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.

2024-09-25T14:19:02.917035 [ENB    ] [I] Using binary srsenb with arguments: --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=10.0.2.15 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006 
2024-09-25T14:19:02.956294 [ENB    ] [I] Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.
2024-09-25T14:19:02.956911 [ENB    ] [I] Using sync queue size of one for ZMQ based radio.
inet_pton: Success
Failed to initiate S1 connection. Attempting reconnection in 10 seconds
inet_pton: Success
Failed to bind on address 127.0.1.1:, port 2152: Success
Error initializing EUTRA stack.
2024-09-25T14:19:03.026707 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T14:19:03.026710 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T14:19:03.026755 [COMN   ] [E] [    0] Failed to convert IP address (127.0.1.1:) to sockaddr_in struct
2024-09-25T14:19:03.026776 [COMN   ] [W] [    0] RxSockets: The socket fd=-1 to be removed does not exist
2024-09-25T14:19:03.026794 [COMN   ] [E] [    0] Failed to convert IP address (127.0.1.1:) to sockaddr_in struct
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
2024-09-25T14:19:03.192748 [RIC    ] [D] [    0] log_level = debug

2024-09-25T14:19:03.192753 [E2SM   ] [I] [    0] kpm: building function list

2024-09-25T14:19:03.196686 [RIC    ] [I] [    0] added model ORAN-E2SM-KPM

2024-09-25T14:19:03.196711 [RIC    ] [I] [    0] added model ORAN-E2SM-gNB-NRT

2024-09-25T14:19:03.196713 [RIC    ] [D] [    0] model ORAN-E2SM-KPM function ORAN-E2SM-KPM (function_id 0) enabled and registered

2024-09-25T14:19:03.196714 [RIC    ] [D] [    0] model ORAN-E2SM-gNB-NRT function ORAN-E2SM-gNB-NRT (function_id 1) enabled and registered

2024-09-25T14:19:03.196714 [RIC    ] [D] [    0] RIC state -> INITIALIZED

2024-09-25T14:19:03.201394 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T14:19:03.201397 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T14:19:03.201415 [COMN   ] [D] [    0] Successfully bound to address 10.0.2.101:5006
2024-09-25T14:19:03.202236 [COMN   ] [I] [    0] Failed to establish socket connection to 10.0.2.15
connect(): Connection refused
2024-09-25T14:19:03.202577 [RIC    ] [E] [    0] failed to connect to 10.0.2.15
2024-09-25T14:19:03.202593 [RIC    ] [I] [    0] resetting agent connection (reconnect enabled)

2024-09-25T14:19:03.202594 [RIC    ] [I] [    0] pushing connection_reset (1)

2024-09-25T14:19:03.202594 [RIC    ] [I] [    0] pushed connection_reset (2)

2024-09-25T14:19:03.202596 [RIC    ] [I] [    0] stopping agent

2024-09-25T14:19:03.202603 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T14:19:03.202723 [COMN   ] [D] [    0] RxSockets: closed.
2024-09-25T14:19:03.202971 [RIC    ] [D] [    0] RIC state -> INITIALIZED

2024-09-25T14:19:03.202972 [RIC    ] [I] [    0] exiting agent thread

2024-09-25T14:19:05.257195 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T14:19:05.257748 [COMN   ] [D] [    0] RxSockets: closed.
srsRAN crashed... backtrace saved in './srsRAN.backtrace.crash'...
---  exiting  ---
srsran1@srsRAN1:~$ cat ./srsRAN.backtrace.crash 
--- command='srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=10.0.2.15 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006' version=21.10.0 signal=11 date='25/09/2024 02:26:39' ---
	srsenb(+0x335d32) [0x55dc6b200d32]
	/lib/x86_64-linux-gnu/libc.so.6(+0x43090) [0x7f3c38849090]
	/lib/x86_64-linux-gnu/libpthread.so.0(+0x9aab) [0x7f3c391deaab]
	srsenb(+0x29790c) [0x55dc6b16290c]
	srsenb(+0x299209) [0x55dc6b164209]
	srsenb(+0x299e0d) [0x55dc6b164e0d]
	srsenb(+0xfcb87) [0x55dc6afc7b87]
	srsenb(+0xfcc9d) [0x55dc6afc7c9d]
	srsenb(+0xdf1f5) [0x55dc6afaa1f5]
	/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf3) [0x7f3c3882a083]
	srsenb(_start+0x2e) [0x55dc6afabf6e]

--- command='srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=10.0.2.15 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006' version=21.10.0 signal=11 date='25/09/2024 02:32:01' ---
	srsenb(+0x335d32) [0x5648a84e4d32]
	/lib/x86_64-linux-gnu/libc.so.6(+0x43090) [0x7f5b74173090]
	/lib/x86_64-linux-gnu/libpthread.so.0(+0x9aab) [0x7f5b74b08aab]
	srsenb(+0x29790c) [0x5648a844690c]
	srsenb(+0x299209) [0x5648a8448209]
	srsenb(+0x299e0d) [0x5648a8448e0d]
	srsenb(+0xfcb87) [0x5648a82abb87]
	srsenb(+0xfcc9d) [0x5648a82abc9d]
	srsenb(+0xdf1f5) [0x5648a828e1f5]
	/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf3) [0x7f5b74154083]
	srsenb(_start+0x2e) [0x5648a828ff6e]

--- command='srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=10.0.2.15 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006' version=21.10.0 signal=11 date='25/09/2024 14:19:05' ---
	srsenb(+0x335d32) [0x5575c23a8d32]
	/lib/x86_64-linux-gnu/libc.so.6(+0x43090) [0x7fe5ebbf9090]
	/lib/x86_64-linux-gnu/libpthread.so.0(+0x9aab) [0x7fe5ec58eaab]
	srsenb(+0x29790c) [0x5575c230a90c]
	srsenb(+0x299209) [0x5575c230c209]
	srsenb(+0x299e0d) [0x5575c230ce0d]
	srsenb(+0xfcb87) [0x5575c216fb87]
	srsenb(+0xfcc9d) [0x5575c216fc9d]
	srsenb(+0xdf1f5) [0x5575c21521f5]
	/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf3) [0x7fe5ebbda083]
	srsenb(_start+0x2e) [0x5575c2153f6e]


srsran1@srsRAN1:~/oaic/srsRAN-e2/srsenb$ telnet 10.0.2.15 32321
Trying 10.0.2.15...
Connected to 10.0.2.15.
Escape character is '^]'.


#####################################################################
#                   srsENB configuration file
#####################################################################

#####################################################################
# eNB configuration
#####################################################################
[enb]
#enb_id:               20-bit eNB identifier.
#enb_id = 0x19B
enb_id = 0x19B  # eNB ID for identification

#mcc:                  Mobile Country Code
#mcc = 001
mcc = 001  # Example MCC for testing

#mnc:                  Mobile Network Code
#mnc = 01
mnc = 01  # Example MNC for testing

#mme_addr:             IP address of MME for S1 connection
#mme_addr = 127.0.1.100
mme_addr = 10.0.2.15  # IP address of MME (VM1)

#gtp_bind_addr:        Local IP address to bind for GTP connection
#gtp_bind_addr = 127.0.1.1
gtp_bind_addr = 10.0.2.15  # Binding to the same IP as MME for simplicity

#s1c_bind_addr:        Local IP address to bind for S1AP connection
#s1c_bind_addr = 127.0.1.1
s1c_bind_addr = 10.0.2.15  # Binding to the same IP as MME for simplicity

#s1c_bind_port:        Source port for S1AP connection (0 means any)
#s1c_bind_port = 0
s1c_bind_port = 36412  # Common port for S1AP

#n_prb:                Number of Physical Resource Blocks (6,15,25,50,75,100)
#n_prb = 50
n_prb = 25  # Reduced PRBs for simpler setup

#tm:                   Transmission mode 1-4 (TM1 default)
#tm = 4
tm = 1  # Basic Transmission Mode

#nof_ports:            Number of Tx ports (1 port default, set to 2 for TM2/3/4)
#nof_ports = 2
nof_ports = 1  # Single Tx port for simplicity

#####################################################################
# eNB configuration files
#####################################################################
[enb_files]
sib_config = sib.conf
rr_config  = rr.conf
rb_config = rb.conf

#####################################################################
# RF configuration
#####################################################################
[rf]
#dl_earfcn: EARFCN code for DL (only valid if a single cell is configured in rr.conf)
#dl_earfcn = 3350
dl_earfcn = 100  # Set to a test EARFCN

#tx_gain: Transmit gain (dB).
#tx_gain = 80
tx_gain = 20  # Reduced gain for initial tests

#rx_gain: Optional receive gain (dB). If disabled, AGC is enabled
#rx_gain = 40
rx_gain = 0  # Default receive gain

#device_name:        Device driver family
#device_name = auto
device_name = zmq  # Using ZMQ for simplicity

#device_args:        Arguments for the device driver. Options are "auto" or any string.
#device_args = auto
device_args = fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001

#####################################################################
# Packet capture configuration
#####################################################################
[pcap]
enable = true  # Enable packet capture for debugging
filename = /tmp/enb.pcap
s1ap_enable = true  # Enable S1AP packet capture
s1ap_filename = /tmp/enb_s1ap.pcap

mac_net_enable = false
bind_ip = 0.0.0.0
bind_port = 5687
client_ip = 127.0.0.1
client_port = 5847

#####################################################################
# Log configuration
#####################################################################
[log]
all_level = info  # Set log level to info for better visibility
all_hex_limit = 32
filename = /tmp/enb.log
file_max_size = -1

[gui]
enable = false

#####################################################################
# Scheduler configuration options
#####################################################################
[scheduler]
#policy     = time_pf
policy = time_rr  # Simple round-robin scheduling
#min_aggr_level   = 0
min_aggr_level = 0
#max_aggr_level   = 3
max_aggr_level = 3
#adaptive_aggr_level = false
adaptive_aggr_level = false
#pdsch_mcs        = -1
pdsch_mcs = -1
#pdsch_max_mcs    = -1
pdsch_max_mcs = 16
#pusch_mcs        = -1
pusch_mcs = -1
#pusch_max_mcs    = 16
pusch_max_mcs = 16
#min_nof_ctrl_symbols = 1
min_nof_ctrl_symbols = 1
#max_nof_ctrl_symbols = 3
max_nof_ctrl_symbols = 3
#target_bler = 0.05
target_bler = 0.05

#####################################################################
# eMBMS configuration options
#####################################################################
[embms]
#enable = false
enable = false
#m1u_multiaddr = 239.255.0.1
m1u_multiaddr = 239.255.0.1
#m1u_if_addr = 127.0.1.201
m1u_if_addr = 127.0.1.201
#mcs = 20
mcs = 20

#####################################################################
# Expert configuration options
#####################################################################
[expert]
#pusch_max_its        = 8 # These are half iterations
#nr_pusch_max_its     = 10
#nof_phy_threads      = 3
#metrics_period_secs  = 1
#metrics_csv_enable   = false
#report_json_enable   = true
#alarms_log_enable    = true

srsran1@srsRAN1:~/oaic/srsRAN-e2/srsenb$ sudo srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args="fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6" --ric.agent.remote_ipv4_addr=${E2TERM_IP} --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=${E2NODE_IP} --ric.agent.local_port=${E2NODE_PORT}
---  Software Radio Systems LTE eNodeB  ---

Couldn't open , trying /root/.config/srsran/enb.conf
Reading configuration file /root/.config/srsran/enb.conf...
Couldn't open sib.conf, trying /root/.config/srsran/sib.conf
Couldn't open rr.conf, trying /root/.config/srsran/rr.conf
Couldn't open rb.conf, trying /root/.config/srsran/rb.conf

Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.

/home/srsran1/oaic/srsRAN-e2/srsenb/src/enb_cfg_parser.cc:1216: Force DL EARFCN for cell PCI=1 to 100
2024-09-25T15:05:49.933038 [ENB    ] [I] Using binary srsenb with arguments: --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=10.0.2.15 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006 
2024-09-25T15:05:49.972367 [ENB    ] [I] Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.
2024-09-25T15:05:49.972995 [ENB    ] [I] Using sync queue size of one for ZMQ based radio.
bind(): Cannot assign requested address
Failed to initiate S1 connection. Attempting reconnection in 10 seconds
bind(): Cannot assign requested address
2024-09-25T15:05:50.045264 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T15:05:50.045267 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T15:05:50.045288 [COMN   ] [E] [    0] Failed to bind on address 10.0.2.15: Cannot assign requested address errno 99
2024-09-25T15:05:50.045334 [COMN   ] [W] [    0] RxSockets: The socket fd=-1 to be removed does not exist
2024-09-25T15:05:50.045345 [COMN   ] [E] [    0] Failed to bind on address 10.0.2.15: Cannot assign requested address errno 99
Failed to bind on address 10.0.2.15, port 2152: Cannot assign requested address
Error initializing EUTRA stack.
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
2024-09-25T15:05:50.215176 [RIC    ] [D] [    0] log_level = debug

2024-09-25T15:05:50.215180 [E2SM   ] [I] [    0] kpm: building function list

2024-09-25T15:05:50.217704 [RIC    ] [I] [    0] added model ORAN-E2SM-KPM

2024-09-25T15:05:50.217726 [RIC    ] [I] [    0] added model ORAN-E2SM-gNB-NRT

2024-09-25T15:05:50.217728 [RIC    ] [D] [    0] model ORAN-E2SM-KPM function ORAN-E2SM-KPM (function_id 0) enabled and registered

2024-09-25T15:05:50.217728 [RIC    ] [D] [    0] model ORAN-E2SM-gNB-NRT function ORAN-E2SM-gNB-NRT (function_id 1) enabled and registered

2024-09-25T15:05:50.217729 [RIC    ] [D] [    0] RIC state -> INITIALIZED

2024-09-25T15:05:50.222705 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T15:05:50.222713 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T15:05:50.222746 [COMN   ] [D] [    0] Successfully bound to address 10.0.2.101:5006
connect(): Connection refused
2024-09-25T15:05:50.224055 [COMN   ] [I] [    0] Failed to establish socket connection to 10.0.2.15
2024-09-25T15:05:50.224100 [RIC    ] [E] [    0] failed to connect to 10.0.2.15
2024-09-25T15:05:50.224153 [RIC    ] [I] [    0] resetting agent connection (reconnect enabled)

2024-09-25T15:05:50.224154 [RIC    ] [I] [    0] pushing connection_reset (1)

2024-09-25T15:05:50.224155 [RIC    ] [I] [    0] pushed connection_reset (2)

2024-09-25T15:05:50.224158 [RIC    ] [I] [    0] stopping agent

2024-09-25T15:05:50.224206 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T15:05:50.224360 [COMN   ] [D] [    0] RxSockets: closed.
2024-09-25T15:05:50.225033 [RIC    ] [D] [    0] RIC state -> INITIALIZED

2024-09-25T15:05:50.225034 [RIC    ] [I] [    0] exiting agent thread

Saving MAC PCAP (DLT=149) to enb_mac_nr.pcap
Saving MAC PCAP (DLT=149) to /tmp/enb.pcap
2024-09-25T15:05:52.244742 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T15:05:52.245376 [COMN   ] [D] [    0] RxSockets: closed.
srsRAN crashed... backtrace saved in './srsRAN.backtrace.crash'...
---  exiting  ---
srsran1@srsRAN1:~/oaic/srsRAN-e2/srsenb$ cat ./srsRAN.backtrace.crash 
--- command='srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=10.0.2.15 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006' version=21.10.0 signal=11 date='25/09/2024 15:05:52' ---
	srsenb(+0x335d32) [0x55d571896d32]
	/lib/x86_64-linux-gnu/libc.so.6(+0x43090) [0x7fd8f9820090]
	/lib/x86_64-linux-gnu/libpthread.so.0(+0x9aab) [0x7fd8fa1b5aab]
	srsenb(+0x29790c) [0x55d5717f890c]
	srsenb(+0x299209) [0x55d5717fa209]
	srsenb(+0x299e0d) [0x55d5717fae0d]
	srsenb(+0xfcb87) [0x55d57165db87]
	srsenb(+0xfcc9d) [0x55d57165dc9d]
	srsenb(+0xdf1f5) [0x55d5716401f5]
	/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf3) [0x7fd8f9801083]
	srsenb(_start+0x2e) [0x55d571641f6e]

# eNB Configuration File

# General settings
enb.name = enb1
enb.enb_id = 0x19B
enb.n_prb = 50

# RF settings
rf.device_name = zmq
rf.device_args = "fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6"

# RIC Agent settings
ric.agent.local_ipv4_addr = 10.0.2.101       # Replace with VM2's IP
ric.agent.local_port = 5006
ric.agent.remote_ipv4_addr = 10.0.2.15       # Replace with VM1's IP
ric.agent.remote_port = 32321                  # RIC's port on VM1

# Logging settings
log.all_level = warn
log.level = debug
log.filename = stdout

# Uncomment if you have specific S1 settings
# s1.mme_ipv4_addr = <MME_IP>
# s1.mme_port = 36412

# Optional parameters (commented out)
# enb.ue_max = 50
# enb.ciphering_algorithm = 0x00
# enb.security_algorithm = 0x00

# Uncomment below to enable additional logging
# log.filename = /var/log/srsran/enb.log

srsran1@srsRAN1:~/oaic/srsRAN-e2/srsenb$ sudo srsenb
---  Software Radio Systems LTE eNodeB  ---

Couldn't open , trying /root/.config/srsran/enb.conf
Reading configuration file /root/.config/srsran/enb.conf...
Couldn't open sib.conf, trying /root/.config/srsran/sib.conf
Couldn't open rr.conf, trying /root/.config/srsran/rr.conf
Couldn't open rb.conf, trying /root/.config/srsran/rb.conf

Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.

2024-09-25T15:14:57.763485 [ENB    ] [I] Using binary srsenb with arguments: 
2024-09-25T15:14:57.804620 [ENB    ] [I] Built in RelWithDebInfo mode using commit 384d343 on branch HEAD.
2024-09-25T15:14:57.805273 [ENB    ] [I] Using sync queue size of one for ZMQ based radio.
bind(): Cannot assign requested address
Failed to initiate S1 connection. Attempting reconnection in 10 seconds
bind(): Cannot assign requested address
Failed to bind on address 192.168.3.1, port 2152: Cannot assign requested address
Error initializing EUTRA stack.
2024-09-25T15:14:57.874702 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T15:14:57.874704 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T15:14:57.874725 [COMN   ] [E] [    0] Failed to bind on address 192.168.3.1: Cannot assign requested address errno 99
2024-09-25T15:14:57.874785 [COMN   ] [W] [    0] RxSockets: The socket fd=-1 to be removed does not exist
2024-09-25T15:14:57.874795 [COMN   ] [E] [    0] Failed to bind on address 192.168.3.1: Cannot assign requested address errno 99
Opening 2 channels in RF device=zmq with args="fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6"
Available RF device list: UHD  zmq 
CHx base_srate=23.04e6"
CHx id=enb
Current sample rate is 1.92 MHz with a base rate of 23.04 MHz (x12 decimation)
CH0 rx_port=tcp://localhost:2001
CH0 tx_port=tcp://*:2000
CH0 fail_on_disconnect=true
CH1 rx_port=tcp://localhost:2101
CH1 tx_port=tcp://*:2100
2024-09-25T15:14:58.045875 [COMN   ] [D] [    0] Setting RTO_INFO options on SCTP socket. Association 0, Initial RTO 3000, Minimum RTO 1000, Maximum RTO 6000
2024-09-25T15:14:58.045883 [COMN   ] [D] [    0] Setting SCTP_INITMSG options on SCTP socket. Max attempts 3, Max init attempts timeout 5000
2024-09-25T15:14:58.045917 [COMN   ] [D] [    0] Successfully bound to address 10.0.2.101:5006
connect(): Connection refused
2024-09-25T15:14:58.047247 [COMN   ] [I] [    0] Failed to establish socket connection to 10.0.2.15
2024-09-25T15:14:58.047709 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T15:14:58.047812 [COMN   ] [D] [    0] RxSockets: closed.
2024-09-25T15:15:02.105829 [COMN   ] [D] [    0] RxSockets: Closing rx socket handler thread
2024-09-25T15:15:02.106479 [COMN   ] [D] [    0] RxSockets: closed.
srsRAN crashed... backtrace saved in './srsRAN.backtrace.crash'...
---  exiting  ---
srsran1@srsRAN1:~/oaic/srsRAN-e2/srsenb$ cat ./sr
src/                    srsRAN.backtrace.crash  
srsran1@srsRAN1:~/oaic/srsRAN-e2/srsenb$ cat ./srsRAN.backtrace.crash 
--- command='srsenb --enb.n_prb=50 --enb.name=enb1 --enb.enb_id=0x19B --rf.device_name=zmq --rf.device_args=fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6 --ric.agent.remote_ipv4_addr=10.0.2.15 --log.all_level=warn --ric.agent.log_level=debug --log.filename=stdout --ric.agent.local_ipv4_addr=10.0.2.101 --ric.agent.local_port=5006' version=21.10.0 signal=11 date='25/09/2024 15:05:52' ---
	srsenb(+0x335d32) [0x55d571896d32]
	/lib/x86_64-linux-gnu/libc.so.6(+0x43090) [0x7fd8f9820090]
	/lib/x86_64-linux-gnu/libpthread.so.0(+0x9aab) [0x7fd8fa1b5aab]
	srsenb(+0x29790c) [0x55d5717f890c]
	srsenb(+0x299209) [0x55d5717fa209]
	srsenb(+0x299e0d) [0x55d5717fae0d]
	srsenb(+0xfcb87) [0x55d57165db87]
	srsenb(+0xfcc9d) [0x55d57165dc9d]
	srsenb(+0xdf1f5) [0x55d5716401f5]
	/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf3) [0x7fd8f9801083]
	srsenb(_start+0x2e) [0x55d571641f6e]

--- command='srsenb' version=21.10.0 signal=11 date='25/09/2024 15:15:02' ---
	srsenb(+0x335d32) [0x562318a1dd32]
	/lib/x86_64-linux-gnu/libc.so.6(+0x43090) [0x7f1bb6b2f090]
	/lib/x86_64-linux-gnu/libpthread.so.0(+0x9aab) [0x7f1bb74c4aab]
	srsenb(+0x29790c) [0x56231897f90c]
	srsenb(+0x299209) [0x562318981209]
	srsenb(+0x299e0d) [0x562318981e0d]
	srsenb(+0xfcb87) [0x5623187e4b87]
	srsenb(+0xfcc9d) [0x5623187e4c9d]
	srsenb(+0xdf1f5) [0x5623187c71f5]
	/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf3) [0x7f1bb6b10083]
	srsenb(_start+0x2e) [0x5623187c8f6e]
