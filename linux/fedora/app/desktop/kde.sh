#!/bin/bash

# Function to check command success
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if KDE is already installed
if [ -x "$(command -v startkde)" ]; then
    echo "KDE is already installed."
    exit 0
fi

# Install KDE packages
sudo dnf install -y @kde-desktop
check_command_success "Failed to install KDE packages."

# Set default target to graphical
sudo systemctl set-default graphical.target
check_command_success "Failed to set default target to graphical."

echo "KDE installation completed successfully. Please reboot to start KDE."
