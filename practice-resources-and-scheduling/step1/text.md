## Task (Part 1 — Update Resources)

Pod `ledger-worker` in namespace `ledger-ops` is under-provisioned ahead of an expected traffic spike. It currently requests `cpu=250m`/`memory=256Mi` with limits `cpu=500m`/`memory=512Mi` — half of what's needed.

Bump `resources.requests` to `cpu=500m`/`memory=512Mi` and `resources.limits` to `cpu=1000m`/`memory=1Gi`, then confirm the Pod is `Running` with the new values.

> **Note**: `resources` is immutable once a Pod is created — `kubectl edit`/`apply` in place will be rejected. Delete the Pod first, then re-apply the manifest with the updated values.

## Task (Part 2 — Identify the ServiceAccount)

Identify which ServiceAccount `ledger-worker` runs under. Create a file named `ledger-worker-sa.txt` in `/root` containing **only** the ServiceAccount name — no extra spaces, no extra lines.

Useful command:

```bash
kubectl get pod ledger-worker -n ledger-ops -o jsonpath='{.spec.serviceAccountName}'
```

When both parts are done, click **Check**.
