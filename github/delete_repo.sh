#!/bin/sh

# Get the repository name from user input
echo "Enter repository name: "
read repo_name

# Get the GitHub API token from user input
echo "Enter GitHub API token: "
read api_token

# Delete the repository using the GitHub API
curl --header "Authorization: token $api_token" --request DELETE https://api.github.com/repos/"$github_username"/"$repo_name"

# Remove the local repository directory
rm -rf ~/git/"$repo_name"
