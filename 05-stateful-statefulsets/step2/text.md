## Task

`redis-cluster`, a StatefulSet in namespace `database-ops`, uses `volumeClaimTemplates` to give each replica its own dedicated storage volume, named `data`. StatefulSet `redis-cluster` is not ready, and `kubectl get pods -n database-ops -l app=redis-cluster` shows nothing at all.

```bash
kubectl get statefulset redis-cluster -n database-ops -o yaml
kubectl describe statefulset redis-cluster -n database-ops
```

A StatefulSet's `volumeClaimTemplates[].metadata.name` is the name the controller uses to auto-generate a matching volume in every Pod it creates. A container's `volumeMounts[].name` must reference that exact same name - get it wrong, and the Pod object the controller tries to create is invalid, so the API server rejects it outright before a Pod ever exists. Here, `volumeClaimTemplates[].metadata.name` is `data`, but the container's `volumeMounts[].name` reads `redis-data`.

Fix the container's `volumeMounts` in `/root/manifest/redis-cluster.yaml` so it references `data`:

```bash
kubectl apply -f /root/manifest/redis-cluster.yaml
```

Unlike `volumeClaimTemplates` itself, this field isn't immutable, so no delete/recreate is needed - just patch or reapply. When both replicas of `redis-cluster` are ready, click **Check**.
