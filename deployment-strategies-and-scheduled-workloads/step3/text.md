## Task

Two Jobs are running in namespace `media-ops`. `thumbnail-batch` is already working as expected, processing 6 items with 3 running concurrently. Job `image-resize-batch` is meant to process 5 images with up to 2 running concurrently, but only ever shows 1.

```bash
kubectl get job -n media-ops -o yaml
kubectl get pods -n media-ops -l job-name=image-resize-batch
```

Compare `image-resize-batch` to the already-working `thumbnail-batch`: `completions` (total successful runs needed) and `parallelism` (how many Pods run at once) are two separate settings, and leaving one out doesn't error — it just silently defaults to `1`. `image-resize-batch` has `completions: 5` but no `parallelism` at all.

Unlike most Pod-template fields, a Job's `parallelism` is mutable — patch it directly on the running Job, no delete/recreate needed:

```bash
kubectl patch job image-resize-batch -n media-ops -p '{"spec":{"parallelism":2}}'
```

When `image-resize-batch` shows `spec.parallelism: 2` and eventually completes all 5, click **Check**.
