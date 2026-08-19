# Scenario complete

You added an emptyDir volume, fixed a hostPath type mismatch, resolved a PV/PVC access-mode and subPath problem, and corrected a StatefulSet's volume reference.

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
4. `subPath` must point at a path that already exists inside the volume - Kubernetes never creates missing folders for you at mount time;
5. `nodeSelector`, `volumes`, and `volumeMounts` are all immutable on an existing standalone Pod - delete and recreate rather than editing in place; and
6. a StatefulSet's `volumeClaimTemplates[].metadata.name` is the name its controller uses to auto-generate each replica's volume - a container's `volumeMounts[].name` must reference that exact name, or the generated Pod spec is invalid and the API server rejects it before a Pod ever exists.
