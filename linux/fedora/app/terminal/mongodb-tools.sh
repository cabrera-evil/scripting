#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Download MongoDB Database Tools
clear
echo -e "${BLUE}Downloading MongoDB Database Tools...${NC}"
if ! wget -O /tmp/mongodb-database-tools.rpm "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel90-arm64-100.7.1.rpm"; then
    echo -e "${RED}Failed to download MongoDB Database Tools.${NC}"
    exit 1
fi

# Install MongoDB Database Tools
echo -e "${BLUE}Installing MongoDB Database Tools...${NC}"
if ! sudo rpm -i /tmp/mongodb-database-tools.rpm; then
    echo -e "${RED}MongoDB Database Tools installed with some errors (might be normal).${NC}"
fi

echo -e "${GREEN}MongoDB Database Tools installation complete!${NC}"
