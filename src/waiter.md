# Waiter

## kubeconfig

- [waiter-ca.pem](waiter-ca.pem)
- [kubelogin](https://github.com/int128/kubelogin)

```bash
# Configure the cluster
kubectl config set-cluster bacchus-waiter \
    --server=https://waiter.bacchus.io:6443 \
    --embed-certs \
    --certificate-authority=waiter-ca.pem

# Configure authentication
kubectl config set-credentials bacchus-waiter \
    --exec-api-version=client.authentication.k8s.io/v1beta1 \
    --exec-command=kubectl \
    --exec-arg=oidc-login \
    --exec-arg=get-token \
    --exec-arg=--oidc-issuer-url=https://auth.bacchus.io/dex \
    --exec-arg=--oidc-client-id=bacchus-waiter \
    --exec-arg=--oidc-extra-scope=email \
    --exec-arg=--oidc-extra-scope=groups \
    --exec-arg=--oidc-use-pkce

# Configure context
kubectl config set-context bacchus-waiter \
    --cluster=bacchus-waiter \
    --user=bacchus-waiter

# Switch to the context
kubectl config use-context bacchus-waiter
```

Verify with `kubectl auth whoami`.

## VPN

TODO
