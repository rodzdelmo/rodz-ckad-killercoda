# 1. Release &mdash; Deployment Strategies & Scheduled Workloads

*"First, we release our application."*

Four independent problems, each in its own namespace:

- a blue-green cutover in `retail-ops` that's still sending traffic to the old color;
- a canary rollout in `canary-ops` where the canary Pods are running but never get any traffic;
- a Job in `media-ops` that's stuck running one Pod at a time when it should run two; and
- a CronJob in `batch-ops` whose manifest the API server won't even accept.

This is the first stop in the CKAD Practice (Part 2) series - Release &rarr; Route &rarr; Protect &rarr; Store &rarr; Stateful &rarr; Secure &rarr; Manage. Each activity in the series stands on its own, but read in order, they trace the life of an application from first deploy to full production hardening.

Click **Start** when the terminal is ready.
