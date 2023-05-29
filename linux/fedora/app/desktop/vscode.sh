#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Set Flatpak non-interactive mode
export FLATPAK_NO_INTERACTIVE=1

# Install Visual Studio Code via Flatpak
clear
echo -e "${BLUE}Installing Visual Studio Code...${NC}"
if ! flatpak install flathub com.visualstudio.code -y; then
    echo -e "${RED}Failed to install Visual Studio Code.${NC}"
    exit 1
fi

echo -e "${GREEN}Visual Studio Code installation complete!${NC}"
