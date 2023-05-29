#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Set Flatpak non-interactive mode
export FLATPAK_NO_INTERACTIVE=1

# Install OBS Studio via Flatpak
clear
echo -e "${BLUE}Installing OBS Studio...${NC}"
if ! flatpak install --noninteractive flathub com.obsproject.Studio; then
    echo -e "${RED}Failed to install OBS Studio.${NC}"
    exit 1
fi

echo -e "${GREEN}OBS Studio installation complete!${NC}"
