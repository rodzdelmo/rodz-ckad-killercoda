# Scenario complete

You added a Pod template label to a Deployment and confirmed a safe rolling update carried it onto every Pod, then set its CPU and memory requests and limits — each time with a choice between an imperative command or editing and applying a manifest.

Key commands used in this exercise:

```bash
kubectl patch deployment profile-api -n accounts-ops --type merge \
  -p '{"spec":{"template":{"metadata":{"labels":{"team":"accounts"}}}}}'
kubectl apply -f /root/manifest/profile-api.yaml
kubectl rollout status deployment/profile-api -n accounts-ops
kubectl get pods -n accounts-ops --show-labels
kubectl set resources deployment/profile-api -n accounts-ops \
  --requests=cpu=100m,memory=128Mi --limits=cpu=500m,memory=256Mi
```

## Helpful tips: a troubleshooting workflow

This applies both in the CKAD exam and in real Kubernetes troubleshooting:

1. changing `spec.template` always triggers a rolling update — changing `spec.selector` almost never works after creation;
2. `kubectl rollout status` is the fast way to confirm a rollout finished, not just started;
3. `--show-labels` (or `-l`) is the quickest way to confirm a label change actually reached every Pod;
4. `kubectl set resources` changes CPU/memory requests and limits on a Deployment without hand-editing YAML — since it's a template change, it rolls out new Pods rather than patching running ones in place (unlike a bare Pod, where `resources` is immutable); and
5. imperative and declarative updates to a Deployment converge on the same result — under exam time pressure, default to whichever is faster to type, but keep the manifest around if you need to reproduce the change later.
