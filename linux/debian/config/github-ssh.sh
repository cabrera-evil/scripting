#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Get email from Git config
email=$(git config user.email)

# Ask if the user wants to override the email
if [ -z "$email" ]; then
    read -rp "Git email is not set. Enter your GitHub email: " email
else
    echo -e "${BLUE}Detected Git email: $email${NC}"
    read -rp "Do you want to override this email? (y/N): " override_email
    if [[ "$override_email" =~ ^[Yy]$ ]]; then
        read -rp "Enter new GitHub email: " email
    fi
fi

# Ensure email is set
if [ -z "$email" ]; then
    echo -e "${RED}Error: Email cannot be empty.${NC}" >&2
    exit 1
fi

# Default SSH key name
default_key_name="id_ed25519"
key_path="$HOME/.ssh/$default_key_name"

# Ask if the user wants to use a different SSH key name
echo -e "${BLUE}Default SSH key name: $default_key_name${NC}"
read -rp "Do you want to use a different key name? (y/N): " override_key_name
if [[ "$override_key_name" =~ ^[Yy]$ ]]; then
    read -rp "Enter SSH key name: " key_name
    key_path="$HOME/.ssh/$key_name"
else
    key_name=$default_key_name
fi

# Generate SSH key
echo -e "${BLUE}Generating SSH key...${NC}"
ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N ""

# Ensure SSH agent is running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    echo -e "${BLUE}Starting SSH agent...${NC}"
    eval "$(ssh-agent -s)"
fi

# Add SSH key to SSH agent
ssh-add "$key_path"

# Install xclip if not available
if ! command -v xclip &>/dev/null; then
    echo -e "${BLUE}Installing xclip...${NC}"
    sudo apt install xclip -y
fi

# Copy public key to clipboard
cat "$key_path.pub" | xclip -selection clipboard

# Display public key
echo -e "${GREEN}Public key:${NC}"
cat "$key_path.pub"

# Instructions for adding SSH key to GitHub
echo -e "${BLUE}The public key has been copied to the clipboard. Please add it to your GitHub account.${NC}"

# Open GitHub SSH settings in default browser
read -rp "Press Enter to open GitHub SSH settings in your default browser..."
xdg-open "https://github.com/settings/ssh/new"

echo -e "${GREEN}SSH key has been generated and added to the SSH agent.${NC}"
