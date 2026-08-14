# Scenario complete

You corrected a Pod's startup command and fixed a ConfigMap key reference mismatch — both requiring a delete-and-recreate because the affected fields are immutable once a Pod exists.

Key commands used in this exercise:

```bash
kubectl logs job-runner -n jobs-ops
kubectl get configmap hello-config -n hello-ops -o yaml
kubectl delete pod <name> -n <namespace>
kubectl apply -f <corrected-manifest>.yaml
```

## Helpful tips: a troubleshooting workflow

This applies both in the CKAD exam and in real Kubernetes troubleshooting:

1. `CrashLoopBackOff` + a `stat ... no such file` log line almost always means a wrong `command`/`args`;
2. a ConfigMap/Secret reference that silently resolves to nothing is usually a key name typo, not a missing object;
3. know which Pod spec fields are mutable (`image`, most metadata) versus immutable (`command`, `env`, `resources` on older clusters) — immutable ones need delete + reapply, not `edit`.
