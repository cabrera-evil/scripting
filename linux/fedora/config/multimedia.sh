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

# Step 1: Configure RPM Fusion
echo "Configuring RPM Fusion..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
handle_error $? "RPM Fusion Configuration" "Failed to configure RPM Fusion."

# Step 2: Switch to full ffmpeg
echo "Switching to full ffmpeg..."
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
handle_error $? "ffmpeg Switch" "Failed to switch to full ffmpeg."

# Step 3: Install additional codecs
echo "Installing additional codecs..."
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
handle_error $? "Multimedia Codecs Installation" "Failed to install additional codecs."

echo "Installing sound-and-video complement packages..."
sudo dnf groupupdate -y sound-and-video
handle_error $? "Sound and Video Packages Installation" "Failed to install sound-and-video complement packages."

echo "Multimedia setup completed successfully."
exit 0
