#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# Uninstall any previous versions of Rancher
echo -e "${BLUE}Uninstalling previous versions of Rancher...${NC}"
if kubectl get ns cattle-system >/dev/null 2>&1; then
    echo -e "${YELLOW}Deleting existing Rancher installation...${NC}"
    helm uninstall rancher --namespace cattle-system
else
    echo -e "${GREEN}No previous Rancher installation found.${NC}"
fi

# Delete rancher post-delete resources
if kubectl get job.batch/rancher-post-delete -n cattle-system >/dev/null 2>&1; then
    echo -e "${YELLOW}Deleting rancher post-delete resources...${NC}"
    k delete job.batch/rancher-post-delete -n cattle-systeelse
    echo -e "${GREEN}No rancher post-delete resources found.${NC}"
fi

# Get public IP
echo -e "${BLUE}Detecting public IP...${NC}"
PUBLIC_IP=$(curl -s https://ifconfig.me || curl -s https://ipinfo.io/ip)
if [ -z "$PUBLIC_IP" ]; then
    echo -e "${RED}Failed to detect public IP.${NC}"
    exit 1
fi
PRIVATE_IP=$(hostname -I | awk '{print $1}')
LOCAL_IP=127.0.0.1

# Generate hostname with sslip.io
HOSTNAME="${PUBLIC_IP}.sslip.io"
echo -e "${BLUE}Using hostname: ${YELLOW}$HOSTNAME${NC}"

echo -e "${BLUE}Installing Rancher helm chart...${NC}"
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

echo -e "${BLUE}Installing cert-manager helm chart...${NC}"
helm repo add jetstack https://charts.jetstack.io

echo -e "${BLUE}Creating cattle-system namespace...${NC}"
kubectl create namespace cattle-system

echo -e "${BLUE}Updating helm repositories...${NC}"
helm repo update

echo -e "${BLUE}Installing cert-manager...${NC}"
helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace

echo -e "${BLUE}Installing Rancher...${NC}"
helm install rancher rancher-latest/rancher \
    --namespace cattle-system \
    --set hostname=$HOSTNAME \
    --set replicas=1 \
    --set bootstrapPassword=admin

echo -e "${BLUE}Waiting for Rancher to be ready...${NC}"
while [[ $(kubectl get pods -n cattle-system -l app=rancher -o jsonpath='{.items[0].status.containerStatuses[0].ready}') != "true" ]]; do
    echo -e "${YELLOW}Rancher is not ready yet...${NC}"
    sleep 5
done

echo -e "${YELLOW}Access Rancher at: https://$HOSTNAME${NC}"
echo -e "${GREEN}Rancher installation complete!${NC}"
