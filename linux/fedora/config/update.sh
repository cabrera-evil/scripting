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

# Updating system
echo -e "${BLUE}Updating System${NC}"
sudo dnf update -y
handle_error $? "dnf update" "Failed to update system."

# Upgrading packages
echo -e "${BLUE}Upgrading Packages${NC}"
sudo dnf upgrade -y
handle_error $? "dnf upgrade" "Failed to upgrade packages."

# Update flatpak packages
echo -e "${BLUE}Updating Flatpak Packages${NC}"
flatpak update -y
handle_error $? "flatpak update" "Failed to update flatpak packages."

# Clean package cache
echo -e "${BLUE}Cleaning Package Cache${NC}"
sudo dnf clean all
handle_error $? "dnf clean" "Failed to clean package cache."

# Fixing broken dependencies
echo -e "${BLUE}Fixing Broken Dependencies${NC}"
sudo dnf check -y
handle_error $? "dnf check" "Failed to fix broken dependencies."

# Remove unused packages
echo -e "${BLUE}Removing Unused Packages${NC}"
sudo dnf autoremove -y
handle_error $? "dnf autoremove" "Failed to remove unused packages."

echo -e "${GREEN}System maintenance complete.${NC}"
