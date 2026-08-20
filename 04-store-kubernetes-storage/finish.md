# Scenario complete

You added an emptyDir volume, fixed a hostPath type mismatch, and resolved a PV/PVC access-mode and subPath problem.

Key commands used in this exercise:

```bash
kubectl apply -f /root/manifest/<file>.yaml
kubectl delete pod <name> -n <namespace>
kubectl patch pv <name> --type=merge -p '{"spec":{"accessModes":["ReadWriteOnce","ReadWriteMany"]}}'
kubectl get pvc -n <namespace>
```

## Helpful tips: storage at a glance

1. anything a container writes without a volume disappears on restart, even though the Pod keeps running - only a volume makes written files survive;
2. `hostPath.type` tells Kubernetes what it should find at that path on the node, and the kubelet checks it at container start - claim the wrong kind and the Pod is created but never starts;
3. a PVC only binds to a PV whose `accessModes` cover everything the PVC requests - a PV missing even one requested mode is treated as no match, and the PVC sits `Pending` forever;
4. `subPath` must point at a path that already exists inside the volume - Kubernetes never creates missing folders for you at mount time; and
5. `nodeSelector`, `volumes`, and `volumeMounts` are all immutable on an existing standalone Pod - delete and recreate rather than editing in place.

Next up in the series: **5. Stateful** &mdash; StatefulSets, headless Services, and stable Pod identity.
