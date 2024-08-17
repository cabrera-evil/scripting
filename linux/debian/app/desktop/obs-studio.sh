#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# If Flatpak is not installed, install it
if ! [ -x "$(command -v flatpak)" ]; then
    # Installing flatpak
    echo -e "${BLUE}Installing flatpak${NC}"
    sudo apt install flatpak -y

    # Install flatpak plugin for gnome software
    echo -e "${BLUE}Installing flatpak plugin for gnome software${NC}"
    sudo apt install gnome-software-plugin-flatpak -y

    # Add flathub repository
    echo -e "${BLUE}Adding flathub repository${NC}"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install OBS Studio via Flatpak
echo -e "${BLUE}Installing OBS Studio...${NC}"
flatpak install flathub com.obsproject.Studio -y

echo -e "${GREEN}OBS Studio installation complete!${NC}"
