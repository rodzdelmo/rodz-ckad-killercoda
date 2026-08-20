# Scenario complete

You fixed an Ingress pointing at a nonexistent Service, and corrected a rewrite-target annotation.

Key commands used in this exercise:

```bash
kubectl get svc -n <namespace>
kubectl get ingress <name> -n <namespace> -o yaml
kubectl annotate ingress <name> -n <namespace> nginx.ingress.kubernetes.io/rewrite-target=/$2 --overwrite
```

## Helpful tips: ingress networking at a glance

1. Kubernetes never validates that an Ingress's backend Service name actually exists when you `apply` it - a typo only shows up once real traffic tries to route through it;
2. `rewrite-target` isn't a core Kubernetes field - it's an ingress-controller-specific annotation (`nginx.ingress.kubernetes.io/rewrite-target` for the NGINX controller), and using capture groups in the path (`(.*)`) requires `pathType: ImplementationSpecific` plus the matching `$1`/`$2` reference in the annotation; and
3. an Ingress *resource* only does something once an Ingress *controller* is actually running in the cluster and watching it - the resource on its own is just a routing intent, not a working router.

Next up in the series: **3. Protect** &mdash; locking down Pod-to-Pod traffic with Network Policies.
