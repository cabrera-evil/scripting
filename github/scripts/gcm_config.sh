#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Install Git Credential Manager Core
echo -e "${GREEN}Installing Git Credential Manager Core${NC}"
wget -O /tmp/gcm.deb "https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.0.935/gcm-linux_amd64.2.0.935.deb"
sudo dpkg -i /tmp/gcm.deb

# Configuring GCMC
echo -e "${GREEN}Configuring GCMC${NC}"
git-credential-manager configure

# Install keyring
echo -e "${GREEN}Installing keyring${NC}"
sudo apt-get install gnome-keyring -y

# Install missing dependency
echo -e "${GREEN}Installing missing dependency${NC}"
sudo apt-get install libsecret-1-dev -y

# Fixing GCMC error
echo -e "${GREEN}Fixing GCMC error${NC}"
git config --global credential.credentialStore secretservice
