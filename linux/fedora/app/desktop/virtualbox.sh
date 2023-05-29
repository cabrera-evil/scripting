#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install VirtualBox
echo -e "${BLUE}Installing VirtualBox...${NC}"
sudo dnf install -y VirtualBox
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install VirtualBox.${NC}"
    exit 1
fi

echo -e "${GREEN}VirtualBox installation complete!${NC}"
