#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Set Flatpak non-interactive mode
export FLATPAK_NO_INTERACTIVE=1

# Install Google Android Studio via Flatpak
clear
echo -e "${BLUE}Installing Google Android Studio...${NC}"
if ! flatpak install flathub com.google.AndroidStudio -y; then
    echo -e "${RED}Failed to install Google Android Studio.${NC}"
    exit 1
fi

echo -e "${GREEN}Google Android Studio installation complete!${NC}"
