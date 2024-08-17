#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install snapd
echo -e "${BLUE}Installing snapd...${NC}"
sudo apt install snapd -y

# Install microk8s
echo -e "${BLUE}Installing microk8s...${NC}"
sudo snap install microk8s --classic

# Create microk8s cache dir
echo -e "${BLUE}Creating microk8s cache dir...${NC}"
mkdir -p $HOME/.kube
chmod 0700 $HOME/.kube

# Add user to microk8s group
echo -e "${BLUE}Adding user to microk8s group...${NC}"
sudo usermod -aG microk8s $USER

# Reload user groups
echo -e "${BLUE}Reloading user groups...${NC}"
newgrp microk8s

# Wait for microk8s to start
echo -e "${BLUE}Waiting for microk8s to start...${NC}"
microk8s status --wait-ready

# Export kubeconfig
echo -e "${BLUE}Exporting kubeconfig...${NC}"
microk8s kubectl config view --raw >$HOME/.kube/config

# Enable microk8s services
echo -e "${BLUE}Enabling microk8s services...${NC}"
microk8s enable dns dashboard helm hostpath-storage ingress

echo -e "${GREEN}microk8s installed successfully!${NC}"
