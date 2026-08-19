## Task

`/root/manifest/nightly-cleanup.yaml` defines a CronJob named `nightly-cleanup` in namespace `batch-ops`. It was never applied. Try it yourself:

```bash
kubectl apply -f /root/manifest/nightly-cleanup.yaml
```

The API server rejects it outright — no CronJob object is created at all. A Job (and a CronJob's `jobTemplate`, which is just a Job spec) can't restart individual containers the way a normal Pod can; its pod template's `restartPolicy` must be `OnFailure` or `Never`. This manifest sets `restartPolicy: Always`, which is invalid for a Job's pod template, so the API server validates and rejects it at admission time, before any object — CronJob, Job, or Pod — ever exists on the cluster.

Fix `spec.jobTemplate.spec.template.spec.restartPolicy` in `/root/manifest/nightly-cleanup.yaml` to `OnFailure`, then reapply:

```bash
kubectl apply -f /root/manifest/nightly-cleanup.yaml
```

When `kubectl get cronjob nightly-cleanup -n batch-ops` succeeds, click **Check**.
