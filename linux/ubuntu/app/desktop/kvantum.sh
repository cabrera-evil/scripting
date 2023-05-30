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
    local message=$3

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: $command failed - $message${NC}" >&2
        exit $exit_code
    fi
}

# Install Kvantum
echo -e "${BLUE}Installing Kvantum...${NC}"
sudo add-apt-repository ppa:papirus/papirus -y
handle_error $? "add-apt-repository" "Failed to add PPA repository"
sudo apt-get update
handle_error $? "apt-get update" "Failed to update package lists"
sudo apt-get install --install-recommends kvantum -y
handle_error $? "apt-get install" "Failed to install Kvantum"
echo -e "${GREEN}Kvantum installed.${NC}"
