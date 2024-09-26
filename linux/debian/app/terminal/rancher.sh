#!/bin/bash

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

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
    --create-namespace \
    --version v1.5.3

echo -e "${BLUE}Installing Rancher...${NC}"
helm install rancher rancher-latest/rancher \
    --namespace cattle-system \
    --set hostname=rancher.sslip.io \
    --set replicas=1 \
    --set bootstrapPassword=admin