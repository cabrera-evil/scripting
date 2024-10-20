#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.de"

# Download Chrome
echo -e "${BLUE}Downloading Chrome...${NC}"
wget -O /tmp/chrome.deb "$URL"

# Install Chrome
echo -e "${BLUE}Installing Chrome...${NC}"
sudo apt install -y /tmp/chrome.deb

echo -e "${GREEN}Chrome installation complete!${NC}"
