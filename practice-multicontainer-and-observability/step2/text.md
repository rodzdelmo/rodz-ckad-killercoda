## Task

In namespace `uptime-ops`, Pod `ping-api` keeps getting restarted by the kubelet even though the app itself never crashes.

```bash
kubectl describe pod ping-api -n uptime-ops
```

You should see repeated `Liveness probe failed: HTTP probe failed with statuscode: 404` — the probe checks `/healthz`, but this build of the app only serves `/`.

Correct the liveness probe's `path` to `/` and confirm the restart count stops climbing.

Useful command:

```bash
kubectl edit pod ping-api -n uptime-ops
```

When `ping-api` is `Running` with no new restarts for a while, click **Check**.
