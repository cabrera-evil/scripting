#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
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

# Download Mongo image
echo -e "${BLUE}Downloading Mongo image...${NC}"
docker pull mongo
handle_error $? "docker pull mongo" "Failed to download Mongo image"

# Create the image container named "mongodb"
echo -e "${BLUE}Creating the Mongo container...${NC}"
docker run -d -p 2717:27017 --name mongodb mongo:latest
handle_error $? "docker run" "Failed to create the Mongo container"

echo -e "${GREEN}Mongo container created successfully!${NC}"
