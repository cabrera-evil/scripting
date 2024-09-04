#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Downlaod nvim pre-built binary
echo -e "${BLUE}Downloading nvim pre-built binary...${NC}"
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -O /tmp/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf /tmp/nvim-linux64.tar.gz

# Create symbolic link
echo -e "${BLUE}Creating symbolic link...${NC}"
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/bin/nvim

# Add nvim path to environment
echo -e "${BLUE}Adding nvim path to environment...${NC}"
echo "export PATH=\$PATH:/opt/nvim-linux64/bin" >>~/.bashrc

# Export nvim alias to bashrc (overwrite the vim alias)
echo -e "${BLUE}Exporting nvim alias to bashrc...${NC}"
if ! grep -q "alias vim=\"nvim\"" ~/.bashrc; then
    echo 'alias vim="nvim"' >>~/.bashrc
fi
if ! grep -q "alias vi=\"nvim\"" ~/.bashrc; then
    echo 'alias vi="nvim"' >>~/.bashrc
fi
# Install NvChad
echo -e "${BLUE}Installing NvChad...${NC}"
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

echo -e "${GREEN}Nvim has been installed successfully!${NC}"
