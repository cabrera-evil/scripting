#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Prompt user for default boot loader option
echo -e "${YELLOW}Please enter the default boot loader option (e.g. 0, 1, 2, etc.):${NC}"
read option

# Update /etc/default/grub file
echo -e "${GREEN}Updating /etc/default/grub file${NC}"
if sudo sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=$option/" /etc/default/grub; then
    echo -e "${GREEN}GRUB default boot loader option updated.${NC}"
else
    echo -e "${RED}Failed to update GRUB default boot loader option.${NC}"
    exit 1
fi

# Update GRUB configuration
echo -e "${GREEN}Updating GRUB configuration${NC}"
if sudo update-grub2; then
    echo -e "${GREEN}GRUB configuration updated.${NC}"
else
    echo -e "${RED}Failed to update GRUB configuration.${NC}"
    exit 1
fi
