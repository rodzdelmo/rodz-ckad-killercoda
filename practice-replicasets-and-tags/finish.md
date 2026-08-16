# Scenario complete

You converted a bare ReplicaSet into a Deployment by editing its exported YAML, then traced a fresh rollout on that Deployment back to its exact image tag.

Key commands used in this exercise:

```bash
kubectl get rs store-replicas -n store-ops -o yaml > /root/store-app.yaml
kubectl apply -f /root/store-app.yaml
kubectl delete replicaset store-replicas -n store-ops
kubectl get deployment store-app -n store-ops -o jsonpath='{.spec.template.spec.containers[0].image}'
```

## Helpful tips: a troubleshooting workflow

This applies both in the CKAD exam and in real Kubernetes troubleshooting:

1. a ReplicaSet and a Deployment's Pod template share the same shape (`spec.selector`/`spec.template`) — converting one to the other is mostly a `kind` and `metadata.name` change, plus stripping server-managed fields (`resourceVersion`, `uid`, `status`);
2. a Deployment keeps Pods running just like a ReplicaSet, but only the Deployment gives you rollout history and rollback;
3. `-o jsonpath` beats scrolling through `-o yaml` when you only need one field; and
4. when an answer must go in a file, double-check for stray whitespace or newlines before submitting.
