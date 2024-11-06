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
    
    # Check if the srsRAN_Project directory exists
    if [ -d "./srsRAN_Project" ]; then
        echo "srsRAN Project directory exists."

        # Check if the build directory exists and is not empty
        if [ -d "./srsRAN_Project/build" ] && [ "$(ls -A ./srsRAN_Project/build)" ]; then
            echo "Build directory already exists and is not empty. Skipping build."
        else
            echo "Build directory does not exist or is empty. Proceeding with build setup."
            cd srsRAN_Project
            [ ! -d "build" ] && mkdir build  # Create build directory if it doesn't exist
            cd build

            # Compile and build srsRAN_Project with ZeroMQ
            cmake ../ -DENABLE_EXPORT=ON -DENABLE_ZEROMQ=ON
            make -j"$(nproc)"
            cd ../../
        fi
    else
        # If the srsRAN_Project directory does not exist, proceed with cloning
        echo "Cloning srsRAN_Project..."
        git clone https://github.com/srsRAN/srsRAN_Project.git
        cd srsRAN_Project
        mkdir build
        cd build

        # Compile and build srsRAN_Project with ZeroMQ
        cmake ../ -DENABLE_EXPORT=ON -DENABLE_ZEROMQ=ON
        make -j"$(nproc)"
        cd ../../
    fi
    
    # Ensure Grafana default port is modified, even if the build is skipped
    echo "Checking and modifying Grafana default port if needed..."
    cd ./srsRAN_Project
    FILES_TO_UPDATE=$(git grep -l "3300:")
    if [ -n "$FILES_TO_UPDATE" ]; then  
        echo "$FILES_TO_UPDATE" | xargs sed -i "s/3300:/10300:/g"
        echo "Modified Grafana Port to 10300..."
    else
        echo "Grafana port already set to 10300 or no files to update."
    fi
    cd ..
}

build_srsran_project
