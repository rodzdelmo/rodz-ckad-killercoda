## Task

Pod `cache` (label `app: cache`) is already `Running` in namespace `place-ops`. Pod `web-podaffinity` is supposed to schedule onto the same node as `cache`, but it never leaves `Pending`.

```bash
kubectl get pod web-podaffinity -n place-ops -o yaml
kubectl get pod cache -n place-ops --show-labels
```

Its `podAffinity` rule's `labelSelector` looks for `app: caches` — one letter off from the real label `app: cache`. Since nothing matches that selector anywhere in the cluster, the required term can never be satisfied. Fix the selector.

> **Note**: `affinity` is immutable once a Pod is created — edit `/root/manifest/web-podaffinity.yaml`, then delete the Pod and re-apply it.

```bash
kubectl delete pod web-podaffinity -n place-ops
kubectl apply -f /root/manifest/web-podaffinity.yaml
```

When `web-podaffinity` is `Running` in `place-ops`, click **Check**.
