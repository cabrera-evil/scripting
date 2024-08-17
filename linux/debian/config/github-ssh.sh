#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

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

# Add SSH key to SSH agent
eval "$(ssh-agent -s)"

ssh-add ~/.ssh/$key_name

# Install xclip if not already installed
if ! command -v xclip &>/dev/null; then
    sudo apt install xclip -y
fi

# Copy public key to clipboard
cat ~/.ssh/$key_name.pub | xclip -selection clipboard

# Display public key
echo -e "${GREEN}Public key:${NC}"
cat ~/.ssh/$key_name.pub

# Instructions for adding SSH key to GitHub
echo -e "${BLUE}The public key has been copied to the clipboard. Please add it to your GitHub account.${NC}"

# Open GitHub SSH settings in default browser
read -p "Press Enter to open GitHub SSH settings in your default browser..."
xdg-open "https://github.com/settings/ssh/new"

echo -e "${GREEN}SSH key has been generated and added to the SSH agent.${NC}"
