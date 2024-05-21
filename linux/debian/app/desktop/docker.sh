#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

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

# Global Variables
DOCKER_VERSION=4.30.0

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
handle_error $? "Docker Engine Installation" "Failed to install Docker Engine"

# Download Docker Desktop
echo -e "${BLUE}Downloading latest version of Docker Desktop${NC}"
wget -O /tmp/docker-desktop.deb "https://desktop.docker.com/linux/main/amd64/149282/docker-desktop-${DOCKER_VERSION}-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64"
handle_error $? "Docker Desktop Download" "Failed to download Docker Desktop"

# Install The Downloaded Package
echo -e "${BLUE}Installing Docker Desktop${NC}"
sudo apt update -y
sudo apt install -y /tmp/docker-desktop.deb
handle_error $? "Docker Desktop Installation" "Failed to install Docker Desktop"

# Add User To Docker
echo -e "${BLUE}Adding user to Docker organization${NC}"
sudo usermod -aG docker $USER
newgrp docker

# Enable the Docker service
echo -e "${BLUE}Enabling Docker service${NC}"
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo -e "${GREEN}Docker installation and configuration complete!${NC}"
