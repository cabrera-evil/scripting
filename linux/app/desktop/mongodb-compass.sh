#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install MongoDB Compass
clear
echo -e "${BLUE}Downloading MongoDB Compass...${NC}"
if ! wget -O /tmp/mongodb_compass.deb "https://downloads.mongodb.com/compass/mongodb-compass_1.35.0_amd64.deb"; then
    echo -e "${RED}Failed to download MongoDB Compass.${NC}"
    exit 1
fi

echo -e "${BLUE}Installing MongoDB Compass...${NC}"
if ! sudo dpkg -i /tmp/mongodb_compass.deb; then
    echo -e "${RED}MongoDB Compass installed with some errors (might be normal).${NC}"
fi

echo -e "${GREEN}MongoDB Compass installation complete!${NC}"
