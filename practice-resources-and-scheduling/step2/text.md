## Task

Nodes in the `gpu-ops` pool are tainted `dedicated=gpu:NoSchedule`. Pod `gpu-idle` already runs there successfully; Pod `gpu-job` was just submitted to join it, but never starts.

```bash
kubectl get pods -n gpu-ops
```

Compare `gpu-idle` against `gpu-job` to see what `gpu-job` is missing, then add the matching `tolerations` entry to its Pod spec so it schedules successfully.

> **Note**: `tolerations` is also immutable once a Pod is created — delete `gpu-job` and re-apply the corrected manifest. `kubectl get pod <name> -n gpu-ops -o yaml` is a useful command here.

When `gpu-job` is `Running`, click **Check**.
