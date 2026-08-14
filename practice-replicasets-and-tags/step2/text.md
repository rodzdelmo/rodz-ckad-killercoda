## Task

In namespace `orders-ops`, Deployment `orders-api` originally shipped on tag `1.25`. A new rollout just went out, but nobody wrote down which tag actually got shipped.

Identify the exact image tag Deployment `orders-api` is running right now. Create a file named `orders-api.txt` in `/root` containing **only the tag** — no `nginx:` prefix, no extra spaces, no extra lines.

Useful command:

```bash
kubectl get deployment orders-api -n orders-ops -o jsonpath='{.spec.template.spec.containers[0].image}'
```

When `/root/orders-api.txt` contains the correct tag, click **Check**.
