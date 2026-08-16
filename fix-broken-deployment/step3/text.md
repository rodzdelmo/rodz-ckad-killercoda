## Task

A third Pod, `web-typo`, was already created in `ckad-lab`, but it never reaches `Running`.

Diagnose it:

```bash
kubectl describe pod web-typo -n ckad-lab
```

You should find an invalid image reference — the tag has a typo (a missing letter on the alpine tag).

Fix the typo in `/root/manifest/web-typo.yaml`, then apply it:

```bash
kubectl apply -f /root/manifest/web-typo.yaml
```

When `web-typo` is `Running` in `ckad-lab`, click **Check**.
