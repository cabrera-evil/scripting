#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Ask for the new local DNS server
echo -e "${BLUE}Please enter the new local DNS server IP (e.g., 192.168.1.1):${NC}"
read -r dns_server

# Validate that the DNS server input is not empty
if [[ -z "$dns_server" ]]; then
    echo -e "${RED}Error: DNS server cannot be empty!${NC}"
    exit 1
fi

# Validate that the input is a valid IP address
if ! [[ "$dns_server" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo -e "${RED}Invalid IP address format. Please provide a valid IP address.${NC}"
    exit 1
fi

# Add the DNS server to /etc/resolvconf/resolv.conf.d/head
if grep -q "nameserver $dns_server" /etc/resolvconf/resolv.conf.d/head; then
    echo -e "${YELLOW}The DNS server $dns_server is already present in /etc/resolvconf/resolv.conf.d/head.${NC}"
else
    echo -e "${YELLOW}Adding DNS server $dns_server to /etc/resolvconf/resolv.conf.d/head...${NC}"
    echo "nameserver $dns_server" | sudo tee -a /etc/resolvconf/resolv.conf.d/head >/dev/null

    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}DNS server $dns_server added successfully to /etc/resolvconf/resolv.conf.d/head.${NC}"
    else
        echo -e "${RED}Failed to add the DNS server to /etc/resolvconf/resolv.conf.d/head.${NC}"
        exit 1
    fi
fi

# Apply the changes by updating resolv.conf using resolvconf
echo -e "${YELLOW}Applying changes by regenerating /etc/resolv.conf...${NC}"
sudo resolvconf -u

if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}/etc/resolv.conf updated successfully.${NC}"
else
    echo -e "${RED}Failed to update /etc/resolv.conf.${NC}"
fi

# Display the updated resolv.conf for verification
echo -e "${YELLOW}Updated /etc/resolv.conf:${NC}"
cat /etc/resolv.conf
