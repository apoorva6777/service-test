#!/bin/bash

echo "Starting Monitoring deployments"

echo "Adding Helm repo for kube prometheus stack"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

echo "Creating namespace monitoring"

kubectl create ns monitoring

echo "Installing kube-prometheus-stack base components"

helm install my-kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring

kubectl apply -f ../tools/monitoring/prometheus-service.yaml
kubectl apply -f ../tools/monitoring/grafana-service.yaml

 
NAMESPACE="monitoring"
GRAFANA_SVC_NAME="grafana-lb"
PROMETHEUS_SVC_NAME="prometheus-lb"
MAX_RETRIES=120  # Maximum number of retries (e.g., 120 retries = 20 minutes)
RETRY_INTERVAL=10  # Interval between retries (in seconds)
 
retries=0
 
while true; do
    grafana_external_ip=$(kubectl get svc "$GRAFANA_SVC_NAME" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    prometheus_external_ip=$(kubectl get svc "$PROMETHEUS_SVC_NAME" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
 
    if [[ -n "$grafana_external_ip" && -n "$prometheus_external_ip" ]]; then
        break
    else
        retries=$((retries+1))
        if [[ $retries -eq $MAX_RETRIES ]]; then
            echo "Maximum retries reached. Failed to get external IPs for $GRAFANA_SVC_NAME and $PROMETHEUS_SVC_NAME."
            exit 1
        fi
        echo "Waiting for external IP assignment (retry $retries/$MAX_RETRIES)..."
        sleep $RETRY_INTERVAL
    fi
done


GRAFANA_EXTERNAL_IP="$grafana_external_ip"
PROMETHEUS_EXTERNAL_IP="$prometheus_external_ip"






