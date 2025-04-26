#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Run installation script
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Enable autocompletion with bash
echo -e "${BLUE}Enabling autocompletion with bash...${NC}"
if ! grep -q "source <(helm completion bash)" ~/.bashrc; then
    echo "source <(helm completion bash)" >>~/.bashrc
fi

echo -e "${GREEN}Helm installation completed successfully.${NC}"
