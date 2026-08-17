## Task

Pod `web-nodeselector` in namespace `place-ops` never leaves `Pending`.

```bash
kubectl get pod web-nodeselector -n place-ops -o yaml
kubectl get node --show-labels
```

The Pod's `nodeSelector` asks for `disktype: hdd`, but the node is labeled `disktype: ssd`. Fix the Pod's `nodeSelector` to match the node's actual label.

> **Note**: `nodeSelector` is immutable once a Pod is created — edit `/root/manifest/web-nodeselector.yaml`, then delete the Pod and re-apply it.

```bash
kubectl delete pod web-nodeselector -n place-ops
kubectl apply -f /root/manifest/web-nodeselector.yaml
```

When `web-nodeselector` is `Running` in `place-ops`, click **Check**.
