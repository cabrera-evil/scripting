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

# Install GNS3
echo -e "${BLUE}Installing GNS3...${NC}"
sudo add-apt-repository ppa:gns3/ppa -y
handle_error $? "Adding GNS3 PPA repository" "Failed to add GNS3 PPA repository"

sudo apt update
handle_error $? "Updating package lists" "Failed to update package lists"

sudo apt install gns3-gui gns3-server -y
handle_error $? "Installing GNS3 packages" "Failed to install GNS3 packages"

echo -e "${GREEN}GNS3 installed.${NC}"
