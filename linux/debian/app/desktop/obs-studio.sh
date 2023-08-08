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

# Install OBS Studio via Flatpak
echo -e "${BLUE}Installing OBS Studio...${NC}"
flatpak install flathub com.obsproject.Studio -y
handle_error $? "flatpak install" "Failed to install OBS Studio."

echo -e "${GREEN}OBS Studio installation complete!${NC}"
