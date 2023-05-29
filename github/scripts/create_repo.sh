#!/bin/sh

# Get the repository name from user input
echo "Enter repository name: "
read repo_name

# Get the GitHub API token from user input
echo "Enter GitHub API token: "
read api_token

# Create the repository using the GitHub API
curl --header "Authorization: token $api_token" --header "Content-Type: application/json" --data "{\"name\":\"$repo_name\"}" --request POST https://api.github.com/user/repos

# Clone the repository to the ~/git directory
git clone https://github.com/"$github_username"/"$repo_name" ~/git/"$repo_name"
