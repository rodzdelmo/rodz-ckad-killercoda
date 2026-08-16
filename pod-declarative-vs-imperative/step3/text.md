## Task

Now create the **same** Pod **declaratively**. A manifest has already been written for you at `/root/manifest/web-pod.yaml` — try applying it:

```bash
kubectl apply -f /root/manifest/web-pod.yaml
```

You should hit an error. Find the missing YAML list marker under `containers` in the manifest, fix it, then apply successfully.

- name: `web-declarative`
- image: `nginx:1.27-alpine`
- namespace: `ckad-lab`

When `web-declarative` is `Running` in `ckad-lab`, click **Check**.
