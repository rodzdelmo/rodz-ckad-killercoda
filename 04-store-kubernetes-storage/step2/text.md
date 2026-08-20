## Task

`node-inspector` is a diagnostic Pod in namespace `platform-ops` that mounts a `hostPath` volume to read `/var/log` from the node it lands on. The Pod won't even start.

```bash
kubectl get pod node-inspector -n platform-ops
kubectl describe pod node-inspector -n platform-ops
```

The event reads something like `... /var/log is not a file`. `hostPath.type` tells Kubernetes what it should find at that path on the node, and it checks - claim the wrong kind and the Pod is rejected before it starts. `/var/log` on this node is a directory, but the manifest declares `type: File`.

`volumes` is immutable on an existing standalone Pod, so it can't just be edited in place. Fix `/root/manifest/node-inspector.yaml` (`hostPath.type` should be `Directory`), then delete and replace the failed Pod:

```bash
kubectl delete pod node-inspector -n platform-ops
kubectl apply -f /root/manifest/node-inspector.yaml
```

When `node-inspector` is `Running`, click **Check**.
