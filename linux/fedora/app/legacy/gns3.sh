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
        echo -e "${RED}Error: $command failed - $message${NC}" >&2
        exit $exit_code
    fi
}

# Step 1: Install Dependency packages and Wireshark
echo -e "${BLUE}Step 1: Installing Dependency packages and Wireshark${NC}"
sudo dnf -y install git gcc cmake flex bison
handle_error $? "sudo dnf install" "Failed to install dependency packages"
sudo dnf -y install elfutils-libelf-devel libuuid-devel libpcap-devel
handle_error $? "sudo dnf install" "Failed to install dependency packages"
sudo dnf -y install python3-tornado python3-netifaces python3-devel python-pip python3-setuptools python3-PyQt4 python3-zmq
handle_error $? "sudo dnf install" "Failed to install dependency packages"
sudo dnf -y install wireshark
handle_error $? "sudo dnf install" "Failed to install Wireshark"

# Step 2: Install GNS3 GUI and Server
echo -e "${BLUE}Step 2: Installing GNS3 GUI and Server${NC}"
sudo dnf -y install gns3-server gns3-gui
handle_error $? "sudo dnf install" "Failed to install GNS3 GUI and Server"

# Step 3: Clone Dynamips in /tmp directory
echo -e "${BLUE}Step 3: Cloning Dynamips${NC}"
cd /tmp
git clone https://github.com/GNS3/dynamips
handle_error $? "git clone" "Failed to clone Dynamips repository"
cd dynamips
mkdir build
cd build
cmake ..
handle_error $? "cmake" "Failed to build Dynamips"
sudo make install
handle_error $? "make install" "Failed to install Dynamips"

# Confirm binary location
which dynamips

# Step 4: Install modified VPCS from GNS3 repository
echo -e "${BLUE}Step 4: Installing modified VPCS${NC}"
cd /tmp
git clone https://github.com/GNS3/vpcs.git
handle_error $? "git clone" "Failed to clone VPCS repository"
cd vpcs/src
./mk.sh
handle_error $? "./mk.sh" "Failed to build VPCS"
sudo cp vpcs /usr/local/bin/
handle_error $? "sudo cp" "Failed to copy VPCS binary"

# Confirm VPCS version
vpcs -v

# Step 5: Add support for KVM / QEMU (Optional)
echo -e "${BLUE}Step 5: Setting up KVM support${NC}"
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
# Please follow separate instructions to install KVM on Fedora

# Step 6: Setup IOU support
echo -e "${BLUE}Step 6: Setting up IOU support${NC}"
cd /tmp
git clone http://github.com/ndevilla/iniparser.git
handle_error $? "git clone" "Failed to clone iniparser repository"
cd iniparser
make
handle_error $? "make" "Failed to build iniparser"
sudo cp libiniparser.* /usr/lib/
sudo cp src/iniparser.h /usr/local/include
sudo cp src/dictionary.h /usr/local/include
cd ..

# Step 7: Add Support for Docker (Optional)
# Please follow separate instructions to install Docker on Fedora
# Don't forget to add your user to the docker group after starting the service
sudo usermod -a -G docker $(whoami)
handle_error $? "sudo usermod" "Failed to add user to docker group"

echo -e "${GREEN}GNS3, Dynamips, and VPCS have been successfully installed.${NC}"
