# Scenario complete

You tracked down a Pod created in the wrong namespace and fixed a manifest that failed to apply because of a missing YAML list marker.

Key commands used in this exercise:

```bash
kubectl get pods -A
kubectl delete pod api-recap -n default
kubectl run api-recap --image=nginx:1.25 -n intro-ops
kubectl apply -f /root/manifest/ping-pod.yaml
```

## Helpful tips: a troubleshooting workflow

This applies both in the CKAD exam and in real Kubernetes troubleshooting:

1. never assume a resource landed where you expect — check with `-A`/`--all-namespaces`;
2. read `kubectl apply` error messages literally, they usually name the exact field;
3. remember `containers`, `initContainers`, and `env` are YAML **lists** (`-`-prefixed items), not maps; and
4. re-verify with `kubectl get` after every fix.
