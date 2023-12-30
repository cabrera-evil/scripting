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

# Download touchegg
echo -e "${BLUE}Downloading touchegg...${NC}"
release_url="https://github.com/JoseExposito/touchegg/releases/download/2.0.17/touchegg_2.0.17_amd64.deb"
wget -O /tmp/touchegg.deb "$release_url"
handle_error $? "wget release_url -O /tmp/touchegg.deb" "Failed to download touchegg"

# Install touchegg
echo -e "${BLUE}Installing touchegg...${NC}"
sudo apt install /tmp/touchegg.deb -y
handle_error $? "apt install /tmp/touchegg.deb" "Failed to install touchegg"
