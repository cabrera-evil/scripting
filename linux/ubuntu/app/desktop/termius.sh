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

# Install Termius
echo -e "${BLUE}Downloading Termius...${NC}"
wget -O /tmp/termius.deb "https://www.termius.com/download/linux/Termius.deb?_gl=1*i4xdht*_ga*MzQ0ODY0MDczLjE2MTY2MjI5ODE.*_ga_ZPQLW2Q816*MTY1NjM4MDU2Mi44My4xLjE2NTYzODIyNzguMA.."
handle_error $? "Downloading Termius." "Failed to download Termius."

echo -e "${BLUE}Installing Termius...${NC}"
sudo apt install /tmp/termius.deb
handle_error $? "Termius installation complete!" "Failed to install Termius."

echo -e "${GREEN}Termius installation complete!${NC}"
