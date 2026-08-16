## Task

A new rollout just shipped to Deployment `store-app` in namespace `store-ops` — and it's broken. Pods aren't becoming ready.

```bash
kubectl rollout status deployment/store-app -n store-ops
```

Instead of debugging the new image, roll back to the previous working revision.

Useful commands:

```bash
kubectl rollout history deployment/store-app -n store-ops
kubectl rollout undo deployment/store-app -n store-ops
```

When `store-app` is back to `3/3` ready on the previous image tag, click **Check**.
