#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
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

# Remove older versions of Docker
echo -e "${BLUE}Removing older versions of Docker...${NC}"
sudo dnf remove -y docker docker-engine docker-client docker-common docker-logrotate docker-latest
handle_error $? "sudo dnf remove" "Failed to remove older versions of Docker"

# Install Docker Engine
echo -e "${BLUE}Installing Docker Engine...${NC}"
sudo dnf -y install dnf-plugins-core
handle_error $? "sudo dnf install" "Failed to install dnf-plugins-core"
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
handle_error $? "sudo dnf config-manager" "Failed to add Docker repository"
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
handle_error $? "sudo dnf install" "Failed to install Docker Engine"

# Start and enable Docker service
echo -e "${BLUE}Starting and enabling Docker service...${NC}"
sudo systemctl start docker
handle_error $? "sudo systemctl start" "Failed to start Docker service"
sudo systemctl enable docker
handle_error $? "sudo systemctl enable" "Failed to enable Docker service"

# Download Docker Desktop RPM package
download_url="https://desktop.docker.com/linux/main/amd64/docker-desktop-4.19.0-x86_64.rpm"
download_file="/tmp/docker-desktop.rpm"

echo -e "${BLUE}Downloading Docker Desktop RPM package...${NC}"
if ! curl -L "$download_url" -o "$download_file"; then
    handle_error 1 "curl" "Failed to download Docker Desktop RPM package"
fi

# Install Docker Desktop from the downloaded file
if [ -f "$download_file" ]; then
    echo -e "${BLUE}Installing Docker Desktop...${NC}"
    sudo dnf install -y "$download_file"
    handle_error $? "sudo dnf install" "Failed to install Docker Desktop"
    echo -e "${GREEN}Docker Desktop installed successfully.${NC}"
    rm "$download_file"  # Remove the downloaded file
else
    handle_error 1 "file check" "The downloaded Docker Desktop RPM file does not exist"
fi