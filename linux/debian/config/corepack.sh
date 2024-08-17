#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Enable Corepack
echo -e "${BLUE}Enabling Corepack...${NC}"
corepack enable

echo -e "${GREEN}Corepack enabled successfully.${NC}"

