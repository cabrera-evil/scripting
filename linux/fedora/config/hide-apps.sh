#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Error handling function
handle_error() {
    local exit_code=$1
    local command=$2
    local message=$3

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: $command failed - $message${NC}" >&2
        exit $exit_code
    fi
}

# Add "OnlyShowIn=GNOME" to GNOME desktop files
find /usr/share/applications/org.gnome.*.desktop -exec bash -c 'echo "OnlyShowIn=GNOME" >> {}' \;
handle_error $? "find GNOME desktop files" "Failed to add 'OnlyShowIn=GNOME' to GNOME desktop files"

# Add "OnlyShowIn=KDE" to KDE desktop files
find /usr/share/applications/org.kde.*.desktop -exec bash -c 'echo "OnlyShowIn=KDE" >> {}' \;
handle_error $? "find KDE desktop files" "Failed to add 'OnlyShowIn=KDE' to KDE desktop files"

echo -e "${GREEN}Desktop files updated successfully!${NC}"
