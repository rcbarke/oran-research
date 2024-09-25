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
#
# enb_id:               20-bit eNB identifier.
# mcc:                  Mobile Country Code
# mnc:                  Mobile Network Code
# mme_addr:             IP address of MME for S1 connection
# gtp_bind_addr:        Local IP address to bind for GTP connection
# gtp_advertise_addr:   IP address of eNB to advertise for DL GTP-U Traffic
# s1c_bind_addr:        Local IP address to bind for S1AP connection
# s1c_bind_port:        Source port for S1AP connection (0 means any)
# n_prb:                Number of Physical Resource Blocks (6,15,25,50,75,100)
# tm:                   Transmission mode 1-4 (TM1 default)
# nof_ports:            Number of Tx ports (1 port default, set to 2 for TM2/3/4)
#
#####################################################################
[enb]
# Original configuration
# enb_id = 0x19B
# mcc = 001
# mnc = 01
# mme_addr = 127.0.1.100
# gtp_bind_addr = 127.0.1.1
# s1c_bind_addr = 127.0.1.1
# s1c_bind_port = 0
# n_prb = 50
# tm = 4
# nof_ports = 2

# Updated configuration
enb_id = 0x19B
mcc = 001
mnc = 01
mme_addr = 10.0.2.15   # Updated to your actual MME IP
gtp_bind_addr = 10.0.2.15   # Updated to match your setup
s1c_bind_addr = 10.0.2.15   # Updated to match your setup
s1c_bind_port = 0
n_prb = 50
tm = 1   # Example: Changed transmission mode to 1
nof_ports = 1   # Example: Kept it as 1

#####################################################################
# eNB configuration files
#
# sib_config:  SIB1, SIB2 and SIB3 configuration file 
# note: When enabling MBMS, use the sib.conf.mbsfn configuration file which includes SIB13
# rr_config:   Radio Resources configuration file 
# rb_config:   SRB/DRB configuration file 
#####################################################################
[enb_files]
sib_config = sib.conf
rr_config  = rr.conf
rb_config = rb.conf

#####################################################################
# RF configuration
#
# dl_earfcn: EARFCN code for DL (only valid if a single cell is configured in rr.conf)
# tx_gain: Transmit gain (dB).
# rx_gain: Optional receive gain (dB). If disabled, AGC if enabled
#
# Optional parameters:
# dl_freq:            Override DL frequency corresponding to dl_earfcn
# ul_freq:            Override UL frequency corresponding to dl_earfcn (must be set if dl_freq is set)
# device_name:        Device driver family
#                     Supported options: "auto" (uses first driver found), "UHD", "bladeRF", "soapy", "zmq" or "Sidekiq"
# device_args:        Arguments for the device driver. Options are "auto" or any string.
#                     Default for UHD: "recv_frame_size=9232,send_frame_size=9232"
#                     Default for bladeRF: ""
# time_adv_nsamples:  Transmission time advance (in number of samples) to compensate for RF delay
#                     from antenna to timestamp insertion.
#                     Default "auto". B210 USRP: 100 samples, bladeRF: 27
#####################################################################
[rf]
# Original configuration
# dl_earfcn = 3350
tx_gain = 80
rx_gain = 40

# device_name = auto

# For best performance in 2x2 MIMO and >= 15 MHz use the following device_args settings:
#     USRP B210: num_recv_frames=64,num_send_frames=64
#     And for 75 PRBs, also append ",master_clock_rate=15.36e6" to the device args

# For best performance when BW<5 MHz (25 PRB), use the following device_args settings:
#     USRP B210: send_frame_size=512,recv_frame_size=512

# device_args = auto
# time_adv_nsamples = auto

# Example for ZMQ-based operation with TCP transport for I/Q samples
device_name = zmq
device_args = fail_on_disconnect=true,tx_port0=tcp://*:2000,rx_port0=tcp://localhost:2001,tx_port1=tcp://*:2100,rx_port1=tcp://localhost:2101,id=enb,base_srate=23.04e6

#####################################################################
# Packet capture configuration
#
# MAC-layer packets are captured to a file in the compact format which can
# be decoded by Wireshark. For decoding, use the UDP dissector and the UDP 
# heuristic dissection. Edit the preferences (Edit > Preferences > 
# Protocols > DLT_USER) for DLT_USER to add an entry for DLT=149 with 
# Protocol=udp. Further, enable the heuristic dissection in UDP under:
# Analyze > Enabled Protocols > MAC-LTE > mac_lte_udp and MAC-NR > mac_nr_udp
# For more information see: https://wiki.wireshark.org/MAC-LTE
# Configuring this Wireshark preferences is needed for decoding the MAC PCAP
# files as well as for the live network capture option.
#
# Please note that this setting will by default only capture MAC
# frames on dedicated channels, and not SIB.  You have to build with
# WRITE_SIB_PCAP enabled in srsenb/src/stack/mac/mac.cc if you want
# SIB to be part of the MAC pcap file.
#
# S1AP Packets are captured to a file in the compact format which can
# be decoded by the Wireshark s1ap dissector with DLT 150. 
# To use the dissector, edit the preferences for DLT_USER to 
# add an entry with DLT=150, Payload Protocol=s1ap.
#
# mac_enable:   Enable MAC layer packet captures (true/false)
# mac_filename: File path to use for packet captures
# s1ap_enable:   Enable or disable the PCAP.
# s1ap_filename: File name where to save the PCAP.
#
# mac_net_enable: Enable MAC layer packet captures sent over the network (true/false default: false)
# bind_ip: Bind IP address for MAC network trace (default: "0.0.0.0")
# bind_port: Bind port for MAC network trace (default: 5687)
# client_ip: Client IP address for MAC network trace (default: "127.0.0.1")
# client_port Client IP address for MAC network trace (default: 5847)
#####################################################################
[pcap]
enable = false
filename = /tmp/enb.pcap
s1ap_enable = false
s1ap_filename = /tmp/enb_s1ap.pcap

mac_net_enable = false
bind_ip = 0.0.0.0
bind_port = 5687
client_ip = 127.0.0.1
client_port = 5847

#####################################################################
# Log configuration
#
# Log levels can be set for individual layers. "all_level" sets log
# level for all layers unless otherwise configured.
# Format: e.g. phy_level = info
#
# In the same way, packet hex dumps can be limited for each level.
# "all_hex_limit" sets the hex limit for all layers unless otherwise configured.
# Format: e.g. phy_hex_limit = 32
#
# Logging layers: rf, phy, phy_lib, mac, rlc, pdcp, rrc, gtpu, s1ap, stack, all
# Logging levels: debug, info, warning, error, none
#
# filename: File path to use for log output. Can be set to stdout
#           to print logs to standard output
# file_max_size: Maximum file size (in kilobytes). When passed, multiple files are created.
#                If set to negative, a single log file will be created.
#####################################################################
[log]
all_level = warning
all_hex_limit = 32
filename = /tmp/enb.log
file_max_size = -1

[gui]
enable = false

#####################################################################
# Scheduler configuration options
#
# sched_policy:      User MAC scheduling policy (E.g. time_rr, time_pf)
# min_aggr_level:    Optional minimum aggregation level index (l=log2(L) can be 0, 1, 2 or 3)
# max_aggr_level:    Optional maximum aggregation level index (l=log2(L) can be 0, 1, 2 or 3)
# adaptive_aggr_level: Boolean flag to enable/disable adaptive aggregation level based on target BLER
# pdsch_mcs:         Optional fixed PDSCH MCS (ignoring target BLER)
#
#####################################################################
[scheduler]
sched_policy = time_rr
min_aggr_level = 0
max_aggr_level = 2
adaptive_aggr_level = true
pdsch_mcs = 0
