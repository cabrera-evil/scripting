#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://dbeaver.io/files/dbeaver-ce_latest_${OS_ARCH}.deb"

# Download Dbeaver
echo -e "${BLUE}Downloading DBeaverCommunity...${NC}"
wget -O /tmp/dbeaver.deb "$URL"

# Install Dbeaver
echo -e "${BLUE}Installing DBeaverCommunity...${NC}"
sudo apt install -y /tmp/dbeaver.deb

echo -e "${GREEN}DBeaverCommunity installation complete!${NC}"
