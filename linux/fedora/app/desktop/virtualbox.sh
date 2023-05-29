#!/bin/bash

# Function to check command success
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if VirtualBox is already installed
if command -v vboxmanage >/dev/null 2>&1; then
    echo "VirtualBox is already installed."
    exit 0
fi

# Enable RPM Fusion repository
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
check_command_success "Failed to enable RPM Fusion repository."

# Install VirtualBox dependencies
sudo dnf install -y dkms kernel-devel-$(uname -r) elfutils-libelf-devel qt5-qtx11extras

# Add VirtualBox repository
sudo wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo rpm --import -
check_command_success "Failed to add VirtualBox repository."

# Download VirtualBox repository file
sudo wget -O /etc/yum.repos.d/virtualbox.repo https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
check_command_success "Failed to download VirtualBox repository file."

# Install VirtualBox
sudo dnf install -y VirtualBox-6.1
check_command_success "Failed to install VirtualBox."

echo "VirtualBox installation completed successfully."
