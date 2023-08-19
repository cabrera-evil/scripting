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

# Install Firefox via Flatpak
echo -e "${BLUE}Installing Firefox...${NC}"
flatpak install -y flathub org.mozilla.firefox
handle_error $? "Failed to install Firefox."

# Remove Firefox ESR if installed
if [ -f /usr/bin/firefox-esr ]; then
    echo -e "${YELLOW}Removing Firefox ESR...${NC}"
    sudo apt purge --remove -y firefox-esr
    handle_error $? "Failed to remove Firefox ESR."
fi

echo -e "${GREEN}Firefox installation complete!${NC}"
