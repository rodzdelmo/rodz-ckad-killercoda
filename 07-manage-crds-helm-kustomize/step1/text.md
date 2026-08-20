## Task

CRD `databases.ops.example.com` requires field `spec.engine` to be one of `postgres` or `mysql`. A new custom resource, `orders-db`, was just submitted in namespace `tools-ops` for the database operator to provision - it's meant to be a Postgres database for the order-tracking service. Try it yourself:

```bash
kubectl apply -f /root/manifest/orders-db.yaml
```

A CustomResourceDefinition lets a cluster define its own resource type with its own schema, which the API server validates at submission time - just like it would for a built-in type. `orders-db`'s `spec.engine` reads `postgresql`, which isn't one of the CRD's allowed enum values (`postgres`, `mysql`).

Fix the typo in `/root/manifest/orders-db.yaml` (`engine: postgres`), then reapply:

```bash
kubectl apply -f /root/manifest/orders-db.yaml
```

When `kubectl get database orders-db -n tools-ops` succeeds, click **Check**.
