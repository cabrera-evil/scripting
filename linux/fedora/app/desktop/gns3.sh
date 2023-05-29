#!/bin/bash

# Function to check command success
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Update the system
sudo dnf update -y
check_command_success "Failed to update the system."

# Install necessary dependencies
sudo dnf install -y wget python3 python3-pip python3-devel cmake qt5-qtbase-devel qt5-qtmultimedia-devel qt5-qtsvg-devel libnetfilter_queue-devel libpcap-devel libpng-devel openssl-devel libssh-devel libssh2-devel libyaml-devel snappy-devel lld flex bison autoconf automake libtool make pkgconf swig zlib-devel curl-devel ncurses-devel
check_command_success "Failed to install necessary dependencies."

# Install libvirt for QEMU/KVM integration (optional)
sudo dnf install -y libvirt libvirt-devel
check_command_success "Failed to install libvirt."

# Install Dynamips
wget -O dynamips.tar.gz https://github.com/GNS3/dynamips/archive/master.tar.gz
check_command_success "Failed to download Dynamips source code."
tar -xf dynamips.tar.gz
cd dynamips-master
mkdir build
cd build
cmake ..
make
sudo make install
check_command_success "Failed to build and install Dynamips."
cd ../..

# Install IOU
wget -O iouyap.tar.gz https://github.com/GNS3/iouyap/archive/master.tar.gz
check_command_success "Failed to download iouyap source code."
tar -xf iouyap.tar.gz
cd iouyap-master
make
sudo make install
check_command_success "Failed to build and install iouyap."
cd ..

# Install VPCS
wget -O vpcs.tar.gz https://github.com/GNS3/vpcs/archive/master.tar.gz
check_command_success "Failed to download VPCS source code."
tar -xf vpcs.tar.gz
cd vpcs-master/src
./mk.sh
sudo cp vpcs /usr/local/bin/
check_command_success "Failed to build and install VPCS."
cd ../..

# Install GNS3
pip3 install gns3-server gns3-gui
check_command_success "Failed to install GNS3."

# Create symbolic link for Qt 5.15 (may not be necessary on Fedora)
sudo ln -s /usr/lib64/qt5/plugins/platforms/ /usr/lib/qt5/plugins/

# Start GNS3 server
# gns3server
# check_command_success "Failed to start GNS3 server."

# Open GNS3 GUI
# gns3
# check_command_success "Failed to open GNS3 GUI."

echo "GNS3 installation completed successfully."
