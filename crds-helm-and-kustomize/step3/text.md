## Task

`/root/kustomize-lab/base/kustomization.yaml` lists two files under `resources:` - the Deployment and Service manifests that make up the `web-app` application. Try it:

```bash
cd /root/kustomize-lab
kubectl apply -k base
```

This fails - Kustomize can't find one of its listed files. Kustomize's `resources:` field needs an exact filename match to the files actually on disk - there's no fuzzy matching. If even one listed file doesn't exist, Kustomize can't build its resource list at all, and the whole `apply -k` fails before creating anything.

```bash
ls base/
cat base/kustomization.yaml
```

Compare what's listed against what's actually there, fix the mismatch in `base/kustomization.yaml`, and reapply:

```bash
kubectl apply -k base
```

When `kubectl get deployment web-app` and `kubectl get service web-app-svc` (in the `default` namespace) both succeed, click **Check**.
