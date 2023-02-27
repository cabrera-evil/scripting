#!/bin/sh

# Extract GitHub username from ~/.gitconfig
github_username=$(git config --global user.name)

# Get the repository name from user input
echo "Enter repository name: "
read repo_name

# Create the ~/git directory if it doesn't exist
mkdir -p ~/git

# Clone the repository to the ~/git directory
git clone https://github.com/"$github_username"/"$repo_name" ~/git/"$repo_name"
