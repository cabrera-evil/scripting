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

# Install NVM
echo -e "${BLUE}Installing NVM...${NC}"

# Verify if wget is installed if not, install wget
if ! [ -x "$(command -v wget)" ]; then
    echo -e "${YELLOW}Wget is not installed, installing...${NC}"
    sudo apt install wget -y
    handle_error $? "Wget installation" "Failed to install Wget."
fi

# Install NVM using wget
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
handle_error $? "NVM installation" "Failed to install NVM."

# Reload bash
echo -e "${BLUE}Reloading bash...${NC}"
source ~/.nvm/nvm.sh

# Install Node.js LTS
echo -e "${BLUE}Installing Node.js LTS...${NC}"
nvm install --lts
handle_error $? "Node.js LTS installation" "Failed to install Node.js LTS."

# Set default Node.js version
echo -e "${BLUE}Setting default Node.js version...${NC}"
nvm use --lts
handle_error $? "Node.js LTS default version" "Failed to set default Node.js LTS version."

# Install Modules
echo -e "${BLUE}Installing Node.js modules...${NC}"

npm install -g yarn
handle_error $? "Yarn installation" "Failed to install Yarn."

npm install -g typescript
handle_error $? "TypeScript installation" "Failed to install TypeScript."

npm install -g @nestjs/cli
handle_error $? "NestJS CLI installation" "Failed to install NestJS CLI."

npm install -g nodemon
handle_error $? "Nodemon installation" "Failed to install Nodemon."

npm install -g express-generator
handle_error $? "Express generator installation" "Failed to install Express generator."

echo -e "${GREEN}Script execution complete!${NC}"
