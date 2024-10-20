#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Define variables
URL="https://desktop.docker.com/linux/main/amd64/167172/docker-desktop-amd64.deb"

# Uninstall docker desktop
echo -e "${BLUE}Cleaning old installations${NC}"
sudo apt purge --remove docker-desktop -y
rm -r $HOME/.docker/desktop
sudo rm /usr/local/bin/com.docker.cli

# Uninstall docker engine
echo -e "${BLUE}Uninstalling Docker Engine${NC}"
sudo apt purge --remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
sudo apt autoremove -y
sudo apt autoclean -y

# Setup The Repository
echo -e "${BLUE}Setting up Docker repository${NC}"
sudo apt update -y
sudo apt install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt update -y

# Installing Docker Engine
echo -e "${BLUE}Installing Docker Engine${NC}"
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Download Docker Desktop
echo -e "${BLUE}Downloading latest version of Docker Desktop${NC}"
wget -O /tmp/docker-desktop.deb "$URL"

# Install The Downloaded Package
echo -e "${BLUE}Installing Docker Desktop${NC}"
sudo apt update -y
sudo apt install -y /tmp/docker-desktop.deb

# Add User To Docker
echo -e "${BLUE}Adding user to Docker organization${NC}"
sudo usermod -aG docker $USER

# Enable the Docker service
echo -e "${BLUE}Enabling Docker service${NC}"
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo -e "${GREEN}Docker installation and configuration complete!${NC}"
