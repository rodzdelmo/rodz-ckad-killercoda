## Task

Now that you're in the right context, `kubectl --kubeconfig=/root/practice-kubeconfig get pods -A` works fine, but applying a new Deployment doesn't:

```bash
kubectl --kubeconfig=/root/practice-kubeconfig apply -f /root/manifest/new-deployment.yaml
```

This fails with `Error from server (Forbidden): ... User "system:serviceaccount:default:contractor-readonly" cannot create resource "deployments"`. Reads working while writes fail is a strong signal you've got the right cluster but the wrong identity, not a connectivity problem.

```bash
kubectl --kubeconfig=/root/practice-kubeconfig config view
```

The `cluster-prod` context's `user` field points at `contractor-readonly`, a read-only identity. `engineer-admin`, the identity with write access, is already defined in this same kubeconfig - it's just not the one wired to this context. Fix it:

```bash
kubectl --kubeconfig=/root/practice-kubeconfig config set-context cluster-prod --user=engineer-admin
kubectl --kubeconfig=/root/practice-kubeconfig apply -f /root/manifest/new-deployment.yaml
```

When that `apply` succeeds, click **Check**.
