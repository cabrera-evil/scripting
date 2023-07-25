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

# Check if KDE is already installed
if [ -x "$(command -v startkde)" ]; then
    echo "KDE is already installed."
    exit 0
fi

# Install KDE Workspaces
echo -e "${BLUE}Installing KDE Workspaces...${NC}"
sudo dnf -y group install "KDE Plasma Workspaces"
handle_error $? "KDE Workspaces Installation" "Failed to install KDE Workspaces."

echo -e "${GREEN}KDE installation completed successfully. Please reboot to start KDE.${NC}"