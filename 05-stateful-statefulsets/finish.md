# Scenario complete

You made a Service headless, corrected a StatefulSet's volume reference, and confirmed that StatefulSet Pods keep their name and storage across deletion.

Key commands used in this exercise:

```bash
kubectl patch service <name> -n <namespace> -p '{"spec":{"clusterIP":"None"}}'
kubectl apply -f /root/manifest/<file>.yaml
kubectl delete pod <ordinal-pod> -n <namespace>
kubectl get pvc -n <namespace>
```

## Helpful tips: StatefulSets at a glance

1. a StatefulSet's per-Pod DNS identity only exists because its governing Service is headless (`clusterIP: None`) - a normal Service just load-balances across replicas and never creates individual per-Pod records;
2. `volumeClaimTemplates[].metadata.name` is the name the controller uses to auto-generate a matching volume in every Pod it creates - a container's `volumeMounts[].name` must reference that exact name, or the API server rejects the generated Pod spec before a Pod ever exists; and
3. that's the whole point of a StatefulSet over a Deployment: ordinal Pod names (`<name>-0`, `<name>-1`, ...) and their PVCs are stable across deletion and rescheduling - a Deployment's Pods are interchangeable and get a random name every time.

Next up in the series: **6. Secure** &mdash; RBAC, kubeconfig, and admission control.
