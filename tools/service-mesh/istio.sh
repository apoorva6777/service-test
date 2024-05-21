#!/bin/bash

echo "Starting Istio deployments"
echo "Adding Helm repo for Istio"
helm repo add istio https://istio-release.storage.googleapis.com/charts

kubectl create namespace istio-system

echo "Installing Istio base components"
helm install istio-base istio/base -n istio-system --set defaultRevision=default
helm ls -n istio-system

echo "Installing Istio CNI"
helm install istio-cni istio/cni -n kube-system --wait

echo "Deploying Istiod"
helm install istiod istio/istiod -n istio-system --set istio_cni.enabled=true --wait
helm ls -n istio-system
helm status istiod -n istio-system
kubectl get deployments -n istio-system --output wide
echo "Istiod control plane deployed"

echo "Deploying Istio Ingress Gateway"
helm install istio-ingressgateway istio/gateway -n istio-system --set-string service.annotations."service\.beta\.kubernetes\.io/oci-load-balancer-shape"="flexible" --set-string service.annotations."service\.beta\.kubernetes\.io/oci-load-balancer-shape-flex-min"="20" --set-string service.annotations."service\.beta\.kubernetes\.io/oci-load-balancer-shape-flex-max"="800"
sleep 60
kubectl get svc -n istio-system
echo "Ingress gateway deployed"


 
NAMESPACE="istio-system"
SERVICE_NAME="istio-ingressgateway"
MAX_RETRIES=120  # Maximum number of retries (e.g., 120 retries = 20 minutes)
RETRY_INTERVAL=10  # Interval between retries (in seconds)
 
retries=0
 
while true; do
    external_ip=$(kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
 
    if [[ -n "$external_ip" ]]; then
        break
    else
        retries=$((retries+1))
        if [[ $retries -eq $MAX_RETRIES ]]; then
            echo "Maximum retries reached. Failed to get external IP for $SERVICE_NAME."
            exit 1
        fi
        echo "Waiting for external IP assignment (retry $retries/$MAX_RETRIES)..."
        sleep $RETRY_INTERVAL
    fi
done

ISTIO_EXTERNAL_IP="$external_ip"

# add logic to get external IP of load balancer

echo "Deploying Egress Gateway"
helm install istio-egressgateway istio/gateway -n istio-system --set service.type=ClusterIP
sleep 60
kubectl get svc -n istio-system
echo "Egress gateway deployed"

echo "Istio setup complete"
