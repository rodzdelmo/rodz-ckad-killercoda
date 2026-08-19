# Scenario complete

You granted a missing RBAC verb, fixed a kubeconfig's cluster and then its user, got a Deployment's Pods past a real validating webhook, and repaired a manifest written against a deprecated API version.

Key commands used in this exercise:

```bash
kubectl auth can-i patch deployments -n <namespace> --as=system:serviceaccount:<namespace>:<sa>
kubectl config use-context <name> --kubeconfig=/root/practice-kubeconfig
kubectl config set-context <name> --user=<user> --kubeconfig=/root/practice-kubeconfig
kubectl describe replicaset <name> -n <namespace>
kubectl apply -f /root/manifest/<file>.yaml
```

## Helpful tips: RBAC, kubeconfig, and admission control at a glance

1. RBAC is deny-by-default and verb-by-verb - being allowed to `get`/`list` a resource says nothing about being allowed to `patch`/`update` it;
2. a kubeconfig "context" is just a named pairing of (which cluster + which user credentials) - switching clusters and switching identities are two independent settings, and either can be wrong without the other being wrong too. Reads working while writes fail is a strong signal you have the right cluster but the wrong identity;
3. a Deployment doesn't run anything itself - it creates Pods for you, and an admission webhook validates the **Pod**, not the Deployment. Labels on the Deployment's own `metadata` don't automatically carry over; only `spec.template.metadata.labels` gets copied onto every Pod it creates; and
4. Kubernetes periodically retires old API versions, and the *shape* of fields often changes along with the version string - `networking.k8s.io/v1` Ingress objects require `pathType` on every path (no default), unlike the old `extensions/v1beta1` shape.
