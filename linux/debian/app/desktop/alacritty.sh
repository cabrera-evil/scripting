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

# Install alacritty from apt
echo -e "${BLUE}Installing alacritty...${NC}"
sudo apt install -y alacritty
handle_error $? "Install alacritty" "Failed to install alacritty"

# Add alacritty to bashrc
echo -e "${BLUE}Adding alacritty to bashrc...${NC}"
echo 'alias a="alacritty"' >>~/.bashrc

# Set alacritty as default terminal
echo -e "${BLUE}Setting alacritty as default terminal...${NC}"
gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
handle_error $? "Set alacritty as default terminal" "Failed to set alacritty as default terminal"

# Create alacritty config file
echo -e "${BLUE}Creating alacritty config file...${NC}"
mkdir -p ~/.config/alacritty
touch ~/.config/alacritty/alacritty.yml

# If node is installed, install alacritty-themes
if [ -x "$(command -v node)" ]; then
    echo -e "${BLUE}Installing alacritty-themes...${NC}"
    npm install -g alacritty-themes
    handle_error $? "Install alacritty-themes" "Failed to install alacritty-themes"
fi

# Copy the bashrc file
echo -e "${BLUE}Copying the bashrc file...${NC}"
cp ~/.bashrc ~/.bashrc.bak
handle_error $? "Copy the bashrc file" "Failed to copy the bashrc file"

echo -e "${GREEN}Alacritty has been installed successfully!${NC}"
