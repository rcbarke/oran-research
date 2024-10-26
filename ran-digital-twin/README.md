# RAN Digital Twin Simulation

## Overview

This repository contains scripts and configurations for building a RAN (Radio Access Network) Digital Twin simulation. The simulation architecture includes a 5G core network, an RIC (RAN Intelligent Controller), disaggregated gNB (CU/DU), and multiple dedicated UE instances. The entire setup is designed to be modular, allowing customization and deployment in different modes (Core, Edge, etc.).

**This Digital Twin is designed to run over one or more VirtualBox VMs. IP override functionality will need to be leveraged if installed locally. Virtualization is strongly recommended to avoid configuration conflicts.**

### Prerequisites

- **Operating System**: Ubuntu 22.04.1

The build scripts will automatically install and configure all necessary dependencies. Ensure you are running the correct version of Ubuntu to avoid compatibility issues.

### Key Components

- **Open5GS 5GC Core**: Core Network components such as MME/AMF/SGW/PGW.
- **OSC RIC**: Modified Open Source RAN Intelligent Controller supporting machine virtualization.
- **srsRAN gNB**: Disaggregated CU/DU for the gNB.
- **srsUE**: Multiple instances of dedicated UE using srsRAN.
- **GNU Radio**: Modulation and RF signal processing for the UEs.

## Directory Structure

```plaintext
├── compile/                            # Compilation scripts for building various components
│   ├── open5gs.sh                      # Builds and configures Open5GS 5G Core
│   ├── osc-ric.sh                      # Builds and configures OSC RIC on a class-C subnet
│   ├── srs4G.sh                        # Builds and installs srsRAN 4G UE
│   ├── srs_project.sh                  # Builds and installs srsRAN project
│   ├── srsgnb.sh                       # Builds srsRAN gNB config: Currently supports single gNB @ Core
|   ├── srsue.sh                        # Builds srsUE configs and synchronizes with Open5GS database
|   ├── gnuradio.sh                     # Builds and configures gnuradio
|   └── generate_multi_ue_py.sh         # Builds dynamic gnuradio python files
├── configs/                            # Configuration files for RAN and UE components
├── oran-sc-ric/                        # Source files and builds for OSC RIC (added after build)
├── srsRAN_4G/                          # Source files and builds for srsRAN 4G UE (added after build)
├── srsRAN_Project/                     # Source files and builds for srsRAN project (added after build)
├── build-digital-twin.sh               # Main script to build and stage the digital twin
├── deploy-digital-twin.sh              # Script to deploy the digital twin
├── monitoring-xApps.sh                 # Script to monitor KPIMon and Grafana xApps
├── destroy-digital-twin.sh             # Script to destroy and clean up the digital twin
└── README.md                           # Documentation for the project
```

## Scripts

### `build-digital-twin.sh`
The primary script for building the entire RAN Digital Twin environment. This script automates the deployment of the RAN architecture, including the core network, RIC, gNB, and UE instances.

#### Usage

```bash
./build-digital-twin.sh [options]
```
### Options:

- `-mode [core|edge]`: Specify the mode of the RAN network (default: core).
- `-hostip <ip_address>`: Override the default static IP for the host machine (default: disabled).
- `-int <interface>`: Specify the network interface to configure the static IP (default: 10.0.2.15).
- `-srsP [T|F]`: Enable/Disable building the srsRAN Project package (default T).
- `-srs4G [T|F]`: Enable/Disable building the srs4G package (default: T).
- `-ue <num>`: Specify the total number of UEs to build (default: 3).
- `-ue_local <num>`: Specify the number of UEs to build on this machine (default: matches -ue).
- `-ue_idx <index>`: Specify the starting index of UEs for this machine (default: 1).

---

### `deploy-digital-twin.sh`
The deployment script for the RAN Digital Twin simulation. This script launches Open5GS, OSC RIC, srsGNB, and multiple UEs, with RF signal modulation managed through GNU Radio.

#### Usage

```bash
./deploy-digital-twin.sh [-b] <NUM_UES>
```
- `-b`: Runs the `build-digital-twin.sh` script before deploying the environment.
- `-xm`: Automatically starts the monitoring xApps (KPIMon and Grafana) without requiring user confirmation. Without this flag, the script will ask.
- `-NUM_UES`: Specify the number of UEs to deploy (required, must be a whole number).

#### Example

```bash
./deploy-digital-twin.sh -b 3
```
#### Notes:

- Make sure to run the deploy script from the project root directory.
- Use `gnome-terminal` to ensure correct tab handling for different processes.

---

### `monitoring-xApps.sh`
This script opens two gnome-terminal windows to monitor KPIMon and Grafana in real-time during the RAN Digital Twin simulation. KPIMon monitors UE throughput metrics, while Grafana provides a graphical interface for gNB performance monitoring.

#### Usage

```bash
./monitoring-xApps.sh
```

#### Example

```bash
./monitoring-xApps.sh
```
#### Notes:

- The script opens KPIMon in one terminal window and Grafana in another.
- After a 10-second delay, `Firefox` is launched automatically to display the - -Grafana dashboard at `http://localhost:3300`. Note the Grafana terminal needs sudo authentication.

---

### `destroy-digital-twin.sh`
This script removes all resources created by the build and deploy scripts, including Docker containers, network namespaces, and project directories.
- **Confirmation Required**: The script will prompt you for confirmation before performing the cleanup as the operation is destructive.

#### Cleaned Components:

1. **Docker Containers**: Removes all containers created by Open5GS, OSC RIC, and other components.
2. **Docker Networks**: Cleans up non-default Docker networks created during deployment.
3. **Network Namespaces**: Deletes UE namespaces (namespaces starting with ue).
4. **Project Directories**: Removes srsRAN_Project, srsRAN_4G, and oran-sc-ric directories.

---

### compile/open5gs.sh

Script to build and configure the Open5GS 5GC Core (MME/AMF/SGW/PGW).

---

### compile/osc-ric.sh

Script to build and configure the OSC RIC, supporting machine virtualization and performance monitoring.

---

### compile/srs4G.sh

Script to build and configure the srsRAN 4G package. This is needed to obtain the srsUE binary.

---

### compile/srs_project.sh

Script to build the srsRAN Project package, which includes various components such as the gNB (CU/DU).

---

### compile/srsgnb.sh

Script to build the disaggregated CU/DU for the srsRAN gNB. Also configures the gNB to connect to the E2 link on the modified RIC subnet.

---

### srsue.sh

This script generates multiple UE configuration files (`ue*_zmq.conf`) based on the number of UEs and the starting index provided as arguments. It retrieves USIM data (IMSI, Key, OP/OPc) from the `subscriber_db.csv` file and updates the configuration for each UE.
This script is automatically called during built. It can be called outside of build to generate additional UEs, but be wary that any UE not contained within the `subscriber_db.csv` file will not be able to subscribe to the network!

---

### Usage
```bash
./srsue.sh <NUM_UES> <START_INDEX>
./srsue.sh 3 1
./srsue.sh 3 3
./srsue.sh 6 3
./srsue.sh 10 1
./srsue.sh 10 10
```
Examples:
- Build 3 UEs, UE1 through UE3
- Build 3 UEs, UE4 through UE6
- Build 6 UEs, UE4 through UE9
- Build 10 UEs, UE1 through UE10
- Build 10 UEs, UE11 through UE20

---

### gnuradio.sh

This script installs gnuradio, calls `./generate_multi_ue_grc.sh <NUM_UEs>` to dynamically build modulation for the number of UEs passed in, and stages the completed `multi_ue_scenario.grc` file.

---

### generate_multi_ue_py.sh

This script generates the config file for gnuradio modulation for a dynamic amount of passed in UEs. The generated script allows for pathloss and prb allocation per UE to be changed by writing to ue_config.json while the script is running. 

---

### Usage
```bash
./generate_multi_ue_py.sh 30
```

This will generate .grc file for 30 UEs, modulating their RF signal processing dynamically.

### Configuration Files (`configs/`)

Staged to `./srsRAN_Project/docker/open5gs` with `./open5gs.env`:
- **`subscriber_db.csv`**: Contains the subscriber information such as IMSI, Key, and OPC values. The script will ensure that values generated for each unique UE index do not overlap, even across VMs.

Staged to `./srsRAN_Project/build/apps/gnb` with `./gnb` executable:
- **`gnb_zmq.yaml`**: A template configuration file used to generate gnb configuration files. Synchronized with modified RIC configuration.

Staged to `./srsRAN_4G/build/srsue/src` with  `./srsue` executable:
- **`ue_template_zmq.conf`**: A template configuration file used to generate UE-specific configuration files, which are staged. Template not staged.

The **`srsue.sh`**: script will create individual configuration files for each UE (ueX_zmq.conf) based on this template and the data from subscriber_db.csv.

- **`multi_ue_scenario.grc`**: Configuration file for gnuradio to modulate all UEs. Start gnuradio from `./srsRAN_4G/build/srsue/src` with:

`gnuradio-companion ./multi_ue_scenario.grc`

## Build Process

1. **Clone and build**: After cloning the repository, run the `build-digital-twin.sh` script to build the RAN Digital Twin environment. This script will install all required components and generate the necessary configuration files for the core network, RIC, gNB, and UE instances.

```bash
./build-digital-twin.sh [options]
```

After running the build script, the following directories will be created and populated with source files and build outputs:

  - `oran-sc-ric/`: Contains the OSC RIC build.
  - `srsRAN_4G/`: Contains the build and binaries for the srs4G UE.
  - `srsRAN_Project/`: Contains the build and binaries for the srsRAN project.

2. **Deploy the simulation:** Once the build process is complete, use the `deploy-digital-twin.sh` script to deploy the entire RAN Digital Twin architecture, including the Open5GS core, OSC RIC, gNB, and UEs.

```bash
./deploy-digital-twin.sh [-b] <NUM_UES>
```

- The -b option can be used to rebuild the environment before deploying, ensuring everything is up to date.
- The NUM_UES argument specifies the number of UEs to deploy.

3. **Deploy Monitoring xApps:** After deploying the RAN architecture, you can either launch the monitoring xApps (KPIMon and Grafana) manually or use the `-xm flag` in the `deploy-digital-twin.sh` script to automatically start them without prompting. Alternatively, you can manually launch the monitoring xApps using the `monitoring-xApps.sh` script.

```bash
./monitoring-xApps.sh
```

- This script will open two separate gnome terminals: one for KPIMon (monitoring UE throughput) and one for Grafana (graphical monitoring via a web interface). Grafana will also automatically launch in a browser window at `http://localhost:3300`.

4. **Run the simulation**: Once everything is deployed, the simulation is fully operational. You can interact with the UEs and gNB, monitor performance metrics, and simulate traffic across the RAN using tools like `iperf`.

```bash
sudo ip netns exec ue1 ping -i 0.1 10.45.1.1 # Checks connectivity
sudo ip netns exec ue1 iperf -c 10.45.1.1 -u -b 10M -i 1 -t 60 # Simulates UL traffic from UE to gNB
```

---

## Future Enhancements

- Add support for edge RAN deployments: Hosting UEs from a separate VM for processing offload
- Add E2SM node to SRSRAN to further enhance RAN CU-CP optimization commands
- Integration with additional xApps for enhanced performance monitoring and network optimization

## References

The [srsProject Documentation](https://docs.srsran.com/projects/project/en/latest/tutorials/source/near-rt-ric/source/index.html) was leveraged as a starting point for this repository, which is an orchestration framework for combining several GNU, OSC, and SRS containers and automating their configuration.

## Contact

For further assistance, feel free to contact the **Clemson University IS-WiN Laboratory ORAN team** led by Tolunay Sefyi, Ryan Barker, and Basir Ebrahimi.
