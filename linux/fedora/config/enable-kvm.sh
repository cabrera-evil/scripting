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
exit 0
