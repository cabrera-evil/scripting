#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Get latest lazydocker version
echo -e "${BLUE}Fetching latest Lazydocker version...${NC}"
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

echo -e "${GREEN}Lazydocker installation completed successfully.${NC}"
