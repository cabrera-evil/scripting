#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Create K3s cache dir
echo -e "${BLUE}Creating k3s cache dir...${NC}"
mkdir -p $HOME/.kube
chmod 0600 $HOME/.kube

# Export kubeconfig
echo -e "${BLUE}Exporting kubeconfig...${NC}"
sudo cat /etc/rancher/k3s/k3s.yaml | sudo tee $HOME/.kube/config-local > /dev/null

# Change context to local
echo -e "${BLUE}Changing context from 'default' to 'local'...${NC}"
sed -i 's/default/local/g' $HOME/.kube/config-local

# Change ownership of kubeconfig
echo -e "${BLUE}Changing ownership of kubeconfig...${NC}"
sudo chown $(id -u):$(id -g) $HOME/.kube/config-local

echo -e "${GREEN}K3s kubeconfig exported successfully!${NC}"
