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

# Input email and key name
read -p "Enter your email for GitHub: " email
read -p "Enter the name for your SSH key: " key_name

# Generate SSH key
ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/$key_name
handle_error $? "ssh-keygen" "Failed to generate SSH key"

# Add SSH key to SSH agent
eval "$(ssh-agent -s)"
handle_error $? "ssh-agent" "Failed to start SSH agent"
ssh-add ~/.ssh/$key_name
handle_error $? "ssh-add" "Failed to add SSH key to agent"

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

# Clone a GitHub repository to test SSH connection
read -p "Do you want to clone a GitHub repository to test the SSH connection? (y/n): " choice
if [ "$choice" == "y" ]; then
    read -p "Enter the repository URL: " repository_url
    git clone $repository_url
fi
