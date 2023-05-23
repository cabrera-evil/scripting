#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Add OBS Studio PPA
echo -e "${BLUE}Adding OBS Studio PPA...${NC}"
if ! sudo add-apt-repository -y ppa:obsproject/obs-studio; then
    echo -e "${RED}Failed to add OBS Studio PPA.${NC}"
    exit 1
fi

# Update package lists
echo -e "${BLUE}Updating package lists...${NC}"
if ! sudo apt update; then
    echo -e "${RED}Failed to update package lists.${NC}"
    exit 1
fi

# Install OBS Studio
echo -e "${BLUE}Installing OBS Studio...${NC}"
if ! sudo apt install -y obs-studio; then
    echo -e "${RED}Failed to install OBS Studio.${NC}"
    exit 1
fi

echo -e "${GREEN}OBS Studio installation complete!${NC}"
