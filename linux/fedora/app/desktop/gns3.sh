#!/bin/bash

# Function to check command success
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Step 1: Install Dependency packages and Wireshark
sudo dnf -y install git gcc cmake flex bison
check_command_success "Failed to install dependency packages"
sudo dnf -y install elfutils-libelf-devel libuuid-devel libpcap-devel
check_command_success "Failed to install dependency packages"
sudo dnf -y install python3-tornado python3-netifaces python3-devel python-pip python3-setuptools python3-PyQt4 python3-zmq
check_command_success "Failed to install dependency packages"
sudo dnf -y install wireshark
check_command_success "Failed to install Wireshark"

# Step 2: Install GNS3 GUI and Server
sudo dnf -y install gns3-server gns3-gui
check_command_success "Failed to install GNS3 GUI and Server"

# Step 3: Install Dynamips and vpcs
git clone https://github.com/GNS3/dynamips
check_command_success "Failed to clone Dynamips repository"
cd dynamips
mkdir build
cd build
cmake ..
check_command_success "Failed to build Dynamips"
sudo make install
check_command_success "Failed to install Dynamips"

# Confirm binary location
which dynamips

# Install vpcs
wget https://liquidtelecom.dl.sourceforge.net/project/vpcs/0.8/vpcs_0.8b_Linux64
check_command_success "Failed to download vpcs"
mv vpcs_0.8b_Linux64 vpcs
chmod +x vpcs
sudo cp vpcs /usr/local/bin/

# Confirm vpcs version
vpcs -v

# Step 4: Add support for KVM / QEMU (Optional)
# Please follow separate instructions to install KVM on Fedora

# Step 5: Setup IOU support
git clone http://github.com/ndevilla/iniparser.git
check_command_success "Failed to clone iniparser repository"
cd iniparser
make
check_command_success "Failed to build iniparser"
sudo cp libiniparser.* /usr/lib/
sudo cp src/iniparser.h /usr/local/include
sudo cp src/dictionary.h /usr/local/include
cd ..

# Step 6: Add Support for Docker (Optional)
# Please follow separate instructions to install Docker on Fedora
# Don't forget to add your user to the docker group after starting the service
sudo usermod -a -G docker $(whoami)
check_command_success "Failed to add user to docker group"
