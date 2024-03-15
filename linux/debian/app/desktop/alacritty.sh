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

# Download Oh My Bash
echo -e "${BLUE}Downloading Oh My Bash...${NC}"
bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
handle_error $? "Download Oh My Bash" "Failed to download Oh My Bash"

# Download NerdFonts
echo -e "${BLUE}Downloading NerdFonts...${NC}"
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip -O /tmp/CascadiaCode.zip
unzip /tmp/CascadiaCode.zip -d ~/.local/share/fonts
handle_error $? "Download NerdFonts" "Failed to download NerdFonts"

# Update font cache
echo -e "${BLUE}Updating font cache...${NC}"
fc-cache -f -v
handle_error $? "Update font cache" "Failed to update font cache"

# Install starship prompt
echo -e "${BLUE}Installing starship prompt...${NC}"
curl -fsSL https://starship.rs/install.sh | bash
handle_error $? "Install starship prompt" "Failed to install starship prompt"

# Add starship prompt to bashrc
echo -e "${BLUE}Adding starship prompt to bashrc...${NC}"
echo 'eval "$(starship init bash)"' >>~/.bashrc

# Add old bashrc to new bashrc
echo -e "${BLUE}Adding old bashrc to new bashrc...${NC}"
if ! grep -q 'export NVM_DIR="$HOME/.nvm"' ~/.bashrc; then
    echo -e "${BLUE}Adding NVM_DIR to .bashrc...${NC}"
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
fi
if ! grep -q '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' ~/.bashrc; then
    echo -e "${BLUE}Adding nvm.sh to .bashrc...${NC}"
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc
fi
if ! grep -q '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' ~/.bashrc; then
    echo -e "${BLUE}Adding nvm bash_completion to .bashrc...${NC}"
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.bashrc
fi
if ! grep -q 'source <(kubectl completion bash)' ~/.bashrc; then
    echo -e "${BLUE}Adding kubectl completion to .bashrc...${NC}"
    echo 'source <(kubectl completion bash)' >> ~/.bashrc
fi
if ! grep -q 'PATH=~/.console-ninja/.bin:$PATH' ~/.bashrc; then
    echo -e "${BLUE}Adding custom PATH to .bashrc...${NC}"
    echo 'PATH=~/.console-ninja/.bin:$PATH' >> ~/.bashrc
fi
if ! grep -q 'PATH="$PATH:/opt/nvim-linux64/bin"' ~/.bashrc; then
    echo -e "${BLUE}Adding nvim PATH to .bashrc...${NC}"
    echo 'PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
fi

echo -e "${GREEN}Alacritty has been installed successfully!${NC}"
