## Task

Deployment `store-app` originally shipped on tag `1.25`. A new rollout just went out, but nobody wrote down which tag actually got shipped.

Identify the exact image tag Deployment `store-app` is running right now. Create a file named `store-app.txt` in `/root` containing **only the tag** — no `nginx:` prefix, no extra spaces, no extra lines.

Useful command:

```bash
kubectl get deployment store-app -n store-ops -o jsonpath='{.spec.template.spec.containers[0].image}'
```

When `/root/store-app.txt` contains the correct tag, click **Check**.
