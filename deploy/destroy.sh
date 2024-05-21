cd ..
cd scripts
cd kustomize
cd base
cd namespaces
kubectl delete -f namespace-dev.yaml
cd ..
cd service-accounts
kubectl delete -f service-account-details-dev.yaml
kubectl delete -f service-account-product-dev.yaml
kubectl delete -f service-account-ratings-dev.yaml
cd ..
cd istio-policies
kubectl delete -f istio-peer-auth-only-mtls-dev.yaml
cd ..

cd cluster-role-bindings
kubectl delete -f cluster-role-binding-dev.yaml
cd ..

cd deployments
kubectl delete -f deployment-details.yaml
kubectl delete -f deployment-ratings.yaml
kubectl get pods -n dev
cd ..

cd services
kubectl delete -f service-details.yaml
kubectl delete -f service-ratings.yaml
kubectl get pods -n dev
cd ..

cd deployments
kubectl delete -f deployment-product.yaml
kubectl get pods -n dev
kubectl get pods -n dev
cd ..

cd services
kubectl delete -f service-product.yaml
cd ..

cd ingress
kubectl delete -f ingress-product.yaml
cd ..

cd istio-policies
kubectl delete -f istio_auth_deny_all_dev.yaml
kubectl delete -f istio_auth_allow_istio_to_dev.yaml
kubectl delete -f istio_authpolicy_allow-dev-to-dev.yaml
kubectl delete -f istio-auth-policy-block-details-ratings-dev.yaml
kubectl delete -f istio_dest-rule_only-istio-mtls_dev.yaml

echo "microservices files and components deleted"


cd ..
cd ..
cd ..
cd ..
cd infra
cd kubernetes
terraform destroy --auto-approve

cd ..
cd registry
terraform destroy --auto-approve 

