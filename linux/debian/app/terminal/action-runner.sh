#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Define variables
RUNNER_VERSION="2.323.0"
FILENAME="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
DOWNLOAD_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${FILENAME}"
EXPECTED_HASH="0dbc9bf5a58620fc52cb6cc0448abcca964a8d74b5f39773b7afcad9ab691e19"
TMP_PATH="/tmp/${FILENAME}"
DEST_DIR="/usr/local/actions-runner"

# Download the runner to /tmp
echo -e "${BLUE}Downloading GitHub Actions Runner ${RUNNER_VERSION} to /tmp...${NC}"
wget -O "$TMP_PATH" "$DOWNLOAD_URL"

# Validate the hash
echo -e "${BLUE}Validating SHA-256 checksum...${NC}"
echo "${EXPECTED_HASH}  ${TMP_PATH}" | shasum -a 256 -c
if [ $? -ne 0 ]; then
    echo -e "${RED}Checksum verification failed! Aborting.${NC}"
    exit 1
fi

# Create destination directory
echo -e "${BLUE}Creating destination directory '${DEST_DIR}'...${NC}"
sudo mkdir -p "$DEST_DIR"

# Extract the runner package
echo -e "${BLUE}Extracting runner package into ${DEST_DIR}...${NC}"
sudo tar xzf "$TMP_PATH" -C "$DEST_DIR"

echo -e "${GREEN}GitHub Actions Runner ${RUNNER_VERSION} setup complete in '${DEST_DIR}'!${NC}"
