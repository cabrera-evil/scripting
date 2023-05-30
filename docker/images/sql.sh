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

# Download MongoDB image
echo -e "${BLUE}Downloading MongoDB image...${NC}"
docker pull mcr.microsoft.com/mssql/server
handle_error $? "docker pull mcr.microsoft.com/mssql/server" "Failed to download MongoDB image"

# Create SQL Server container
echo -e "${BLUE}Creating SQL Server container...${NC}"
sudo docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<admin@qkj2x4T@6@Xy>" \
   -p 1433:1433 --name sqlserver --hostname sqlserver \
   -d \
   mcr.microsoft.com/mssql/server:latest
handle_error $? "docker run" "Failed to create SQL Server container"

echo -e "${GREEN}SQL Server container created successfully!${NC}"
