## Task

Update and fix the broken Deployment. What do you think is the right way to fix it?

The Deployment named `web` in namespace `ckad-lab` must run **three ready replicas**, using this container image:

```text
nginx:1.27-alpine
```

Do not delete the namespace or replace the Deployment with a different workload type.

Useful commands:

```bash
kubectl set image deployment/web nginx=nginx:1.27-alpine -n ckad-lab
```

```bash
kubectl rollout status deployment/web -n ckad-lab
```

When all three Pods are ready, click **Check**.
