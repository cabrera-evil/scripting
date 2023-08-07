#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

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

# Prompt user for default boot loader option
echo -e "${YELLOW}Please enter the default boot loader option (e.g. 0, 1, 2, etc.):${NC}"
read option

# Update /etc/default/grub file
echo -e "${GREEN}Updating /etc/default/grub file${NC}"
sudo sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=$option/" /etc/default/grub
handle_error $? "sed" "Failed to update /etc/default/grub file"

# Update GRUB configuration
echo -e "${GREEN}Updating GRUB configuration${NC}"
sudo update-grub2
handle_error $? "update-grub2" "Failed to update GRUB configuration"

echo -e "${GREEN}GRUB configuration updated successfully!${NC}"
