# Scenario complete

You repaired the Deployment by identifying an invalid container image and updating the Pod template.

Key commands used in this exercise:

```bash
kubectl get pods -n ckad-lab
kubectl describe pod -n ckad-lab
kubectl set image deployment/web nginx=nginx:1.27-alpine -n ckad-lab
kubectl rollout status deployment/web -n ckad-lab
```

This workflow is useful in the CKAD exam and in real Kubernetes troubleshooting:

1. inspect the workload;
2. inspect Pod events and container state;
3. correct the workload specification; and
4. verify the rollout and ready replicas.
