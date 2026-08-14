## Task

Pod `job-runner` in namespace `jobs-ops` is stuck in `CrashLoopBackOff`.

Useful commands:

```bash
kubectl get pod job-runner -n jobs-ops
kubectl logs job-runner -n jobs-ops
```

You should see something like `exec: "run.sh": stat run.sh: no such file or directory`. The container's real entrypoint should just sleep, e.g. `sh -c "sleep 3600"`.

Correct the Pod's `command` field to fix it.

> **Note**: `command` is immutable once a Pod is created — `kubectl edit`/`apply` in place will be rejected. Delete the Pod first, then re-apply your corrected manifest.

When `job-runner` is `Running` with the corrected command, click **Check**.
