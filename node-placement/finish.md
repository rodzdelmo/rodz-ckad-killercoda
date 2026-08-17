# Scenario complete

You fixed five broken scheduling constraints: a nodeSelector, a node affinity rule, a pod affinity rule, a pod anti-affinity rule, and a missing toleration.

Key commands used in this exercise:

```bash
kubectl get node --show-labels
kubectl delete pod <name> -n place-ops
kubectl apply -f /root/manifest/<name>.yaml
kubectl describe node
```

## Helpful tips: node placement at a glance

This applies both in the CKAD exam and in real Kubernetes scheduling:

1. `nodeSelector` is simple hard equality; `nodeAffinity` supports richer operators (`In`, `NotIn`, `Exists`, …) and, with `preferredDuringSchedulingIgnoredDuringExecution`, soft preferences;
2. `podAffinity`/`podAntiAffinity` match against *other running Pods*, not node labels — a `requiredDuringScheduling` term with a selector that matches nothing can never be satisfied, no matter how many nodes you have;
3. on a single-node cluster, a *required* pod anti-affinity keyed on `kubernetes.io/hostname` is a contradiction — there's nowhere else to go, so it stays `Pending` forever. Use `preferredDuringSchedulingIgnoredDuringExecution` when you need anti-affinity that can't always be honored;
4. taints repel scheduling; tolerations are permission to ignore a taint — a taint never guarantees eviction of Pods that were already running before it was added; and
5. `nodeSelector`, `affinity`, and `tolerations` are all immutable once a Pod exists — delete and re-apply rather than editing in place.
