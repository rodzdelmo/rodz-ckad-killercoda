# CKAD Practice: Deployment Strategies & Scheduled Workloads

Four independent problems, each in its own namespace:

- a blue-green cutover in `retail-ops` that's still sending traffic to the old color;
- a canary rollout in `canary-ops` where the canary Pods are running but never get any traffic;
- a Job in `media-ops` that's stuck running one Pod at a time when it should run two; and
- a CronJob in `batch-ops` whose manifest the API server won't even accept.

Click **Start** when the terminal is ready.
