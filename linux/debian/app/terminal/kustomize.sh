#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Download Kustomize
echo -e "${BLUE}Downloading Kustomize...${NC}"
wget -O /tmp/kustomize_installer "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"

# Install Kustomize
echo -e "${BLUE}Installing Kustomize...${NC}"
chmod +x /tmp/kustomize_installer

# Moving Kustomize to /usr/local/bin
echo -e "${BLUE}Moving Kustomize to /usr/local/bin...${NC}"
sudo mv /tmp/kustomize /usr/local/bin/kustomize

echo -e "${GREEN}Kustomize installation completed successfully.${NC}"
