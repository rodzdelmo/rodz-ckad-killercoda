# Scenario complete

You loaded a ConfigMap into a Pod's environment, cloned a Secret-backed Deployment pattern onto a second service, and read a Pod's `securityContext` and `nodeSelector` fields without touching anything.

Key commands used in this exercise:

```bash
kubectl run app-pod --image=busybox:1.36 -n config-ops --dry-run=client -o yaml --command -- sh -c "sleep 3600" > /root/app-pod.yaml
kubectl apply -f /root/app-pod.yaml
kubectl create secret generic mail-secret --from-literal=SESSION_KEY='M@ilKey789' -n auth-ops
kubectl set env deployment/mail-auth --from=secret/mail-secret -n auth-ops
kubectl get pod policy-checker -n guard-ops -o yaml
```

## Helpful tips: a troubleshooting workflow

This applies both in the CKAD exam and in real Kubernetes troubleshooting:

1. `envFrom.configMapRef` loads every key in the ConfigMap as an env var — use `env.valueFrom.configMapKeyRef` instead when you only want one specific key;
2. `kubectl set env --from=secret/<name>` (or `--from=configmap/<name>`) is faster than hand-writing `envFrom` in the exam, but it only works on objects with a Pod template (Deployments, DaemonSets, …) — a bare Pod's `env` is immutable once created;
3. Secret values are base64-encoded at rest — always `base64 -d` before comparing; and
4. a `Pending` Pod isn't always broken — check `nodeSelector`/affinity before assuming a bug.
