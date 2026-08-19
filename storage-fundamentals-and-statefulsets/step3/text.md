## Task

Pod `report-writer` in namespace `analytics-ops` writes reports into PVC `analytics-writer`, using a `subPath` so its output lands in its own subdirectory instead of the PVC's root. An init container on the Pod already prepares the real directory structure (`reports/2024`) on the volume before the main container starts. This unfolds in two stages.

**Stage 1**: PVC `analytics-writer` sits in `Pending` forever, and the Pod itself never gets past that either.

```bash
kubectl get pvc analytics-writer -n analytics-ops
kubectl get pv analytics-pv -o yaml
```

A PVC only binds to a PV whose `accessModes` cover everything the PVC requests - a PV missing even one requested mode is treated as no match at all. `analytics-writer` requests `ReadWriteMany`; `analytics-pv` only offers `ReadWriteOnce`. Add the missing mode:

```bash
kubectl patch pv analytics-pv --type=merge -p '{"spec":{"accessModes":["ReadWriteOnce","ReadWriteMany"]}}'
```

**Stage 2**: Once `analytics-writer` shows `Bound`, a second problem appears - the Pod is stuck in `ContainerCreating`.

```bash
kubectl get pvc analytics-writer -n analytics-ops
kubectl describe pod report-writer -n analytics-ops
```

`subPath` must point at a path that *already exists* inside the volume; Kubernetes won't create missing folders for you at mount time. The init container created `reports/2024`, but the main container's `volumeMounts[].subPath` reads `reports/2025` - a typo'd path fails the mount outright even though the correct folder exists one character away.

`volumeMounts` is immutable on an existing Pod, so fix `/root/manifest/report-writer.yaml` (`subPath: reports/2024`), then delete and recreate:

```bash
kubectl delete pod report-writer -n analytics-ops
kubectl apply -f /root/manifest/report-writer.yaml
```

When `report-writer` is `Running`, click **Check**.
