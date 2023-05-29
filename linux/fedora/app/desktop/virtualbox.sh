#!/bin/bash

# Function to check command success
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Step 1: Install Dependencies
sudo dnf -y install @development-tools
check_command_success "Failed to install development tools"
sudo dnf -y install kernel-headers kernel-devel dkms elfutils-libelf-devel qt5-qtx11extras
check_command_success "Failed to install kernel headers and other dependencies"

# Step 2: Add VirtualBox RPM repository
VERSION=38
cat <<EOF | sudo tee /etc/yum.repos.d/virtualbox.repo 
[virtualbox]
name=Fedora VirtualBox Repo
baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/$VERSION/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.virtualbox.org/download/oracle_vbox_2016.asc
EOF
check_command_success "Failed to add VirtualBox RPM repository"

# Step 3: Import VirtualBox GPG Key
sudo dnf -y search virtualbox
check_command_success "Failed to import VirtualBox GPG key"

# Step 4: Install VirtualBox 7.0 on Fedora
sudo dnf -y install VirtualBox-7.0
check_command_success "Failed to install VirtualBox"

# Step 5: Add your user to the vboxusers group
sudo usermod -a -G vboxusers $USER
newgrp vboxusers
id $USER

# Display success message
echo "VirtualBox installation completed successfully."
