#!/bin/bash
#
# srs4G.sh
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: Clones and builds srsRAN 4G via CLI.
#

# Function to build the srsProject repo with ZEROMQ Enabled
build_srsran_4G() {
    echo "srsRAN 4G build initiated..."
    
    # Check if the srsRAN_4G directory exists
    if [ -d "./srsRAN_4G" ]; then
        echo "srsRAN 4G directory exists."
        
        # Check if the build directory exists and is not empty
        if [ -d "./srsRAN_4G/build" ] && [ "$(ls -A ./srsRAN_4G/build)" ]; then
            echo "Build directory already exists and is not empty. Skipping build."
            return
        else
            echo "Build directory does not exist or is empty. Proceeding with build setup."
            cd srsRAN_4G
            [ ! -d "build" ] && mkdir build  # Create build directory if it doesn't exist
            cd build
        fi
    else
        # If the srsRAN_4G directory does not exist, proceed with cloning
        echo "Cloning srsRAN_4G..."
        git clone https://github.com/srsRAN/srsRAN_4G.git
    
        # Implement random preamble timer
        python3 ./compile/modify_proc_ra_nr.py
        
        # Patch nas_5g network slicing bug      
        # See https://github.com/srsran/srsRAN_4G/pull/1214/commits/427f1550c4a049835177242fc26fbdd2180e4159  
        python3 ./compile/modify_nas_5g.py
        
        # Change directories
        cd srsRAN_4G
        mkdir build
        cd build
    fi
    
    # Compile and build srsRAN_4G
    cmake ../
    make -j$(nproc)
    make test
    
    # Install srsRAN_4G
    sudo make install
    srsran_install_configs.sh user
}

build_srsran_4G
