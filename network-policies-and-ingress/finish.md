# Scenario complete

You wrote a NetworkPolicy from scratch, fixed an Ingress pointing at a nonexistent Service, and corrected a rewrite-target annotation.

Key commands used in this exercise:

```bash
kubectl get networkpolicy -n <namespace> -o yaml
kubectl get svc -n <namespace>
kubectl get ingress <name> -n <namespace> -o yaml
kubectl annotate ingress <name> -n <namespace> nginx.ingress.kubernetes.io/rewrite-target=/$2 --overwrite
```

## Helpful tips: network policies and ingress at a glance

1. with zero NetworkPolicies selecting a Pod, it allows all traffic from anywhere - the moment *any* policy's `podSelector` matches it, that Pod flips to deny-by-default except what's explicitly allowed;
2. one `from` entry with both a `namespaceSelector` and a `podSelector` means "this Pod, in this namespace" (AND) - two separate `from` entries mean "either of these" (OR). Getting this wrong is the single most common NetworkPolicy mistake;
3. every namespace already carries the label `kubernetes.io/metadata.name: <namespace>` automatically, so you can always target a namespace by name in a `namespaceSelector` without labeling it yourself;
4. Kubernetes never validates that an Ingress's backend Service name actually exists when you `apply` it - a typo only shows up once real traffic tries to route through it; and
5. `rewrite-target` isn't a core Kubernetes field - it's an ingress-controller-specific annotation (`nginx.ingress.kubernetes.io/rewrite-target` for the NGINX controller), and using capture groups in the path (`(.*)`) requires `pathType: ImplementationSpecific` plus the matching `$1`/`$2` reference in the annotation.
