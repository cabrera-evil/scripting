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

# Check if Snap is already installed
if [ -x "$(command -v snap)" ]; then
    echo -e "${YELLOW}Snap is already installed.${NC}"
else
    # Install Snap
    echo -e "${BLUE}Installing Snap...${NC}"
    sudo dnf install -y snapd
    handle_error $? "Failed to install Snap."

    # Enable and start Snapd socket
    echo -e "${BLUE}Enabling and starting Snapd socket...${NC}"
    sudo systemctl enable --now snapd.socket
    handle_error $? "Failed to enable Snapd socket."
fi

# Install Termius via Snap
echo -e "${BLUE}Installing Termius via Snap...${NC}"
sudo snap install termius-app
handle_error $? "Failed to install Termius."

echo -e "${GREEN}Termius installation completed successfully.${NC}"
