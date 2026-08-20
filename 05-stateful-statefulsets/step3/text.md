## Task

With the headless Service and the volume reference both fixed, `redis-cluster-0` and `redis-cluster-1` should be `Running`, each bound to its own PVC (`data-redis-cluster-0`, `data-redis-cluster-1`).

```bash
kubectl get pods -n database-ops -l app=redis-cluster
kubectl get pvc -n database-ops
```

Unlike a Deployment's Pods - which are interchangeable and get a random suffix - a StatefulSet gives each replica a **stable identity**: the same ordinal name, the same DNS record, and the same PVC, no matter how many times that specific Pod is deleted and recreated. Prove it to yourself:

```bash
kubectl delete pod redis-cluster-0 -n database-ops
kubectl wait --for=condition=Ready pod/redis-cluster-0 -n database-ops --timeout=60s
kubectl get pod redis-cluster-0 -n database-ops
kubectl get pvc data-redis-cluster-0 -n database-ops
```

The replacement Pod comes back with the *exact same name* - `redis-cluster-0`, not some new random one - and reattaches to the *exact same* PVC it had before. That's the entire point of a StatefulSet: identity survives the Pod's death, which is what makes StatefulSets suitable for things like clustered databases that care which member is which.

When `redis-cluster-0` is `Running` again and still bound to `data-redis-cluster-0`, click **Check**.
