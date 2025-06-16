#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://mega.nz/linux/repo/Debian_12/amd64/megasync-Debian_12_${OS_ARCH}.deb"

# Download MegaSync
echo -e "${BLUE}Downloading MegaSync...${NC}"
wget -O /tmp/megasync.deb "$URL"

# Install Chrome
echo -e "${BLUE}Installing MegaSync...${NC}"
sudo apt install -y /tmp/megasync.deb

echo -e "${GREEN}MegaSync installation complete!${NC}"
