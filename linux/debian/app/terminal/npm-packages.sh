#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Error handling function
handle_error() {
    local exit_code=$1
    local command=$2
    local message=$3

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: $command failed - $message${NC}" >&2
        exit $exit_code
    fi
}

echo -e "${BLUE}Installing npm packages...${NC}"

npm install -g yarn
handle_error $? "Yarn installation" "Failed to install Yarn."

npm install -g pnpm
handle_error $? "PNPM installation" "Failed to install PNPM."

npm install -g pm2
handle_error $? "PM2 installation" "Failed to install PM2."

npm install -g @nestjs/cli
handle_error $? "NestJS CLI installation" "Failed to install NestJS CLI."

npm install -g nodemon
handle_error $? "Nodemon installation" "Failed to install Nodemon."

npm install -g express-generator
handle_error $? "Express generator installation" "Failed to install Express generator."

