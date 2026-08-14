## Task

ReplicaSet `store-replicas` in namespace `store-ops` was created directly, not through a Deployment — a recap of the difference between the two.

Read its Pod template, then create a Deployment named `store-app` in the same namespace, using the same image and 3 replicas.

Useful commands:

```bash
kubectl get rs store-replicas -n store-ops -o yaml
```

```bash
kubectl create deployment store-app --image=nginx:1.25 -n store-ops --replicas=3
```

When Deployment `store-app` reports `3/3` ready, click **Check**.
