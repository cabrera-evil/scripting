#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install k3s with get-k3s script
echo -e "${BLUE}Installing k3s...${NC}"
curl -sfL https://get.k3s.io | sh -

echo -e "${GREEN}k3s installation completed successfully.${NC}"
