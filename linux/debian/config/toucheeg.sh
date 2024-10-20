#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://github.com/JoseExposito/touchegg/releases/download/2.0.17/touchegg_2.0.17_amd64.deb"

# Download touchegg
echo -e "${BLUE}Downloading touchegg...${NC}"
wget -O /tmp/touchegg.deb "$URL"

# Install touchegg
echo -e "${BLUE}Installing touchegg...${NC}"
sudo apt install /tmp/touchegg.deb -y
