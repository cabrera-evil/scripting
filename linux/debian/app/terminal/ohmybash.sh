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

# Download NerdFonts
echo -e "${BLUE}Downloading NerdFonts...${NC}"
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip -O /tmp/CascadiaCode.zip
unzip -q /tmp/CascadiaCode.zip -d ~/.local/share/fonts
handle_error $? "Download NerdFonts" "Failed to download NerdFonts"

# Update font cache
echo -e "${BLUE}Updating font cache...${NC}"
fc-cache -f -v
handle_error $? "Update font cache" "Failed to update font cache"

# Install starship prompt
echo -e "${BLUE}Installing starship prompt...${NC}"
curl -fsSL https://starship.rs/install.sh | sh
handle_error $? "Install starship prompt" "Failed to install starship prompt"

# Add starship prompt to bashrc
echo -e "${BLUE}Adding starship prompt to bashrc...${NC}"
echo 'eval "$(starship init bash)"' >>~/.bashrc

# Download Oh My Bash
echo -e "${BLUE}Downloading Oh My Bash...${NC}"
bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
handle_error $? "Download Oh My Bash" "Failed to download Oh My Bash"

# Add the old bashrc to the new bashrc
echo -e "${BLUE}Adding the old bashrc to the new bashrc...${NC}"
awk '/export NVM_DIR/,0' ~/.bashrc.bak >>~/.bashrc
handle_error $? "Add the old bashrc to the new bashrc" "Failed to add the old bashrc to the new bashrc"