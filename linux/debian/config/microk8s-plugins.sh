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

# Enable microk8s plugins
echo -e "${BLUE}Enabling microk8s plugins...${NC}"
microk8s enable dns dashboard helm hostpath-storage ingress

echo -e "${GREEN}Microk8s plugins enabled successfully!${NC}"
