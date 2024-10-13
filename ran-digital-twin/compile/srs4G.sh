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
    
    # Check if the srsRAN_4G directory exists and if it's not empty
    if [ -d "./srsRAN_4G" ] && [ "$(ls -A ./srsRAN_4G)" ]; then
        echo "srsRAN 4G directory already exists and is not empty. Skipping clone."
        cd srsRAN_4G/build
        cmake ../
    else
        # If the directory does not exist or is empty, proceed with cloning
        if [ -d "./srsRAN_4G" ]; then
            echo "srsRAN 4G directory exists but is empty. Proceeding with clone."
            rm -rf ./srsRAN_4G  # Clean up the empty directory
        fi
        echo "Cloning srsRAN_4G..."
        git clone https://github.com/srsRAN/srsRAN_4G.git
        cd srsRAN_4G
        mkdir build
        cd build
        
        # Compile and build srsRAN_4G
        cmake ../
        make 
        make test
        
        # Install srsRAN_4G
        sudo make install
        srsran_install_configs.sh user
    fi
}

build_srsran_4G
