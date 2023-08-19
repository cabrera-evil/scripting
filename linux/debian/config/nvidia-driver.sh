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

# Install NVIDIA drivers
echo -e "${BLUE}Installing NVIDIA drivers...${NC}"
sudo apt install nvidia-driver -y
handle_error $? "sudo apt install nvidia-driver -y" "NVIDIA drivers installed successfully!" "Failed to install NVIDIA drivers."