#!/bin/bash

# Function to check command success
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if Snap is already installed
if [ -x "$(command -v snap)" ]; then
    echo "Snap is already installed."
else
    # Install Snap
    sudo dnf install -y snapd
    check_command_success "Failed to install Snap."

    # Enable and start Snapd socket
    sudo systemctl enable --now snapd.socket
    check_command_success "Failed to enable Snapd socket."
fi

# Install Termius via Snap
sudo snap install termius-app
check_command_success "Failed to install Termius."

echo "Termius installation completed successfully."
