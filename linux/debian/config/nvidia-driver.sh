#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Error handling function
handle_error() {
    local exit_code=$1
    local command=$2
    local success_message=$3
    local error_message=$4

    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}$success_message${NC}"
    else
        echo -e "${RED}$error_message${NC}"
        exit $exit_code
    fi
}

# Creating folder for NVIDIA drivers
echo -e "${BLUE}Creating folder for NVIDIA drivers...${NC}"
sudo mkdir -p ~/.drivers/nvidia
cd ~/.drivers/nvidia
handle_error $? "sudo mkdir -p .drivers/nvidia" "Folder for NVIDIA drivers created successfully!" "Failed to create folder for NVIDIA drivers."

# Install NVIDIA drivers
echo -e "${BLUE}Installing NVIDIA drivers...${NC}"
sudo apt install nvidia-kernel-common nvidia-kernel-dkms nvidia-xconfig nvidia-settings nvidia-detect nvidia-smi nvidia-support -y
handle_error $? "sudo apt install nvidia-kernel-common nvidia-kernel-dkms nvidia-xconfig nvidia-settings nvidia-detect nvidia-smi nvidia-support -y" "NVIDIA drivers installed successfully!" "Failed to install NVIDIA drivers."