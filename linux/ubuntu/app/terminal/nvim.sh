#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${OS_ARCH_RAW}.tar.gz"

# Download nvim pre-built binary
echo -e "${BLUE}Downloading nvim pre-built binary...${NC}"
wget -O /tmp/nvim-linux-${OS_ARCH_RAW}.tar.gz "$URL"
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf /tmp/nvim-linux-${OS_ARCH_RAW}.tar.gz

# Create symbolic link
echo -e "${BLUE}Creating symbolic link...${NC}"
sudo ln -sf /opt/nvim-linux-${OS_ARCH_RAW}/bin/nvim /usr/local/bin/nvim

# Install NvChad
echo -e "${BLUE}Installing NvChad...${NC}"
if [ ! -d ~/.config/nvim ]; then
    git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
fi

echo -e "${GREEN}Nvim has been installed successfully!${NC}"
