## Task

`quote-cache-warmer` in namespace `content-ops` writes a cache file to `/var/cache/quotes/index.db` the first time it starts. Rebuilding it takes about 90 seconds, so the team wants that cache to survive a restart instead of being rebuilt every time.

```bash
kubectl get deployment quote-cache-warmer -n content-ops -o yaml
```

Check the Deployment's Pod template - look at its `volumes` and the container's `volumeMounts` to see whether a mount path of `/var/cache/quotes` is configured at all. It isn't: anything a container writes without a volume disappears the moment the container restarts, even though the Pod itself keeps running.

Edit `/root/manifest/quote-cache-warmer.yaml`: add an `emptyDir` volume, and add a matching `volumeMounts` entry to the *existing* container (alongside its current `image`/`command`, not replacing them) so it mounts at `/var/cache/quotes`. If you're not sure of the exact `volumes`/`volumeMounts` YAML shape, check the [Kubernetes documentation on emptyDir volumes](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir).

```bash
kubectl apply -f /root/manifest/quote-cache-warmer.yaml
```

This is a Deployment, so the field change just rolls a new Pod - no manual delete needed. When the new Pod is `Running` with the volume mounted, click **Check**.
