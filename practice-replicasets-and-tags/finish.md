# Scenario complete

You built a Deployment from an existing ReplicaSet's Pod template, and traced a running Deployment back to its exact image tag.

Key commands used in this exercise:

```bash
kubectl get rs store-replicas -n store-ops -o yaml
kubectl create deployment store-app --image=nginx:1.25 -n store-ops --replicas=3
kubectl get deployment orders-api -n orders-ops -o jsonpath='{.spec.template.spec.containers[0].image}'
```

## Helpful tips: a troubleshooting workflow

This applies both in the CKAD exam and in real Kubernetes troubleshooting:

1. a ReplicaSet keeps Pods running, but only a Deployment gives you rollout history and rollback;
2. `-o jsonpath` beats scrolling through `-o yaml` when you only need one field; and
3. when an answer must go in a file, double-check for stray whitespace or newlines before submitting.
