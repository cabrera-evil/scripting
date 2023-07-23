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

# Download and install kubectl
echo -e "${BLUE}Installing kubectl...${NC}"
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum install -y kubectl
handle_error $? "sudo yum install" "Failed to install kubectl."

# Download and install minikube
echo -e "${BLUE}Installing minikube...${NC}"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
handle_error $? "curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm" "Failed to download minikube."
sudo rpm -Uvh minikube-latest.x86_64.rpm
handle_error $? "sudo rpm -Uvh minikube-latest.x86_64.rpm" "Failed to install minikube."

# Start minikube
echo -e "${BLUE}Starting minikube...${NC}"
minikube start &
handle_error $? "minikube start" "Failed to start minikube."

echo -e "${GREEN}Kubernetes installation complete!${NC}"