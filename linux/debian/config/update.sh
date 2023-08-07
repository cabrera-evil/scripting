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
sudo apt update -y
handle_error $? "apt-get update" "Failed to update system"

# Upgrading packages
echo -e "${BLUE}Upgrading Packages${NC}"
sudo apt upgrade -y
handle_error $? "apt-get upgrade" "Failed to upgrade packages"

# Dist-upgrade
echo -e "${BLUE}Dist-Upgrade${NC}"
sudo apt dist-upgrade -y
handle_error $? "apt-get dist-upgrade" "Failed to perform dist-upgrade"

# Full-upgrade
echo -e "${BLUE}Full-Upgrade${NC}"
sudo apt full-upgrade -y
handle_error $? "apt-get full-upgrade" "Failed to perform full-upgrade"

# Autoremove packages
echo -e "${BLUE}Autoremove Packages${NC}"
sudo apt autoremove -y
handle_error $? "apt autoremove" "Failed to autoremove packages"

# Autoclean packages
echo -e "${BLUE}Autoclean Packages${NC}"
sudo apt autoclean -y
handle_error $? "apt autoclean" "Failed to autoclean packages"

# Fixing broken packages
echo -e "${BLUE}Fixing Broken Packages${NC}"
sudo apt --fix-broken install -y
handle_error $? "apt --fix-broken install" "Failed to fix broken packages"

echo -e "${GREEN}System updates and package management completed successfully!${NC}"
