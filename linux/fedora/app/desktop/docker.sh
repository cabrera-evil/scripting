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

# Enable kvm for virtualization
echo -e "${BLUE}Enabling kvm for virtualization...${NC}"
# Step 1: Check Intel VT or AMD-V Virtualization extensions
echo "Checking Virtualization extensions..."
if cat /proc/cpuinfo | egrep -q "vmx|svm"; then
    echo "Virtualization extensions found."
else
    handle_error 1 "Virtualization Check" "Virtualization extensions not found. Please check your CPU and BIOS settings."
fi

# Step 2: Install KVM / QEMU on Fedora
echo "Installing virtualization packages..."
sudo dnf -y install bridge-utils libvirt virt-install qemu-kvm
handle_error $? "Package Installation" "Failed to install virtualization packages."

echo "Verifying Kernel modules..."
if lsmod | grep -q kvm; then
    echo "Kernel modules are loaded."
else
    handle_error 1 "Kernel Module Verification" "Kernel modules are not loaded. Please check the installation."
fi

echo "Installing additional tools..."
sudo dnf install libvirt-devel virt-top libguestfs-tools guestfs-tools
handle_error $? "Additional Tools Installation" "Failed to install additional tools."

# Step 3: Start and enable KVM daemon
echo "Starting KVM daemon..."
sudo systemctl start libvirtd
handle_error $? "KVM Daemon Start" "Failed to start KVM daemon."

echo "Enabling KVM daemon to start on boot..."
sudo systemctl enable libvirtd
handle_error $? "KVM Daemon Enable" "Failed to enable KVM daemon."

echo "KVM setup completed successfully."

# Remove older versions of Docker
echo -e "${BLUE}Removing older versions of Docker...${NC}"
sudo dnf remove -y docker docker-engine docker-client docker-common docker-logrotate docker-latest
handle_error $? "sudo dnf remove" "Failed to remove older versions of Docker"

# Install Docker Engine
echo -e "${BLUE}Installing Docker Engine...${NC}"
sudo dnf -y install dnf-plugins-core
handle_error $? "sudo dnf install" "Failed to install dnf-plugins-core"
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
handle_error $? "sudo dnf config-manager" "Failed to add Docker repository"
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
handle_error $? "sudo dnf install" "Failed to install Docker Engine"

# Start and enable Docker service
echo -e "${BLUE}Starting and enabling Docker service...${NC}"
sudo systemctl start docker
handle_error $? "sudo systemctl start" "Failed to start Docker service"
sudo systemctl enable docker
handle_error $? "sudo systemctl enable" "Failed to enable Docker service"

#Add User To Docker
echo -e "${BLUE}Adding user to Docker organization${NC}"
sudo usermod -aG docker $USER

# Download Docker Desktop RPM package
download_url="https://desktop.docker.com/linux/main/amd64/docker-desktop-4.19.0-x86_64.rpm"
download_file="/tmp/docker-desktop.rpm"

echo -e "${BLUE}Downloading Docker Desktop RPM package...${NC}"
if ! curl -L "$download_url" -o "$download_file"; then
    handle_error 1 "curl" "Failed to download Docker Desktop RPM package"
fi

# Install Docker Desktop from the downloaded file
if [ -f "$download_file" ]; then
    echo -e "${BLUE}Installing Docker Desktop...${NC}"
    sudo dnf install -y "$download_file"
    handle_error $? "sudo dnf install" "Failed to install Docker Desktop"
    echo -e "${GREEN}Docker Desktop installed successfully.${NC}"
    rm "$download_file"  # Remove the downloaded file
else
    handle_error 1 "file check" "The downloaded Docker Desktop RPM file does not exist"
fi

# Install docker-compose
echo -e "${BLUE}Installing docker-compose...${NC}"
sudo dnf install docker-compose -y
handle_error $? "Install docker-compose" "Failed to install docker-compose"

# Enable keyring for docker hub
# Install the necessary package to use the pass credential store
sudo dnf install -y pass gnupg2
handle_error $? "Installation" "Failed to install required packages."

# Generate a new GPG key
gpg --generate-key
handle_error $? "GPG Key Generation" "Failed to generate GPG key."

# Get the generated public GPG key ID
gpg_key=$(gpg --list-keys --keyid-format LONG | grep pub | awk '{print $2}' | cut -d'/' -f2)
handle_error $? "GPG Key Retrieval" "Failed to retrieve GPG key."

# Initialize pass using the generated public GPG key
pass init "$gpg_key"
handle_error $? "Pass Initialization" "Failed to initialize pass."

# Restart the Docker service to apply the changes
sudo systemctl restart docker
handle_error $? "Docker Service Restart" "Failed to restart Docker service."

echo -e "${GREEN}Pass credential store configured successfully.${NC}"