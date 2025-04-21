#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Adding sudo user
echo -e "${BLUE}Adding sudo user${NC}"
sudo usermod -aG sudo $USER

# Checking if sudo user was added
echo -e "${BLUE}Checking if sudo user was added${NC}"
groups $USER | grep -q -w "sudo"

echo -e "${GREEN}Sudo user was added${NC}"