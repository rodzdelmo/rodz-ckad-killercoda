## Task

A teammate's manifest for a second diagnostic Pod in `intro-ops` won't apply at all. Try it:

```bash
kubectl apply -f /root/manifest/ping-pod.yaml
```

You should hit an error. Find the missing YAML list marker in the manifest, fix it, then apply successfully.

When the Pod `ping` is `Running` in `intro-ops`, click **Check**.
