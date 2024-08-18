#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Download 1Password CLI
echo -e "${BLUE}Downloading 1Password CLI...${NC}"
wget -O /tmp/op.deb "https://cache.agilebits.com/dist/1P/op2/pkg/v2.30.0/op_linux_amd64_v2.30.0.zip"

# Decompress the downloaded file
echo -e "${BLUE}Decompressing the downloaded file...${NC}"
unzip /tmp/op.deb -d /tmp/op-dir

# Install 1Password CLI
echo -e "${BLUE}Installing 1Password CLI...${NC}"
sudo mv /tmp/op-dir/op /usr/local/bin

echo -e "${GREEN}1Password CLI installation completed successfully.${NC}"

