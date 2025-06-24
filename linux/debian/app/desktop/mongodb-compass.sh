#!/bin/bash

# ===============================
# CONFIGURATION AND COLORS
# ===============================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

OS_ARCH="$(dpkg --print-architecture)"
URL="https://downloads.mongodb.com/compass/mongodb-compass_1.46.3_${OS_ARCH}.deb"
DESKTOP_FILE="/usr/share/applications/mongodb-compass.desktop"
EXTRA_FLAGS='--password-store="gnome-libsecret" --ignore-additional-command-line-flags'

# ===============================
# DOWNLOAD AND INSTALL
# ===============================
echo -e "${BLUE}Downloading MongoDB Compass...${NC}"
wget -O /tmp/mongodb-compass.deb "$URL"

echo -e "${BLUE}Installing MongoDB Compass...${NC}"
sudo apt install -y /tmp/mongodb-compass.deb

# ===============================
# PATCH .desktop FILE
# ===============================
echo -e "${BLUE}Patching .desktop launcher...${NC}"

if [[ -f "$DESKTOP_FILE" ]]; then
	sudo sed -i -E \
		"s|^(Exec=.*mongodb-compass)(.*)|\1 ${EXTRA_FLAGS}|" \
		"$DESKTOP_FILE"
	echo -e "${GREEN}Desktop file updated with secure credential flags:${NC}"
	echo -e "${YELLOW}  $EXTRA_FLAGS${NC}"
else
	echo -e "${RED}Desktop file not found: $DESKTOP_FILE${NC}"
fi

echo -e "${GREEN}MongoDB Compass installation complete!${NC}"
