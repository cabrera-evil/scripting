#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Download kubectl binary
echo -e "${BLUE}Downloading kubectl...${NC}"
wget -O /tmp/kubectl "$URL"

# Install kubectl
echo -e "${BLUE}Installing kubectl...${NC}"
sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl

# Enable autocompletion with bash
echo -e "${BLUE}Enabling autocompletion with bash...${NC}"
if ! grep -q "source <(kubectl completion bash)" ~/.bashrc; then
    echo "source <(kubectl completion bash)" >>~/.bashrc
fi

echo -e "${GREEN}Kubectl installation completed successfully.${NC}"
