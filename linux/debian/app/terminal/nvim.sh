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

# Downlaod nvim pre-built binary
echo -e "${BLUE}Downloading nvim pre-built binary...${NC}"
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -O /tmp/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf /tmp/nvim-linux64.tar.gz
handle_error $? "Download nvim pre-built binary" "Failed to download nvim pre-built binary"

# Create symbolic link
echo -e "${BLUE}Creating symbolic link...${NC}"
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/bin/nvim
handle_error $? "Create symbolic link" "Failed to create symbolic link"

# Add nvim path to environment
echo -e "${BLUE}Adding nvim path to environment...${NC}"
echo "export PATH=\$PATH:/opt/nvim-linux64/bin" >> ~/.bashrc

# Install NvChad
echo -e "${BLUE}Installing NvChad...${NC}"
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
handle_error $? "Install NvChad" "Failed to install NvChad"

echo -e "${GREEN}nvim has been installed successfully!${NC}"