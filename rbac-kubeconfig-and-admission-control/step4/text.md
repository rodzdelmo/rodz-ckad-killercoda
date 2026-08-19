## Task

A `ValidatingWebhookConfiguration` called `enforce-labels` requires every Pod in namespace `production-ops` to carry a `team` label. It's already running and enforcing - Deployment `checkout-service`'s Pods are being rejected:

```bash
kubectl describe replicaset -n production-ops -l app=checkout-service
```

You'll see an event like `Error creating: admission webhook "enforce-labels.production-ops.svc" denied the request: missing required label "team"` - even though `team: retail` is clearly visible on the Deployment's own `metadata.labels`.

```bash
kubectl get deployment checkout-service -n production-ops -o yaml
```

A Deployment doesn't run anything itself - it creates Pods for you. The webhook checks the **Pod**, not the Deployment, and labels on the Deployment's own `metadata` don't automatically carry over to the Pods it creates. Only labels under `spec.template.metadata.labels` get copied onto every Pod.

Edit `/root/manifest/checkout-service.yaml`: add `team: retail` to `spec.template.metadata.labels` (alongside the existing `app: checkout-service`), then reapply:

```bash
kubectl apply -f /root/manifest/checkout-service.yaml
```

When both replicas of `checkout-service` are `Running`, click **Check**.
