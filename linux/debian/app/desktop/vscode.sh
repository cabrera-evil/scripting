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

# Download Code
echo -e "${BLUE}Downloading Code...${NC}"
wget -O /tmp/code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
handle_error $? "wget -O /tmp/code.deb" "Failed to download Code"

# Install Code
echo -e "${BLUE}Installing Code...${NC}"
sudo apt install -y /tmp/code.deb
handle_error $? "sudo apt install -y /tmp/code.deb" "Failed to install Code"

echo -e "${GREEN}Code installation complete!${NC}"
