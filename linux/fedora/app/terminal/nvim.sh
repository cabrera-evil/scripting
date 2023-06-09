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

# Installing required packages
echo -e "${BLUE}Installing ripgrep...${NC}"
sudo dnf install ripgrep -y
handle_error $? "Install ripgrep" "Failed to install ripgrep"

echo -e "${BLUE}Installing lazygit...${NC}"
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit -y
handle_error $? "Install lazygit" "Failed to install lazygit"

echo -e "${BLUE}Installing disk analyzer...${NC}"
sudo snap install gdu-disk-usage-analyzer
handle_error $? "Install disk analyzer" "Failed to install disk analyzer"
sudo snap connect gdu-disk-usage-analyzer:mount-observe :mount-observe
sudo snap connect gdu-disk-usage-analyzer:system-backup :system-backup
sudo snap alias gdu-disk-usage-analyzer.gdu gdu

echo -e "${BLUE}Installing bottom...${NC}"
sudo dnf copr enable atim/bottom -y
sudo dnf install bottom -y

# Installing Nerd Fotns
echo -e "${BLUE}Downloading Nerd Fonts...${NC}"
wget -O /tmp/3270.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/3270.zip"
handle_error $? "Nerd Fonts download" "Failed to download the Nerd Fonts"

echo -e "${BLUE}Installing Nerd Fonts...${NC}"
mkdir -p ~/.local/share/fonts
unzip /tmp/3270.zip -d ~/.local/share/fonts/
rm /tmp/3270.zip
fc-cache -fv
handle_error $? "Netd Fonts installation" "Failed to install the Nerd Fonts"

# Installing Neovim
echo -e "${BLUE}Installing Neovim...${NC}"
sudo dnf install neovim -y
handle_error $? "Install Neovim" "Failed to install Neovim"

# Clone AstroNvim repository
echo -e "${BLUE}Cloning AstroNvim repository...${NC}"
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
handle_error $? "Clone AstroNvim repository" "Failed to clone AstroNvim repository"

echo -e "${GREEN}Setup completed successfully!${NC}"
echo -e "${YELLOW}Please launch Neovim with 'nvim' command.${NC}"

