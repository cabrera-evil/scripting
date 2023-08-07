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

# Add OBS Studio PPA
echo -e "${BLUE}Adding OBS Studio PPA...${NC}"
sudo add-apt-repository -y ppa:obsproject/obs-studio
handle_error $? "Adding OBS Studio PPA" "Failed to add OBS Studio PPA."

# Update package lists
echo -e "${BLUE}Updating package lists...${NC}"
sudo apt update
handle_error $? "Updating package lists" "Failed to update package lists."

# Install OBS Studio
echo -e "${BLUE}Installing OBS Studio...${NC}"
sudo apt install -y obs-studio
handle_error $? "Installing OBS Studio" "Failed to install OBS Studio."

echo -e "${GREEN}OBS Studio installation complete!${NC}"
