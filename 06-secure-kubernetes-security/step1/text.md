## Task

CI service account `ci-deployer` in namespace `pipelines-ops` is bound to Role `deployment-manager` via a RoleBinding. It can already `get`/`list`/`watch` Deployments - enough to inspect and monitor them. The nightly pipeline's final step is supposed to restart Deployment `api` so it picks up a freshly-updated ConfigMap, but that step fails with a `Forbidden` error.

```bash
kubectl get role deployment-manager -n pipelines-ops -o yaml
kubectl auth can-i patch deployments -n pipelines-ops --as=system:serviceaccount:pipelines-ops:ci-deployer
kubectl auth can-i list deployments -n pipelines-ops --as=system:serviceaccount:pipelines-ops:ci-deployer
```

RBAC is deny-by-default - a ServiceAccount can only do exactly what a Role/RoleBinding explicitly lists, verb by verb (`get`, `list`, `watch`, `patch`, ...). Being allowed to *view* a resource says nothing about being allowed to *modify* it. `deployment-manager`'s `rules` only grant `get`, `list`, and `watch` on `deployments` - restarting one requires `patch` too (that's what `kubectl rollout restart` sends under the hood).

Add the missing verb:

```bash
kubectl patch role deployment-manager -n pipelines-ops --type=json \
  -p='[{"op":"add","path":"/rules/0/verbs/-","value":"patch"}]'
```

When `kubectl auth can-i patch deployments -n pipelines-ops --as=system:serviceaccount:pipelines-ops:ci-deployer` prints `yes`, click **Check**.
