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

# Extract GitHub username from ~/.gitconfig
github_username=$(git config --global user.name)
handle_error $? "git config" "Failed to extract GitHub username"

# Get the repository name from user input
echo "Enter repository name: "
read repo_name

# Create the ~/git directory if it doesn't exist
mkdir -p ~/git
handle_error $? "mkdir" "Failed to create ~/git directory"

# Clone the repository to the ~/git directory using SSH
git clone git@github.com:"$github_username"/"$repo_name".git ~/git/$github_username/"$repo_name"
handle_error $? "git clone" "Failed to clone the repository"

echo -e "${GREEN}Repository cloned successfully!${NC}"
