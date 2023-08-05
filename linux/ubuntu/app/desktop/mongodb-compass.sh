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

# Install MongoDB Compass
echo -e "${BLUE}Downloading MongoDB Compass...${NC}"
wget -O /tmp/mongodb_compass.deb "https://downloads.mongodb.com/compass/mongodb-compass_1.35.0_amd64.deb"
handle_error $? "wget" "Failed to download MongoDB Compass"

echo -e "${BLUE}Installing MongoDB Compass...${NC}"
sudo apt install /tmp/mongodb_compass.deb
handle_error $? "dpkg" "Failed to install MongoDB Compass"

echo -e "${GREEN}MongoDB Compass installation complete!${NC}"
