#!/bin/sh

# Prompt for repository name
echo "\e[36mEnter the name of the repository:\e[0m"
read repo_name

# Find folder with repository name in home directory
cd ~
repo_folder=$(find . -type d -name "$repo_name" 2>/dev/null)

# Check if repository folder was found
if [ -z "$repo_folder" ]; then
    echo "\e[31mError: Repository folder not found.\e[0m"
    exit 1
fi

# Change to repository folder
cd "$repo_folder"

# Prompt for commit ID and reset to that commit
echo "\e[36mEnter the commit ID you want to reset to:\e[0m"
read commit_id
git reset $commit_id --hard

# Prompt for branch and push
echo "\e[36mEnter the name of the branch you want to push to:\e[0m"
read branch_name
git push -f origin $branch_name
