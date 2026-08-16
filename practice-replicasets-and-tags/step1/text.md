## Task

ReplicaSet `store-replicas` in namespace `store-ops` was created directly, without a Deployment. Convert it into a Deployment named `store-app`, with the same Pod template and 3 replicas.

1. Export the ReplicaSet as YAML:

```bash
kubectl get rs store-replicas -n store-ops -o yaml > /root/store-app.yaml
```

2. Edit `/root/store-app.yaml`:
   - change `kind: ReplicaSet` to `kind: Deployment`
   - rename `metadata.name` to `store-app`
   - remove the ReplicaSet-only fields under `metadata` (`resourceVersion`, `uid`, `creationTimestamp`, `generation`) and the whole `status` block, so it applies cleanly as a brand-new object

3. Apply it, then remove the original ReplicaSet:

```bash
kubectl apply -f /root/store-app.yaml
kubectl delete replicaset store-replicas -n store-ops
```

When Deployment `store-app` reports `3/3` ready and `store-replicas` is gone, click **Check**.
