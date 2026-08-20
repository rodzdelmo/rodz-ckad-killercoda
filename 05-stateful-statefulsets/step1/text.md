## Task

`redis-cluster` in namespace `database-ops` is a StatefulSet meant to give each replica a stable, predictable network identity - something like `redis-cluster-0.redis-cluster.database-ops.svc.cluster.local`. That's not happening.

```bash
kubectl get svc redis-cluster -n database-ops -o yaml
```

A StatefulSet's per-Pod DNS records only exist through a **headless Service** - one with `clusterIP: None`. A normal (non-headless) Service load-balances across all matching Pods behind one virtual IP and never creates individual per-Pod DNS entries; the StatefulSet's `spec.serviceName` still has to point at *some* Service, but if that Service isn't headless, you lose the one feature StatefulSets exist for. `redis-cluster`'s Service is missing `clusterIP: None` entirely, so it's just an ordinary ClusterIP Service.

Fix it:

```bash
kubectl patch service redis-cluster -n database-ops -p '{"spec":{"clusterIP":"None"}}'
```

> **Note**: `clusterIP` is immutable once a Service has one assigned - if the patch above fails, delete and recreate the Service from `/root/manifest/redis-cluster.yaml` after adding `clusterIP: None` to its spec instead.

When `kubectl get svc redis-cluster -n database-ops` shows `CLUSTER-IP: None`, click **Check**.
