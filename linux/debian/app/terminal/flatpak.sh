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

# Installing flatpak
echo -e "${BLUE}Installing flatpak${NC}"
sudo apt install flatpak -y
handle_error $? "sudo apt install flatpak" "flatpak installed successfully" "Error installing flatpak"

# Install flatpak plugin for gnome software
echo -e "${BLUE}Installing flatpak plugin for gnome software${NC}"
sudo apt install gnome-software-plugin-flatpak -y
handle_error $? "sudo apt install gnome-software-plugin-flatpak" "flatpak plugin for gnome software installed successfully" "Error installing flatpak plugin for gnome software"

# Install flatpak plugin for kde discover
echo -e "${BLUE}Installing flatpak plugin for kde discover${NC}"
sudo apt install plasma-discover-flatpak-backend -y
handle_error $? "sudo apt install plasma-discover-flatpak-backend" "flatpak plugin for kde discover installed successfully" "Error installing flatpak plugin for kde discover"

# Add flathub repository
echo -e "${BLUE}Adding flathub repository${NC}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
handle_error $? "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo" "Flathub repository added successfully" "Error adding flathub repository"
