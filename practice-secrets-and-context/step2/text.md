## Task

ConfigMap `app-config` already exists in namespace `config-ops` with key `APP_MODE=production`.

Create a Pod named `app-pod` (image `busybox:1.36`, command `sh -c "sleep 3600"`) that loads **every** key from that ConfigMap as environment variables.

A Pod's `env` can't be patched in place once it's running, so generate the manifest first instead of using `kubectl run` directly:

```bash
kubectl run app-pod --image=busybox:1.36 -n config-ops --dry-run=client -o yaml \
  --command -- sh -c "sleep 3600" > /root/app-pod.yaml
```

Edit `/root/app-pod.yaml` and add an `envFrom` entry under the container:

```yaml
      envFrom:
        - configMapRef:
            name: app-config
```

Then apply it:

```bash
kubectl apply -f /root/app-pod.yaml
```

When `kubectl exec app-pod -n config-ops -- printenv APP_MODE` prints `production`, click **Check**.
