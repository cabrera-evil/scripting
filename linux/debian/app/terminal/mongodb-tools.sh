#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian12-${OS_ARCH_RAW}-100.10.0.deb"

# Download MongoDB Database Tools
echo -e "${BLUE}Downloading MongoDB Database Tools...${NC}"
wget -O /tmp/mongodb-database-tools.deb "$URL"

# Install MongoDB Database Tools
echo -e "${BLUE}Installing MongoDB Database Tools...${NC}"
sudo apt install -y /tmp/mongodb-database-tools.deb

echo -e "${GREEN}MongoDB Database Tools installation complete!${NC}"
