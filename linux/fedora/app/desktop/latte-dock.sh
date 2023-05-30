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

# Install Latte Dock
echo -e "${BLUE}Installing Latte Dock...${NC}"
sudo dnf install -y latte-dock
handle_error $? "sudo dnf install" "Failed to install Latte Dock."

echo -e "${GREEN}Latte Dock installation complete!${NC}"
