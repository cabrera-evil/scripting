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

# Download and install VMware Player
echo -e "${BLUE}Downloading VMware Player...${NC}"
wget -O /tmp/vmware.bundle "https://download3.vmware.com/software/WKST-PLAYER-1750/VMware-Player-Full-17.5.0-22583795.x86_64.bundle"
handle_error $? "wget" "VMware Player download failed"

# Install VMware Player
echo -e "${BLUE}Installing VMware Player...${NC}"
sudo chmod +x /tmp/vmware.bundle
sudo /tmp/vmware.bundle
handle_error $? "VMware Player installation" "VMware Player installation failed"

echo -e "${GREEN}VMware Player installation complete!${NC}"
