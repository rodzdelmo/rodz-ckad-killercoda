## Task

`/root/manifest/legacy-ingress.yaml` is a manifest for an Ingress named `legacy-ingress` in namespace `web-ops`, written years ago against an old Kubernetes API. The cluster has since been upgraded, and nobody has re-applied this manifest since. Run it yourself and see what the API server says:

```bash
kubectl apply -f /root/manifest/legacy-ingress.yaml
```

Kubernetes periodically retires old API versions in favor of a newer, stable one - and the *shape* of the fields often changes too, not just the version string. This manifest uses `extensions/v1beta1`, which no longer exists on this cluster, and the old `backend.serviceName`/`backend.servicePort` fields, which `networking.k8s.io/v1` replaced with a nested `backend.service.name`/`backend.service.port.number`.

Fix `/root/manifest/legacy-ingress.yaml`:
- change `apiVersion` to `networking.k8s.io/v1`;
- change the backend to the new nested shape (`backend.service.name` / `backend.service.port.number`); and
- add `pathType: Prefix` to the path entry - `networking.k8s.io/v1` requires it on every path, with no default. You'll only find out about this one from the API server's error message after fixing the first two.

```bash
kubectl apply -f /root/manifest/legacy-ingress.yaml
```

When `kubectl get ingress legacy-ingress -n web-ops` succeeds, click **Check**.
