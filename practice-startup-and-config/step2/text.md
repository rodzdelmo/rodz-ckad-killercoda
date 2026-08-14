## Task

Pod `hello-service` in namespace `hello-ops` should print a custom greeting sourced from ConfigMap `hello-config` (key `GREETING_MESSAGE`), but:

```bash
kubectl exec hello-service -n hello-ops -- printenv GREETING_MESSAGE
```

returns nothing.

Compare the Pod's env reference against the ConfigMap's actual key:

```bash
kubectl get configmap hello-config -n hello-ops -o yaml
kubectl get pod hello-service -n hello-ops -o yaml
```

Fix the mismatched key name in the Pod spec.

> **Note**: `env` is also set at container creation and is immutable in place — delete the Pod and re-apply your corrected manifest.

When `kubectl exec hello-service -n hello-ops -- printenv GREETING_MESSAGE` prints the greeting, click **Check**.
