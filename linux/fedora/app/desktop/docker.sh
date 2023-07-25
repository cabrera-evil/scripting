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

# Download Docker Desktop RPM package
download_url="https://desktop.docker.com/linux/main/amd64/docker-desktop-4.21.1-x86_64.rpm"
download_file="/tmp/docker-desktop.rpm"

# Setup Docker repository
sudo dnf -y install dnf-plugins-core
handle_error $? "sudo dnf install" "Failed to install dnf-plugins-core"
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
handle_error $? "sudo dnf config-manager" "Failed to add Docker repository"

echo -e "${BLUE}Downloading Docker Desktop RPM package...${NC}"
if ! curl -L "$download_url" -o "$download_file"; then
    handle_error 1 "curl" "Failed to download Docker Desktop RPM package"
fi

# Install Docker Desktop from the downloaded file
if [ -f "$download_file" ]; then
    echo -e "${BLUE}Installing Docker Desktop...${NC}"
    sudo dnf install -y "$download_file"
    handle_error $? "sudo dnf install" "Failed to install Docker Desktop"
    echo -e "${GREEN}Docker Desktop installed successfully.${NC}"
    rm "$download_file" # Remove the downloaded file
else
    handle_error 1 "file check" "The downloaded Docker Desktop RPM file does not exist"
fi

#Add User To Docker
echo -e "${BLUE}Adding user to Docker organization${NC}"
sudo usermod -aG docker $USER

# Ask for user input to configure docker credential store
echo -e "${BLUE}Do you want to configure docker credential store?${NC}"
select yn in "Yes" "No"; do
    case $yn in
    Yes)
        echo -e "${BLUE}Configuring docker credential store...${NC}"
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

        # Restart the Docker service to apply the changes
        sudo systemctl restart docker
        handle_error $? "Docker Service Restart" "Failed to restart Docker service."

        echo -e "${GREEN}Pass credential store configured successfully.${NC}"
        break
        ;;
    No) break ;;
    esac
done

echo -e "${GREEN}Docker Desktop installed successfully.${NC}"
