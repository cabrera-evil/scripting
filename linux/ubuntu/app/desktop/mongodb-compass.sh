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

# If Flatpak is not installed, install it
if ! [ -x "$(command -v flatpak)" ]; then
    echo -e "${BLUE}Installing Flatpak...${NC}"
    sudo apt install flatpak -y
    handle_error $? "sudo apt install" "Failed to install Flatpak."
fi

# Install MongoDB Compass via Flatpak
echo -e "${BLUE}Installing MongoDB Compass...${NC}"
flatpak install flathub com.mongodb.Compass -y
handle_error $? "flatpak install" "Failed to install MongoDB Compass."

echo -e "${GREEN}MongoDB Compass installation complete!${NC}"