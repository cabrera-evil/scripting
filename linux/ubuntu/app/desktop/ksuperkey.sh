#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Install ksuperkey
echo -e "${BLUE}Installing ksuperkey...${NC}"
sudo apt-get update
sudo apt-get install -y cmake build-essential qtbase5-dev libx11-dev libxtst-dev pkg-config
git clone https://github.com/hanschen/ksuperkey.git
cd ksuperkey
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install
cd ../..
rm -rf ksuperkey
echo -e "${GREEN}ksuperkey installed.${NC}"
