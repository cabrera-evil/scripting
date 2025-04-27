#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://downloads.mongodb.com/compass/mongodb-compass_1.44.5_${OS_ARCH}.deb"

# Download MongoDB Compass
echo -e "${BLUE}Downloading MongoDB Compass...${NC}"
wget -O /tmp/mongodb-compass.deb "$URL"

# Install MongoDB Compass
echo -e "${BLUE}Installing MongoDB Compass...${NC}"
sudo apt install -y /tmp/mongodb-compass.deb

echo -e "${GREEN}MongoDB Compass installation complete!${NC}"
