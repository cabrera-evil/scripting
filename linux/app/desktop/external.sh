#!/bin/bash

# Colors for terminal output
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[1;33m'
blue='\e[0;34m'
NC='\e[0m' # No Color

# Install Termius
clear
echo -e "${blue}Downloading Termius...${NC}"
if ! wget -O /tmp/termius.deb "https://www.termius.com/download/linux/Termius.deb?_gl=1*i4xdht*_ga*MzQ0ODY0MDczLjE2MTY2MjI5ODE.*_ga_ZPQLW2Q816*MTY1NjM4MDU2Mi44My4xLjE2NTYzODIyNzguMA.."; then
    echo -e "${red}Failed to download Termius.${NC}"
    exit 1
fi

echo -e "${blue}Installing Termius...${NC}"
if ! sudo dpkg -i /tmp/termius.deb; then
    echo -e "${red}Failed to install Termius.${NC}"
    exit 1
fi

echo -e "${green}Termius installation complete!${NC}"

# Install MongoDB Compass
clear
echo -e "${blue}Downloading MongoDB Compass...${NC}"
if ! wget -O /tmp/mongodb_compass.deb "https://downloads.mongodb.com/compass/mongodb-compass_1.35.0_amd64.deb"; then
    echo -e "${red}Failed to download MongoDB Compass.${NC}"
    exit 1
fi

echo -e "${blue}Installing MongoDB Compass...${NC}"
if ! sudo dpkg -i /tmp/mongodb_compass.deb; then
    echo -e "${red}MongoDB Compass installed with some errors (might be normal).${NC}"
fi

echo -e "${green}MongoDB Compass installation complete!${NC}"

# Install Brave Browser
clear
echo -e "${blue}Downloading Brave Browser...${NC}"
sudo apt install apt-transport-https curl -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y
sudo apt install brave-browser -y

# Install Spotify
clear
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client -y

# Install Discord
clear
echo -e "${blue}Downloading Discord...${NC}"
if ! wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"; then
    echo -e "${red}Failed to download Discord.${NC}"
    exit 1
fi

echo -e "${blue}Installing Discord...${NC}"
if ! sudo dpkg -i /tmp/discord.deb; then
    echo -e "${red}Discord installed with some errors (might be normal).${NC}"
fi

echo -e "${green}Discord installation complete!${NC}"

# Install Code
clear
echo -e "${blue}Downloading Code...${NC}"
if ! wget -O /tmp/code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; then
    echo -e "${red}Failed to download Code.${NC}"
    exit 1
fi

echo -e "${blue}Installing Code...${NC}"
if ! sudo dpkg -i /tmp/code.deb; then
    echo -e "${red}Failed to install Code.${NC}"
    exit 1
fi

echo -e "${green}Code installation complete!${NC}"