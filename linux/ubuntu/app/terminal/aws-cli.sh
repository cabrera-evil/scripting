#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://awscli.amazonaws.com/awscli-exe-linux-${OS_ARCH_RAW}.zip"

# Download AWS CLI installer
echo -e "${BLUE}Downloading AWS CLI installer...${NC}"
wget -O /tmp/awscliv2.zip "$URL"

# Unzip the installer
echo -e "${BLUE}Unzipping AWS CLI installer...${NC}"
unzip -q /tmp/awscliv2.zip -d /tmp/

# Install AWS CLI
echo -e "${BLUE}Installing AWS CLI...${NC}"
sudo /tmp/aws/install --update

echo -e "${GREEN}AWS CLI installation complete!${NC}"
