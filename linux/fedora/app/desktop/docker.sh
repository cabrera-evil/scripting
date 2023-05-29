#!/bin/bash

set -e

# Remove older versions of Docker
sudo dnf remove -y docker docker-engine docker-client docker-common docker-logrotate docker-latest

# Install Docker Engine
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Download Docker Desktop RPM package
download_url="https://desktop.docker.com/linux/main/amd64/docker-desktop-4.19.0-x86_64.rpm"
download_file="/tmp/docker-desktop.rpm"

echo "Downloading Docker Desktop RPM package..."
if ! curl -L "$download_url" -o "$download_file"; then
    echo "Error: Failed to download Docker Desktop RPM package."
    exit 1
fi

# Install Docker Desktop from the downloaded file
if [ -f "$download_file" ]; then
    sudo dnf install -y "$download_file"
    echo "Docker Desktop installed successfully."
    rm "$download_file"  # Remove the downloaded file
else
    echo "Error: The downloaded Docker Desktop RPM file does not exist."
    exit 1
fi
