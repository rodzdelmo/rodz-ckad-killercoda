# Scenario complete

You added a Pod template label to a Deployment and confirmed a safe rolling update carried it onto every Pod.

Key commands used in this exercise:

```bash
kubectl patch deployment profile-api -n accounts-ops --type merge \
  -p '{"spec":{"template":{"metadata":{"labels":{"team":"accounts"}}}}}'
kubectl rollout status deployment/profile-api -n accounts-ops
kubectl get pods -n accounts-ops --show-labels
```

## Helpful tips: a troubleshooting workflow

This applies both in the CKAD exam and in real Kubernetes troubleshooting:

1. changing `spec.template` always triggers a rolling update — changing `spec.selector` almost never works after creation;
2. `kubectl rollout status` is the fast way to confirm a rollout finished, not just started; and
3. `--show-labels` (or `-l`) is the quickest way to confirm a label change actually reached every Pod.
