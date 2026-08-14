## Task

Deployment `profile-api` in namespace `accounts-ops` needs a new label for an upcoming cost-reporting dashboard.

```bash
kubectl get pods -n accounts-ops --show-labels
```

The dashboard query expects `team=accounts` on every Pod. Add `team: accounts` to the Deployment's Pod template labels, apply the change (triggering a rolling update), and confirm it rolled out cleanly.

Useful commands:

```bash
kubectl patch deployment profile-api -n accounts-ops --type merge \
  -p '{"spec":{"template":{"metadata":{"labels":{"team":"accounts"}}}}}'
```

```bash
kubectl rollout status deployment/profile-api -n accounts-ops
```

```bash
kubectl get pods -n accounts-ops --show-labels
```

When every Pod shows `team=accounts` and the rollout is complete, click **Check**.
