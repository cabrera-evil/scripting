#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Download helm binary
wget -O /tmp/helm "https://get.helm.sh/helm-v3.15.2-linux-amd64.tar.gz"

# Install helm
tar -zxvf /tmp/helm -C /tmp
sudo install -o root -g root -m 0755 /tmp/linux-amd64/helm /usr/local/bin/helm

# Enable autocompletion with bash
echo "source <(helm completion bash)" >>~/.bashrc

echo -e "${GREEN}helm installation completed successfully.${NC}"