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
    kubectl delete job.batch/rancher-post-delete -n cattle-system
else
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
HOSTNAME="${LOCAL_IP}.sslip.io"
echo -e "${BLUE}Using hostname: ${YELLOW}$HOSTNAME${NC}"

echo -e "${BLUE}Installing cert-manager helm chart...${NC}"
helm repo add jetstack https://charts.jetstack.io

echo -e "${BLUE}Installing Rancher helm chart...${NC}"
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

echo -e "${BLUE}Updating helm repositories...${NC}"
helm repo update

echo -e "${BLUE}Installing cert-manager...${NC}"
if ! kubectl get ns cert-manager >/dev/null 2>&1; then
    helm install cert-manager jetstack/cert-manager \
        --namespace cert-manager \
        --create-namespace \
        --version v1.17.0 \
        --set crds.enabled=true
else
    echo -e "${GREEN}Cert-manager is already installed.${NC}"
fi

echo -e "${BLUE}Installing Rancher...${NC}"
helm install rancher rancher-latest/rancher \
    --namespace cattle-system \
    --create-namespace \
    --set hostname=$HOSTNAME \
    --set ingress.tls.source=letsEncrypt \
    --set letsEncrypt.email=info@cabrera-dev.com \
    --set replicas=1 \
    --set bootstrapPassword=admin

echo -e "${BLUE}Waiting for all Rancher pods to be ready...${NC}"
while true; do
    READY_COUNT=$(kubectl get pods -n cattle-system -l app=rancher -o json | jq '[.items[] | select(.status.phase == "Running") | select(.status.containerStatuses[]?.ready == true)] | length')
    TOTAL_COUNT=$(kubectl get pods -n cattle-system -l app=rancher --no-headers | wc -l)

    if [[ "$READY_COUNT" -eq "$TOTAL_COUNT" && "$TOTAL_COUNT" -gt 0 ]]; then
        echo -e "${GREEN}All Rancher pods are ready (${READY_COUNT}/${TOTAL_COUNT}).${NC}"
        break
    else
        echo -e "${YELLOW}Rancher pods ready: ${READY_COUNT}/${TOTAL_COUNT}. Waiting...${NC}"
        sleep 5
    fi
done

echo -e "${BLUE}Verifying Rancher deployment availability...${NC}"
kubectl rollout status deployment rancher -n cattle-system

echo -e "${YELLOW}Access Rancher at: https://$HOSTNAME${NC}"
echo -e "${GREEN}Rancher installation complete!${NC}"
