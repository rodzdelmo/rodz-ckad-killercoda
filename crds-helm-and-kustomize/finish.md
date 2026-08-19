# Scenario complete

You fixed a custom resource rejected by CRD schema validation, added a missing Helm repo and installed a chart, and repaired a Kustomize resource list.

Key commands used in this exercise:

```bash
kubectl apply -f /root/manifest/<file>.yaml
helm repo add <name> <url>
helm repo update
helm install <release> <repo>/<chart> -n <namespace> --create-namespace
kubectl apply -k base
```

## Helpful tips: CRDs, Helm, and Kustomize at a glance

1. a CustomResourceDefinition lets a cluster define its own resource type with its own schema, and the API server validates every custom resource against it at submission time - just like a built-in type;
2. Helm repos are configured **per machine**, not per cluster - `helm repo add` is a one-time local setup step, so a brand-new laptop has none configured even if the exact same install already works for everyone else; and
3. Kustomize's `resources:` field needs an exact filename match to what's actually on disk - there's no fuzzy matching, and one bad entry fails the whole `apply -k` before anything is created.
