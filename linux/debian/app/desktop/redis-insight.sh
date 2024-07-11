#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Error handling function
handle_error() {
    local exit_code=$1
    local command=$2
    local message=$3

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: $command failed - $message${NC}"
        exit $exit_code
    fi
}

# Download RedisInsight
echo -e "${YELLOW}Downloading RedisInsight...${NC}"
wget https://s3.amazonaws.com/redisinsight.download/public/latest/Redis-Insight-linux-amd64.deb -O /tmp/redisinsight.deb
handle_error $? "wget https://s3.amazonaws.com/redisinsight.download/public/latest/Redis-Insight-linux-amd64.deb -O /tmp/redisinsight.deb" "Failed to download RedisInsight"

# Install RedisInsight
echo -e "${YELLOW}Installing RedisInsight...${NC}"
sudo dpkg -i /tmp/redisinsight.deb
handle_error $? "sudo dpkg -i /tmp/redisinsight.deb" "Failed to install RedisInsight"

echo -e "${GREEN}RedisInsight installation complete!${NC}"
