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

# Download kubectl binary
wget -O /tmp/kubectl "https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
handle_error $? "Downloading kubectl binary" "Failed to download kubectl binary"

# Install kubectl
sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
handle_error $? "Installing kubectl" "Failed to install kubectl"

# Enable autocompletion with bash
echo "source <(kubectl completion bash)" >>~/.bashrc
handle_error $? "Enabling autocompletion with bash" "Failed to enable autocompletion with bash"

echo -e "${GREEN}kubectl installation completed successfully.${NC}"
