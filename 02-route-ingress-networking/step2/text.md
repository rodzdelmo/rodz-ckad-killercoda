## Task

Ingress `docs-ingress` in namespace `docs-ops` routes path `/docs(/|$)(.*)` to Service `docs-svc`, but the backend receives the full, un-rewritten path - `/docs/getting-started` instead of `/getting-started`.

```bash
kubectl get ingress docs-ingress -n docs-ops -o yaml
```

`rewrite-target` isn't a core Kubernetes field - for the NGINX ingress controller it's the annotation `nginx.ingress.kubernetes.io/rewrite-target`, and it's what tells the controller to replace the matched path with a captured group before forwarding to the backend. This Ingress's path uses a capture group (`(.*)`) but never says what to rewrite it *to*.

Add the missing annotations to `/root/manifest/docs-ingress.yaml`:

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/use-regex: "true"
```

(`$2` because the path has two capture groups - `(/|$)` and `(.*)` - and it's the second one, the part after `/docs`, that should be forwarded.)

```bash
kubectl apply -f /root/manifest/docs-ingress.yaml
```

When `docs-ingress` carries both annotations, click **Check**.
