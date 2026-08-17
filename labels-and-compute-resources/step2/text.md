## Task

Deployment `profile-api` in namespace `accounts-ops` was shipped without any compute resources configured — risky on a shared cluster.

Set the following on its container:

- CPU requests: `100m`
- Memory requests: `128Mi`
- CPU limits: `500m`
- Memory limits: `256Mi`

You can do this either **imperatively** or **declaratively** — pick one.

Imperatively:

```bash
kubectl set resources deployment/profile-api -n accounts-ops \
  --requests=cpu=100m,memory=128Mi --limits=cpu=500m,memory=256Mi
```

Declaratively — edit `/root/manifest/profile-api.yaml` (the same manifest from the previous step, now also carrying the `team` label) to add a `resources` block under the container:

```yaml
  template:
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "500m"
              memory: "256Mi"
```

The `resources` block is a sibling of `image` — nested under the container entry, not under `spec.template.metadata`. Then apply it:

```bash
kubectl apply -f /root/manifest/profile-api.yaml
```

Either way, confirm the rollout:

```bash
kubectl rollout status deployment/profile-api -n accounts-ops
```

Unlike a bare Pod, a Deployment's resources can be changed this way directly — it just rolls out new Pods with the new values, no delete required.

When the rollout completes with these exact requests and limits, click **Check**.
