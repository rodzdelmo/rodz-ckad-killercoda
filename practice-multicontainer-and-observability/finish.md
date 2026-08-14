# Scenario complete

You told an init container apart from a long-running one, fixed a liveness probe that was killing a healthy app, and picked the right `logs` command for a specific container in a multi-container Pod.

Key commands used in this exercise:

```bash
kubectl get pod web-with-cache -n edge-ops -o yaml
kubectl describe pod ping-api -n uptime-ops
kubectl logs metrics-relay -c exporter -n signal-ops
```

## Helpful tips: a troubleshooting workflow

This applies both in the CKAD exam and in real Kubernetes troubleshooting:

1. init containers run to completion before regular containers start — they never restart on their own;
2. a climbing restart count plus `Liveness probe failed` in `kubectl describe` means the probe is wrong, not the app; and
3. in a multi-container Pod, `kubectl logs` needs `-c <container>` — without it, it only works when there's exactly one container.
