## Task

Before writing a manifest by hand, `kubectl` can generate one for you.

`--dry-run=client -o yaml` builds the object **client-side** and prints its YAML — it never contacts the API server, so nothing is actually created yet.

```bash
kubectl run web-dryrun --image=nginx:1.27-alpine -n ckad-lab --dry-run=client -o yaml
```

Redirect that output to a file, then apply the file to actually create the Pod:

```bash
kubectl run web-dryrun --image=nginx:1.27-alpine -n ckad-lab --dry-run=client -o yaml > /root/web-dryrun.yaml
kubectl apply -f /root/web-dryrun.yaml
```

This is the fastest way to turn a one-off imperative command into a starting point for a real, version-controllable manifest.

When `web-dryrun` is `Running` in `ckad-lab`, click **Check**.
