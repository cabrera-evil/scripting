#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
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

# Install Google Android Studio via Flatpak
echo -e "${BLUE}Installing Google Android Studio...${NC}"
flatpak install flathub com.google.AndroidStudio -y
handle_error $? "flatpak install" "Failed to install Google Android Studio."

echo -e "${GREEN}Google Android Studio installation complete!${NC}"
