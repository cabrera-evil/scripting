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

# Get the email from git config
email=$(git config user.email)
key_name="id_ed25519"

# Throw error if email is not set
if [ -z "$email" ]; then
    echo -e "${RED}Error: Git email is not set. Please set it using 'git config --global user.email <email> or run github-user.sh script.${NC}" >&2
    exit 1
fi

# Generate SSH key
ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/$key_name
handle_error $? "ssh-keygen" "Failed to generate SSH key"

# Add SSH key to SSH agent
eval "$(ssh-agent -s)"
handle_error $? "ssh-agent" "Failed to start SSH agent"
ssh-add ~/.ssh/$key_name
handle_error $? "ssh-add" "Failed to add SSH key to agent"

# Install xclip if not already installed
if ! command -v xclip &>/dev/null; then
    sudo apt install xclip -y
    handle_error $? "apt" "Failed to install xclip"
fi

# Copy public key to clipboard
cat ~/.ssh/$key_name.pub | xclip -selection clipboard
handle_error $? "xclip" "Failed to copy public key to clipboard"

# Display public key
echo -e "${GREEN}Public key:${NC}"
cat ~/.ssh/$key_name.pub

# Instructions for adding SSH key to GitHub
echo -e "${BLUE}The public key has been copied to the clipboard. Please add it to your GitHub account.${NC}"

# Open GitHub SSH settings in default browser
read -p "Press Enter to open GitHub SSH settings in your default browser..."
xdg-open "https://github.com/settings/ssh/new"

echo -e "${GREEN}SSH key has been generated and added to the SSH agent.${NC}"
