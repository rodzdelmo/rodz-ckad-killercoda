## Task

The node just got tainted `dedicated=finance:NoSchedule`, and Pod `web-taint` in namespace `place-ops` was submitted right after — it never leaves `Pending`.

```bash
kubectl get pod web-taint -n place-ops -o yaml
kubectl describe node
```

Add a matching `tolerations` entry to the Pod spec so it schedules despite the taint.

> **Note**: `tolerations` is immutable once a Pod is created — edit `/root/manifest/web-taint.yaml`, then delete the Pod and re-apply it.

```bash
kubectl delete pod web-taint -n place-ops
kubectl apply -f /root/manifest/web-taint.yaml
```

When `web-taint` is `Running` in `place-ops`, click **Check**.
