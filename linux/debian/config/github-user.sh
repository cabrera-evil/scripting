#!/bin/sh

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Get the username from user input
echo -e "${BLUE}Enter GitHub username:${NC}"
read username

# Get the user email from user input
echo -e "${BLUE}Enter GitHub email:${NC}"
read email

# Gitconfig setup
echo -e "${BLUE}Setting up GitHub username and email...${NC}"
git config --global user.name "$username"
git config --global user.email "$email"

echo -e "${GREEN}GitHub username and email have been set.${NC}"
