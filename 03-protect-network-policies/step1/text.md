## Task

`invoice-api` in namespace `payments-ops` currently has no NetworkPolicy applied to it at all - it's reachable from any Pod, in any namespace, on the cluster. Security wants it locked down so that only `billing-ui` Pods in namespace `billing-ops` can reach it, on port `8080`.

```bash
kubectl get networkpolicy -n payments-ops
kubectl get pods -n payments-ops --show-labels
kubectl get pods -n billing-ops --show-labels
```

A NetworkPolicy is opt-in per Pod: with zero policies selecting a Pod, it allows all traffic from anywhere. The moment *any* policy's `podSelector` matches it, that Pod flips to deny-everything-except-what's-explicitly-allowed - so one correctly-scoped policy both grants the access you want and locks out everything else, in a single step.

A starter skeleton is at `/root/manifest/invoice-api-policy.yaml`. Fill in (or replace it entirely with your own) a NetworkPolicy that:
- selects `app: invoice-api` Pods in `payments-ops`;
- has one ingress rule allowing `port: 8080`; and
- has one `from` entry with **both** a `namespaceSelector` matching namespace `billing-ops` and a `podSelector` matching `app: billing-ui` - together, in the same entry (every namespace already carries the label `kubernetes.io/metadata.name: <namespace>`, so you can select `billing-ops` without labeling it yourself).

> Putting `namespaceSelector` and `podSelector` in **separate** `from` entries means "either of these" (OR) instead of "this Pod, in this namespace" (AND) - a common mistake worth double-checking.

```bash
kubectl apply -f /root/manifest/invoice-api-policy.yaml
```

When the NetworkPolicy exists with the fields above, click **Check**.
