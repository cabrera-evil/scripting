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

# Prompt for repository name
echo -e "${BLUE}Enter the name of the repository:${NC}"
read repo_name

# Find folder with repository name in home directory
cd ~
repo_folder=$(find . -type d -name "$repo_name" 2>/dev/null)

# Check if repository folder was found
if [ -z "$repo_folder" ]; then
    echo -e "${RED}Error: Repository folder not found.${NC}"
    exit 1
fi

# Change to repository folder
cd "$repo_folder"
handle_error $? "cd" "Failed to change to repository folder"

# Prompt for commit ID and reset to that commit
echo -e "${BLUE}Enter the commit ID you want to reset to:${NC}"
read commit_id
git reset $commit_id --hard
handle_error $? "git reset" "Failed to reset to commit"

# Prompt for branch and push
echo -e "${BLUE}Enter the name of the branch you want to push to:${NC}"
read branch_name
git push -f origin $branch_name
handle_error $? "git push" "Failed to push to branch"

echo -e "${GREEN}Repository reset and pushed successfully!${NC}"
