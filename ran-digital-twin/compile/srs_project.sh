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
    
    # Check if the srsRAN_Project directory exists and if it's not empty
    if [ -d "./srsRAN_Project" ] && [ "$(ls -A ./srsRAN_Project)" ]; then
        echo "srsRAN Project directory already exists and is not empty. Skipping clone."
        cd srsRAN_Project/build
    else
        # If the directory does not exist or is empty, proceed with cloning
        if [ -d "./srsRAN_Project" ]; then
            echo "srsRAN Project directory exists but is empty. Proceeding with clone."
            rm -rf ./srsRAN_Project  # Clean up the empty directory
        fi
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
