#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Error handling function
handle_error() {
    local exit_code=$1
    local command=$2
    local message=$3

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: $command failed - $message${NC}" >&2
        exit $exit_code
    fi
}

# Install Discord
echo -e "${BLUE}Downloading Discord...${NC}"
wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
handle_error $? "wget" "Failed to download Discord"

echo -e "${BLUE}Installing Discord...${NC}"
sudo apt install /tmp/discord.deb
handle_error $? "dpkg" "Failed to install Discord"

echo -e "${GREEN}Discord installation complete!${NC}"
