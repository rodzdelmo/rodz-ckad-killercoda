## Task

The Deployment named `web` in namespace `ckad-lab` must run **three ready replicas**, using this container image:

```text
nginx:1.27-alpine
```

Right now, none of its Pods are becoming ready.

Just look around for now — don't change anything yet. Inspect the Deployment and its Pods and figure out why they aren't ready.

Useful commands:

```bash
kubectl get deployments,pods -n ckad-lab
```

```bash
kubectl describe pod -n ckad-lab
```

Once you understand the failure, click **Next**.
