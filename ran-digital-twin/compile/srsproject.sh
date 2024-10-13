#!/bin/bash
#
# srs_project.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Clones and builds srsRAN project via CLI.
#

# Function to build the srsProject repo with ZEROMQ Enabled
build_srsran_project() {
    echo "srsRAN Project build initiated..."
    
    # Check if the oran-sc-ric directory exists, and if so, skip cloning
    if [ -d "./srsRAN_Project" ]; then
        echo "srsRAN Project directory already exists. Skipping clone."
        cd srsRAN_Project/build
    else
        # Clone the repository
        echo "Cloning srsRAN_Project..."
        git clone https://github.com/srsRAN/srsRAN_Project.git
        cd srsRAN_Project
        mkdir build
        cd build
    fi
    
    # Compile and build srsRAN_Project with ZeroMQ
    cmake ../ -DENABLE_EXPORT=ON -DENABLE_ZEROMQ=ON
    make -j`nproc`
    cd ../../
}

build_srsran_project
