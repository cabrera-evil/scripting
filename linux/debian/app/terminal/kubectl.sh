#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Download kubectl binary
wget -O /tmp/kubectl "https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Install kubectl
sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl

# Enable autocompletion with bash
echo "source <(kubectl completion bash)" >>~/.bashrc

echo -e "${GREEN}kubectl installation completed successfully.${NC}"
