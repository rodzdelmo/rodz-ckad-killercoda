## Task

The Deployment named `web` in namespace `ckad-lab` must run **three ready replicas**.

The application must use this container image:

```text
nginx:1.27-alpine
```

Diagnose the failure and repair the existing Deployment. Do not delete the namespace or replace the Deployment with a different workload type.

Useful commands:

```bash
kubectl get deployments,pods -n ckad-lab
```

```bash
kubectl describe pod -n ckad-lab
```

```bash
kubectl set image deployment/web nginx=nginx:1.27-alpine -n ckad-lab
```

```bash
kubectl rollout status deployment/web -n ckad-lab
```

When all three Pods are ready, click **Check**.
