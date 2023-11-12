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

# Save GRUB default configuration
echo -e "${YELLOW}Saving GRUB default configuration...${NC}"
sudo cp /etc/default/grub /etc/default/grub.bak
handle_error $? "cp /etc/default/grub /etc/default/grub.bak" "Failed to save GRUB default configuration"

# Set GRUB default configuration
echo -e "${YELLOW}Setting GRUB default configuration...${NC}"
sudo sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/g' /etc/default/grub
handle_error $? "sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/g' /etc/default/grub" "Failed to update GRUB configuration"

# Add GRUB_SAVEDEFAULT to GRUB configuration just below GRUB_DEFAULT
echo -e "${YELLOW}Adding GRUB save default configuracion...${NC}"
if ! grep -q 'GRUB_SAVEDEFAULT=true' /etc/default/grub; then
    sudo sed -i '/GRUB_DEFAULT=saved/a GRUB_SAVEDEFAULT=true' /etc/default/grub
    handle_error $? "sed -i '/GRUB_DEFAULT=saved/a GRUB_SAVEDEFAULT=true' /etc/default/grub" "Failed to add GRUB save default"
else
    echo -e "${YELLOW}GRUB save default already exists, skipping...${NC}"
fi
handle_error $? "sed -i '/GRUB_DEFAULT=saved/a GRUB_SAVEDEFAULT=true' /etc/default/grub" "Failed to add GRUB save default"

# Set GRUB timeout to 5 seconds
echo -e "${YELLOW}Setting GRUB timeout to 5 seconds...${NC}"
sudo sed -i 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=5/g' /etc/default/grub
handle_error $? "sed -i 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=5/g' /etc/default/grub" "Failed to update GRUB configuration"

# Disable grub os-prober
echo -e "${YELLOW}Disabling GRUB os-prober...${NC}"
sudo sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/g' /etc/default/grub
handle_error $? "sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/g' /etc/default/grub" "Failed to update GRUB configuration"

# Update GRUB configuration
echo -e "${YELLOW}Updating GRUB configuration...${NC}"
sudo update-grub
handle_error $? "update-grub" "Failed to update GRUB configuration"

echo -e "${GREEN}GRUB configuration updated successfully!${NC}"
