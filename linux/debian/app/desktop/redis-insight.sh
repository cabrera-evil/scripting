#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Download RedisInsight
echo -e "${YELLOW}Downloading RedisInsight...${NC}"
wget https://s3.amazonaws.com/redisinsight.download/public/latest/Redis-Insight-linux-amd64.deb -O /tmp/redisinsight.deb

# Install RedisInsight
echo -e "${YELLOW}Installing RedisInsight...${NC}"
sudo dpkg -i /tmp/redisinsight.deb

echo -e "${GREEN}RedisInsight installation complete!${NC}"
