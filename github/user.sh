#!/bin/sh

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

# Get the username from user input
echo -e "${BLUE}Enter GitHub username:${NC}"
read github_username

# Get the user email from user input
echo -e "${BLUE}Enter GitHub email:${NC}"
read github_email

# Gitconfig setup
git config --global user.name "$github_username"
handle_error $? "git config" "Failed to set username"

git config --global user.email "$github_email"
handle_error $? "git config" "Failed to set email"

echo -e "${GREEN}Gitconfig setup successfully!${NC}"