# Scenario complete

You resized a Pod's compute resources, identified which ServiceAccount it runs under, and fixed a Pod that couldn't schedule because it was missing a toleration.

Key commands used in this exercise:

```bash
kubectl get pod ledger-worker -n ledger-ops -o jsonpath='{.spec.serviceAccountName}'
kubectl get pod gpu-idle -n gpu-ops -o yaml
kubectl taint node <node> dedicated=gpu:NoSchedule
```

## Helpful tips: a troubleshooting workflow

This applies both in the CKAD exam and in real Kubernetes troubleshooting:

1. `resources`, `tolerations`, and `command` are all immutable on a running Pod — plan for delete + reapply, not `edit`;
2. when a Pod is stuck `Pending` on a tainted pool, diff it against a Pod that already schedules there; and
3. a toleration must match the taint's key, value, and effect exactly to take effect.
