#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Install required packages
sudo apt install -y pass gnupg2

# Generate a new GPG key
gpg --generate-key

# Get the generated public GPG key ID
gpg_key=$(gpg --list-keys --keyid-format LONG | grep pub | awk '{print $2}' | cut -d'/' -f2)

# Initialize pass using the generated public GPG key
pass init "$gpg_key"

echo -e "${GREEN}Docker Hub credentials are now stored in the pass credential store.${NC}"
