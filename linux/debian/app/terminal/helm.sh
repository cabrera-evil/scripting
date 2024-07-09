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

# Download helm binary
wget -O /tmp/helm "https://get.helm.sh/helm-v3.15.2-linux-amd64.tar.gz"
handle_error $? "Downloading helm binary" "Failed to download helm binary"

# Install helm
tar -zxvf /tmp/helm -C /tmp
sudo install -o root -g root -m 0755 /tmp/linux-amd64/helm /usr/local/bin/helm
handle_error $? "Installing helm" "Failed to install helm"

# Enable autocompletion with bash
echo "source <(helm completion bash)" >>~/.bashrc
handle_error $? "Enabling autocompletion with bash" "Failed to enable autocompletion with bash"

echo -e "${GREEN}helm installation completed successfully.${NC}"