helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets

helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets

sleep 40
# kubectl apply -f ../tools/secrets-management/sealed-secrets.yaml
echo "Sealed Secrets Setup Complete"
