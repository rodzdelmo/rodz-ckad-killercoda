## Task

`recs-service` in namespace `canary-ops` is meant to split traffic across two Deployments: `recs-stable` (3 replicas) and `recs-canary` (1 replica). Both are `Running` and `Ready`.

```bash
kubectl get pods -n canary-ops --show-labels
kubectl get svc recs-service -n canary-ops -o yaml
kubectl get endpoints recs-service -n canary-ops
```

`recs-service` selects on `app: recs` alone (deliberately, so it doesn't care which track a Pod belongs to). `recs-stable`'s Pods carry both `app: recs` and `track: stable`. `recs-canary`'s Pods only carry `track: canary` — the pod template never got the shared `app: recs` label, so the Service's selector doesn't match them and the canary Pods sit there fully healthy but invisible to traffic.

Edit `/root/manifest/recs-canary.yaml`, add `app: recs` alongside `track: canary` in **both** `spec.selector.matchLabels` and `spec.template.metadata.labels`, then reapply:

```bash
kubectl apply -f /root/manifest/recs-canary.yaml
```

This changes the pod template, so it triggers a normal rolling update of the canary Deployment - unlike the Service selector fix, this one isn't immutable. When `kubectl get endpoints recs-service -n canary-ops` lists 4 addresses total, click **Check**.
