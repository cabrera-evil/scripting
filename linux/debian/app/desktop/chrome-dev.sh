#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Download Chrome Dev
echo -e "${BLUE}Downloading Chrome Dev...${NC}"
wget -O /tmp/chrome-dev.deb "https://dl.google.com/linux/direct/google-chrome-unstable_current_amd64.deb"

# Install Chrome Dev
echo -e "${BLUE}Installing Chrome Dev...${NC}"
sudo apt install -y /tmp/chrome-dev.deb

echo -e "${GREEN}Chrome Dev installation complete!${NC}"
