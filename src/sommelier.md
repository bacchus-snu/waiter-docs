# Sommelier

## kubeconfig

### Prerequisites

- Set up [waiter](waiter.md) first
- [sommelier-ca.pem](sommelier-ca.pem)

### Linux Version

```bash
# Configure the cluster
kubectl config set-cluster snucse-sommelier \
    --server=https://sommelier.snucse.org:6444 \
    --embed-certs \
    --certificate-authority=sommelier-ca.pem

# Configure authentication
kubectl config set-credentials bacchus-dex \
    --exec-api-version=client.authentication.k8s.io/v1beta1 \
    --exec-command=kubectl \
    --exec-arg=oidc-login \
    --exec-arg=get-token \
    --exec-arg=--oidc-issuer-url=https://auth.bacchus.io/dex \
    --exec-arg=--oidc-client-id=bacchus-waiter \
    --exec-arg=--oidc-extra-scope=email \
    --exec-arg=--oidc-extra-scope=groups

# Configure context
kubectl config set-context snucse-sommelier-bacchus \
    --cluster=snucse-sommelier \
    --user=bacchus-dex

# Switch to the context
kubectl config use-context snucse-sommelier-bacchus

# Verify configuration
kubectl auth whoami
```
