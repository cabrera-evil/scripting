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
sudo sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=$option/" /etc/default/grub

# Update GRUB configuration
echo -e "${GREEN}Updating GRUB configuration${NC}"
sudo update-grub2
