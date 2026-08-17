## Task

Namespace `auth-ops` already runs Deployment `token-auth`, wired to Secret `token-secret` (key `SESSION_KEY`) to sign its sessions. The team is spinning up a second deployment that needs the exact same pattern with its own Secret.

Create Secret `mail-secret` in `auth-ops` with key `SESSION_KEY` set to `M@ilKey789`, then create Deployment `mail-auth` that sources `SESSION_KEY` from it — following the same pattern as `token-auth`/`token-secret`.

Useful commands:

```bash
kubectl get deployment token-auth -n auth-ops -o yaml
```

```bash
kubectl create secret generic mail-secret --from-literal=SESSION_KEY='M@ilKey789' -n auth-ops
kubectl create deployment mail-auth --image=nginx:1.25 -n auth-ops
kubectl set env deployment/mail-auth --from=secret/mail-secret -n auth-ops
```

When Deployment `mail-auth` is `Running` and `SESSION_KEY` resolves correctly inside its Pod, click **Check**.
