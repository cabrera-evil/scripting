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

# Download Chrome Dev
echo -e "${BLUE}Downloading Chrome Dev...${NC}"
wget -O /tmp/chrome-dev.deb "https://dl.google.com/linux/direct/google-chrome-unstable_current_amd64.deb"
handle_error $? "wget Chrome Dev" "Failed to download Chrome Dev"

# Install Chrome Dev
echo -e "${BLUE}Installing Chrome Dev...${NC}"
if ! sudo apt install -y /tmp/chrome-dev.deb; then
    echo -e "${RED}Chrome Dev installed with some errors (might be normal).${NC}"
fi

echo -e "${GREEN}Chrome Dev installation complete!${NC}"
