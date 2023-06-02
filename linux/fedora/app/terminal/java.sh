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

# Install OpenJDK 17 on Fedora 38/37/36/35/34/33
echo -e "${BLUE}Installing Java on Fedora...${NC}"
echo -e "${BLUE}Installing OpenJDK 17...${NC}"

# Install dependencies
sudo dnf -y install curl wget
handle_error $? "Dependency installation" "Failed to install dependencies."

# Download OpenJDK 17
wget -P /tmp https://download.java.net/openjdk/jdk17/ri/openjdk-17+35_linux-x64_bin.tar.gz
handle_error $? "OpenJDK 17 download" "Failed to download OpenJDK 17."

# Extract OpenJDK 17
tar xvf /tmp/openjdk-17+35_linux-x64_bin.tar.gz -C /tmp
handle_error $? "OpenJDK 17 extraction" "Failed to extract OpenJDK 17."

# Move to /opt directory
sudo rm -rf /opt/jdk-17
sudo mv /tmp/jdk-17 /opt/
handle_error $? "Move to /opt directory" "Failed to move OpenJDK 17 to /opt directory."

# Configure Java environment
sudo tee /etc/profile.d/jdk17.sh <<EOF
export JAVA_HOME=/opt/jdk-17
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
handle_error $? "Configure Java environment" "Failed to configure Java environment."

# Source profile file
source /etc/profile.d/jdk17.sh

# Confirm Java version
echo -e "${GREEN}OpenJDK 17 installed successfully.${NC}"
echo -e "${GREEN}Java version:${NC}"
echo -e "\$JAVA_HOME: $JAVA_HOME"
java -version
echo

# Install Java SE Development Kit 17 on Fedora
echo -e "${BLUE}Installing Java SE Development Kit 17...${NC}"

# Download RPM package
wget -P /tmp https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm
handle_error $? "Java SE Development Kit 17 download" "Failed to download Java SE Development Kit 17."

# Install RPM package
sudo rpm -Uvh /tmp/jdk-17_linux-x64_bin.rpm
handle_error $? "Java SE Development Kit 17 installation" "Failed to install Java SE Development Kit 17."

# Configure Java environment
cat <<EOF | sudo tee /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/java/default
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
handle_error $? "Configure Java environment" "Failed to configure Java environment."

# Source the file
source /etc/profile.d/jdk.sh

# Confirm Java version
echo -e "${GREEN}Java SE Development Kit 17 installed successfully.${NC}"
echo -e "${GREEN}Java version:${NC}"
java -version
echo
echo -e "${GREEN}Installation complete.${NC}"
