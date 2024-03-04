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

# Enable keyring for docker hub
# Install the necessary package to use the pass credential store
sudo dnf install -y pass gnupg2
handle_error $? "Installation" "Failed to install required packages."

# Generate a new GPG key
gpg --generate-key
handle_error $? "GPG Key Generation" "Failed to generate GPG key."

# Get the generated public GPG key ID
gpg_key=$(gpg --list-keys --keyid-format LONG | grep pub | awk '{print $2}' | cut -d'/' -f2)
handle_error $? "GPG Key Retrieval" "Failed to retrieve GPG key."

# Initialize pass using the generated public GPG key
pass init "$gpg_key"
handle_error $? "Pass Initialization" "Failed to initialize pass."

echo -e "${GREEN}Docker Hub credentials are now stored in the pass credential store.${NC}"