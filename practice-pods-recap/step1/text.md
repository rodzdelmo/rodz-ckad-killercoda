## Task

The `intro-ops` namespace is supposed to have a diagnostic Pod matching this spec: name `api-recap`, image `nginx:1.25`, namespace `intro-ops`. Someone already created it, but forgot to pass `-n intro-ops`.

Find which namespace it actually landed in, delete it there, then create a new Pod matching the spec in `intro-ops`.

Useful commands:

```bash
kubectl get pods -A | grep api-recap
```

```bash
kubectl delete pod api-recap -n <namespace-you-found>
```

```bash
kubectl run api-recap --image=nginx:1.25 -n intro-ops
```

When `api-recap` is `Running` in `intro-ops` — and nowhere else — click **Check**.
