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

# Downloading VirtualBox
echo -e "${BLUE}Downloading VirtualBox${NC}"
wget -O /tmp/virtualbox.deb "https://download.virtualbox.org/virtualbox/7.0.10/virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb"
handle_error $? "VirtualBox Download" "Failed to download VirtualBox"

# Installing VirtualBox
echo -e "${BLUE}Installing VirtualBox${NC}"
sudo apt install /tmp/virtualbox.deb
handle_error $? "VirtualBox Installation" "Failed to install VirtualBox"

echo -e "${GREEN}VirtualBox installation complete!${NC}"