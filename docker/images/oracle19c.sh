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

# Login into Oracle container registry
echo -e "${BLUE}Logging into Oracle container registry...${NC}"
docker login container-registry.oracle.com
handle_error $? "docker login container-registry.oracle.com" "Failed to login into Oracle container registry"

# Download Oracle 19c image
echo -e "${BLUE}Downloading Oracle 19c image...${NC}"
docker pull container-registry.oracle.com/database/enterprise:19.3.0.0
handle_error $? "docker pull container-registry.oracle.com/database/enterprise:19.3.0.0" "Failed to download Oracle 19c image"

# Create Oracle container
echo -e "${BLUE}Creating Oracle container...${NC}"
docker run -d --name oracle19c -p 1521:1521 -p 5500:5500 container-registry.oracle.com/database/enterprise:19.3.0.0
handle_error $? "docker run" "Failed to create Oracle container"

echo -e "${GREEN}Oracle container created successfully!${NC}"
