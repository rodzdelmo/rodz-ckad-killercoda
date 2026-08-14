# Scenario complete

You cloned a Secret-backed Deployment pattern onto a second service, and read a Pod's `securityContext` and `nodeSelector` fields without touching anything.

Key commands used in this exercise:

```bash
kubectl create secret generic mail-secret --from-literal=SESSION_KEY='M@ilKey789' -n auth-ops
kubectl set env deployment/mail-auth --from=secret/mail-secret -n auth-ops
kubectl get pod policy-checker -n guard-ops -o yaml
```

## Helpful tips: a troubleshooting workflow

This applies both in the CKAD exam and in real Kubernetes troubleshooting:

1. `kubectl set env --from=secret/<name>` is faster than hand-writing `envFrom` in the exam;
2. Secret values are base64-encoded at rest — always `base64 -d` before comparing; and
3. a `Pending` Pod isn't always broken — check `nodeSelector`/affinity before assuming a bug.
