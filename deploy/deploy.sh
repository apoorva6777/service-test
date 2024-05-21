# API Key for Fluent Bit integration with New Relic
API_KEY="829ab611c3bb058571ddc8bf17c18eb1c138NRAL"

cd ..
cd infra
cd registry
terraform init
terraform apply --auto-approve
cd ..
cd ..

REPO_NAME_DETAILS="details-ms"
REPO_NAME_RATINGS="ratings-ms" 
REPO_NAME_PRODUCT="product-ms"

cd apps
cd books

#details
cd details

IMAGE_ID=$(docker build -q -t details:v0.1 .)

# Tag the image
docker tag $IMAGE_ID iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_DETAILS:v0.1

# Push the tagged image 
docker push iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_DETAILS:v0.1

cd ..

cd ratings
IMAGE_ID=$(docker build -q -t ratings:v0.1 .)

# Tag the image 
docker tag $IMAGE_ID iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_RATINGS:v0.1

# Push the tagged image
docker push iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_RATINGS:v0.1

cd ..
cd productpage

# Build the Docker image 
IMAGE_ID=$(docker build -q -t product:v0.1 .)

# Tag the image
docker tag $IMAGE_ID iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_PRODUCT:v0.1 

# Push the tagged image
docker push iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_PRODUCT:v0.1

echo "images pushed"


cd ..
cd ..
cd ..

cd infra/kubernetes
terraform init
terraform apply --auto-approve

echo "Kubernetes cluster and associated resources provisioned"
# CLUSTER CONNECT
CLUSTER_ID=$(terraform output -raw k8s-cluster-id)

NODE_POOL_1=$(terraform output k8s-node-pool-id-one)
NODE_POOL_1="${NODE_POOL_1%\"}"
NODE_POOL_1="${NODE_POOL_1#\"}"

NODE_POOL_2=$(terraform output k8s-node-pool-id-two)
NODE_POOL_2="${NODE_POOL_2%\"}"
NODE_POOL_2="${NODE_POOL_2#\"}"


oci ce cluster create-kubeconfig --cluster-id $CLUSTER_ID --file $HOME/.kube/config --region us-ashburn-1 --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT
export KUBECONFIG=$HOME/.kube/config
kubectl get service
sleep 300
echo "Connection to kubernetes cluster successful"

cd ../..
cd scripts

# Cluster Metric
echo "deploying cluster metric server"
kubectl apply -f metric-server.yaml
sleep 30
kubectl -n kube-system get deployment/metrics-server
echo "cluster metric deployed"


# Cluster Autoscaler
echo "Replacing node pool OCID value in autoscaler yaml"
sed -E "s|<REPLACE_WITH_DYNAMIC_VALUE_NODE_POOL_1>|$NODE_POOL_1|g; s|<REPLACE_WITH_DYNAMIC_VALUE_NODE_POOL_2>|$NODE_POOL_2|g" autoscaler.yaml > cluster-autoscaler.yaml
echo "Deploying cluster autoscaler in cluster"
kubectl apply -f cluster-autoscaler.yaml
sleep 50
kubectl -n kube-system get cm cluster-autoscaler-status -oyaml    
echo "Cluster Autoscaler deployed"

cd ..
cd deploy

# ISTIO
echo "Moving to Istio folder"
source ../tools/service-mesh/istio.sh
echo "Istio Ingress gateway Exposed on $ISTIO_EXTERNAL_IP"
echo "Istio setup Done"
sleep 30
echo "-------------------------------------------------------------------------------"

# SEALED-SECRETS
echo "Moving to secret management folder"
source ../tools/secrets-management/sealed-secrets.sh
echo "Sealed Secrets setup Done"
sleep 120
echo "-------------------------------------------------------------------------------"


echo "Starting microservices deployment"
cd ..
cd scripts
cd kustomize
cd base
cd namespaces
kubectl apply -f namespace-dev.yaml
cd ..
cd service-accounts
kubectl apply -f service-account-details-dev.yaml
kubectl apply -f service-account-product-dev.yaml
kubectl apply -f service-account-ratings-dev.yaml
cd ..
sleep 10


cd istio-policies
kubectl apply -f istio-peer-auth-only-mtls-dev.yaml
cd ..

cd cluster-role-bindings
kubectl apply -f cluster-role-binding-dev.yaml
cd ..
sleep 20

cd deployments
kubectl apply -f deployment-details.yaml
kubectl apply -f deployment-ratings.yaml
sleep 20
kubectl get pods -n dev
cd ..

cd services
kubectl apply -f service-details.yaml
kubectl apply -f service-ratings.yaml
sleep 90
kubectl get pods -n dev
cd ..

cd deployments
kubectl apply -f deployment-product.yaml
sleep 90
kubectl get pods -n dev
sleep 20
kubectl get pods -n dev
cd ..

cd services
kubectl apply -f service-product.yaml
cd ..

cd ingress
kubectl apply -f ingress-product.yaml
sleep 30
cd ..

cd horizontal-pod-autoscaling
kubectl aaply -f product-deployment-hpa.yaml
kubectl aaply -f details-deployment-hpa.yaml
kubectl aaply -f ratings-deployment-hpa.yaml
sleep 30
kubectl get hpa -n dev
cd ..

cd istio-policies
echo "Applying policies"
kubectl apply -f istio_auth_deny_all_dev.yaml
kubectl apply -f istio_auth_allow_istio_to_dev.yaml
kubectl apply -f istio_authpolicy_allow-dev-to-dev.yaml
kubectl apply -f istio-auth-policy-block-details-ratings-dev.yaml
kubectl apply -f istio_dest-rule_only-istio-mtls_dev.yaml
cd ..
cd ..
cd ..
cd ..

cd deploy

# KYVERNO
echo "Moving to Kyverno folder"
source ../tools/policy-management/kyverno.sh
echo "Kyverno setup Done"
sleep 30
echo "-------------------------------------------------------------------------------"


# ArgoCD
echo "Moving to ArgoCD folder"
source ../tools/continous-deployment/argocd.sh
echo "ArgoCD setup Done"
sleep 30
echo "-------------------------------------------------------------------------------"


# FluentBit
sed "s/API_KEY_PLACEHOLDER/${API_KEY}/g" ../tools/log-management/values.yaml > ../tools/log-management/values-tmp.yaml
echo "Moving to Fluentbit folder"
source ../tools/log-management/fluent.sh
echo "Fluent-bit setup Done"
sleep 30
echo "-------------------------------------------------------------------------------"


# Prometheus AlertManager and Grafana setup
echo "Moving to Monitoring Folder"
source ../tools/monitoring/monitoring.sh
echo "Monitoring setup done moving on to next"
echo "Grafana accessible at http://$GRAFANA_EXTERNAL_IP:3000"
echo "Prometheus accessible at http://$PROMETHEUS_EXTERNAL_IP:9090"
sleep 30
echo "-------------------------------------------------------------------------------"


echo "All setup done.."
echo "Printing out URL's and credentials"
echo "-------------------------------------------------------------------------------"
echo "for ArgoCD"
echo "ArgoCD accessible at http://$ARGOCD_EXTERNAL_IP:8080"
echo "The initial admin username is: admin"
echo "The initial admin password is: $ARGOCD_PASSWORD"
echo "-------------------------------------------------------------------------------"
echo "for Grafana"
echo "Grafana accessible at http://$GRAFANA_EXTERNAL_IP:3000"
echo "The initial admin username is: admin"
echo "The initial admin password is: prom-operator"
echo "-------------------------------------------------------------------------------"
echo "for prometheus"
echo "Prometheus accessible at http://$PROMETHEUS_EXTERNAL_IP:9090"
echo "-------------------------------------------------------------------------------"
echo "Microservices product page exposed at: http://$ISTIO_EXTERNAL_IP/"
echo "setup complete"
echo "done..."
