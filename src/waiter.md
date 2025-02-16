# Waiter

## kubeconfig

### Prerequisites

- [waiter-ca.pem](waiter-ca.pem)
- [kubelogin](https://github.com/int128/kubelogin)

`waiter-ca.pem` is required to be in the same directory as kubectl config commands.

### Linux Version

```bash
# Configure the cluster
kubectl config set-cluster bacchus-waiter \
    --server=https://waiter.bacchus.io:6443 \
    --embed-certs \
    --certificate-authority=waiter-ca.pem

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
kubectl config set-context bacchus-waiter \
    --cluster=bacchus-waiter \
    --user=bacchus-dex

# Switch to the context
kubectl config use-context bacchus-waiter

# Verify configuration
kubectl auth whoami
```

---

### Windows Version

#### Install Chocolaty (Optional)

1. In powershell run `Get-ExecutionPolicy`. If it returns `Restricted`, then run `Set-ExecutionPolicy AllSigned` or `Set-ExecutionPolicy Bypass -Scope Process`.
2. Run `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`

#### Configure kubeconfig

```bash
# Configure the cluster
kubectl config set-cluster bacchus-waiter --server=https://waiter.bacchus.io:6443 --embed-certs --certificate-authority=waiter-ca.pem

# Configure authentication
kubectl config set-credentials bacchus-waiter --exec-api-version=client.authentication.k8s.io/v1beta1 --exec-command=kubectl --exec-arg=oidc-login --exec-arg=get-token --exec-arg=--oidc-issuer-url=https://auth.bacchus.io/dex --exec-arg=--oidc-client-id=bacchus-waiter --exec-arg=--oidc-extra-scope=email --exec-arg=--oidc-extra-scope=groups

# Configure context
kubectl config set-context bacchus-waiter --cluster=bacchus-waiter --user=bacchus-waiter

# Switch to the context
kubectl config use-context bacchus-waiter
```

Change `kubelogin.exe` to `kubectl-oidc_login.exe`.

- Normally, `kubelogin` is installed in `C:\Users\<username>\bin\kubelogin.exe`
- In case of chocolaty, `kubelogin` is installed in `C:\ProgramData\chocolatey\bin\kubelogin.exe`

Verify with `kubectl auth whoami`.

Grant access in the webpage.
