#!/bin/bash

# Docker Install
echo -e "\e[1mInstalling Docker...\e[0m"
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Docker GPG
echo -e "\e[1mAdding Docker's GPG key...\e[0m"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Docker Repository
echo -e "\e[1mAdding Docker's repository...\e[0m"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker Engine
echo -e "\e[1mInstalling Docker Engine...\e[0m"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Docker Test
echo -e "\e[1mRunning a Docker test...\e[0m"
sudo docker run hello-world
