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
        echo -e "${RED}Error: $command failed - $message${NC}"
        exit $exit_code
    fi
}

# Install Termius
echo -e "${BLUE}Downloading Termius...${NC}"
wget -O /tmp/termius.deb "https://www.termius.com/download/linux/Termius.deb?_gl=1*i4xdht*_ga*MzQ0ODY0MDczLjE2MTY2MjI5ODE.*_ga_ZPQLW2Q816*MTY1NjM4MDU2Mi44My4xLjE2NTYzODIyNzguMA.."
handle_error $? "wget -O /tmp/termius.deb" "Failed to download Termius."

echo -e "${BLUE}Installing Termius...${NC}"
sudo apt install -y /tmp/termius.deb
handle_error $? "sudo apt install -y /tmp/termius.deb" "Failed to install Termius."

echo -e "${GREEN}Termius installation complete!${NC}"
