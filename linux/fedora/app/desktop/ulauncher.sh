#!/bin/bash

# Function to check command success
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if Ulauncher is already installed
if [ -x "$(command -v ulauncher)" ]; then
    echo "Ulauncher is already installed."
    exit 0
fi

# Install Ulauncher
sudo dnf install -y ulauncher
check_command_success "Failed to install Ulauncher."

echo "Ulauncher installation completed successfully."
