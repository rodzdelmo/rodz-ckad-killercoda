## Task

Pod `web-nodeaffinity` in namespace `place-ops` never leaves `Pending`.

```bash
kubectl get pod web-nodeaffinity -n place-ops -o yaml
kubectl get node --show-labels
```

Its `nodeAffinity` rule requires `zone: us-west-1a`, but the node is labeled `zone: us-east-1a`. Fix the rule's `values` to match.

> **Note**: `affinity` is also immutable once a Pod is created — edit `/root/manifest/web-nodeaffinity.yaml`, then delete the Pod and re-apply it.

```bash
kubectl delete pod web-nodeaffinity -n place-ops
kubectl apply -f /root/manifest/web-nodeaffinity.yaml
```

When `web-nodeaffinity` is `Running` in `place-ops`, click **Check**.
