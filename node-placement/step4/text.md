## Task

Pod `web-podantiaffinity` in namespace `place-ops` is already `Running` — this is a single-node cluster, so a **preferred** (soft) anti-affinity rule never blocks scheduling, unlike the hard requirements in the earlier steps. That's expected; the rule itself is still wrong.

```bash
kubectl get pod web-podantiaffinity -n place-ops -o yaml
```

Its `podAntiAffinity` preference tries to avoid nodes running Pods labeled `app: wrong-app` — that doesn't match anything. It should be avoiding the `cache` Pod (`app: cache`) instead. Fix the `values` in the rule's `labelSelector`.

> **Note**: `affinity` is immutable once a Pod is created — edit `/root/manifest/web-podantiaffinity.yaml`, then delete the Pod and re-apply it. It will schedule and reach `Running` either way; what's graded is whether the rule itself now correctly targets `cache`.

```bash
kubectl delete pod web-podantiaffinity -n place-ops
kubectl apply -f /root/manifest/web-podantiaffinity.yaml
```

When `web-podantiaffinity` is `Running` in `place-ops` with the corrected rule, click **Check**.
