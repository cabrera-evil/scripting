#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://downloads.1password.com/linux/debian/${OS_ARCH}/stable/1password-latest.deb"

# Download 1Password
echo -e "${BLUE}Downloading 1Password...${NC}"
wget -O /tmp/1password.deb "$URL"

# Install 1Password
echo -e "${BLUE}Installing 1Password...${NC}"
sudo apt install -y /tmp/1password.deb

echo -e "${GREEN}1Password installation complete!${NC}"
