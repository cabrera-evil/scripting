#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Wait for microk8s to start
echo -e "${BLUE}Waiting for microk8s to start...${NC}"
microk8s status --wait-ready

# Create microk8s cache dir
echo -e "${BLUE}Creating microk8s cache dir...${NC}"
mkdir -p $HOME/.kube
chmod 0700 $HOME/.kube

# Export kubeconfig
echo -e "${BLUE}Exporting kubeconfig...${NC}"
microk8s kubectl config view --raw >$HOME/.kube/config-microk8s

echo -e "${GREEN}Microk8s kubeconfig exported successfully!${NC}"
