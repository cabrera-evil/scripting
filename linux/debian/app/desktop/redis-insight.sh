#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
URL="https://s3.amazonaws.com/redisinsight.download/public/latest/Redis-Insight-linux-amd64.deb"

# Download RedisInsight
echo -e "${BLUE}Downloading RedisInsight...${NC}"
wget -O /tmp/redisinsight.deb "$URL"

# Install RedisInsight
echo -e "${BLUE}Installing RedisInsight...${NC}"
sudo apt install -y /tmp/redisinsight.deb

echo -e "${GREEN}RedisInsight installation complete!${NC}"
