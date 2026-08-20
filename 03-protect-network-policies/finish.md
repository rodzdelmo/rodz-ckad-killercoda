# Scenario complete

You wrote an ingress NetworkPolicy from scratch, then fixed an egress-only policy that was blocking a legitimate database connection.

Key commands used in this exercise:

```bash
kubectl get networkpolicy -n <namespace> -o yaml
kubectl apply -f /root/manifest/<file>.yaml
```

## Helpful tips: network policies at a glance

1. with zero NetworkPolicies selecting a Pod, it allows all traffic from anywhere - the moment *any* policy's `podSelector` matches it, that Pod flips to deny-by-default except what's explicitly allowed;
2. that deny-by-default flip applies separately per direction - a policy with `policyTypes: [Egress]` and an empty `egress: []` denies *all* outbound traffic from the selected Pods, even to destinations an *ingress* policy would happily allow *into*;
3. one `from`/`to` entry with both a `namespaceSelector` and a `podSelector` means "this Pod, in this namespace" (AND) - two separate entries mean "either of these" (OR); and
4. every namespace already carries the label `kubernetes.io/metadata.name: <namespace>` automatically, so you can always target a namespace by name in a selector without labeling it yourself.

Next up in the series: **4. Store** &mdash; volumes, hostPath, and PersistentVolumes/Claims.
