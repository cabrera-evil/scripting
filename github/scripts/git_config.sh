#!/bin/sh

# Get the username from user input
echo "Enter GitHub username: "
read github_username

# Get the user email from user input
echo "Enter GitHub email: "
read github_email

# Gitconfig setup
git config --global user.name "$github_username"
git config --global user.email "$github_email"