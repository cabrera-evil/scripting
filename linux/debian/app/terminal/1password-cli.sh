#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://cache.agilebits.com/dist/1P/op2/pkg/v2.30.0/op_linux_amd64_v2.30.0.zip"

# Download 1Password CLI
echo -e "${BLUE}Downloading 1Password CLI...${NC}"
wget -O /tmp/op.zip "$URL"

# Decompress the downloaded file
echo -e "${BLUE}Decompressing the downloaded file...${NC}"
unzip /tmp/op.zip -d /tmp/op-dir

# Install 1Password CLI
echo -e "${BLUE}Installing 1Password CLI...${NC}"
sudo mv /tmp/op-dir/op /usr/local/bin

# Set permissions
echo -e "${BLUE}Setting permissions...${NC}"
sudo groupadd -f onepassword-cli && \
sudo chgrp onepassword-cli /usr/local/bin/op && \
sudo chmod g+s /usr/local/bin/op

echo -e "${GREEN}1Password CLI installation completed successfully.${NC}"

