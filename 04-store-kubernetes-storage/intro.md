# 4. Store &mdash; Kubernetes Storage

*"Then we need somewhere to store data."*

Three independent storage problems:

- `quote-cache-warmer` in `content-ops` rebuilds its cache from scratch on every restart because nothing is mounted at all;
- `node-inspector` in `platform-ops` won't start because its `hostPath` volume declares the wrong type; and
- `report-writer` in `analytics-ops` is stuck first on an unbound PVC, then on a `subPath` that doesn't exist.

This is stop 4 in the CKAD Practice (Part 2) series - Release &rarr; Route &rarr; Protect &rarr; Store &rarr; Stateful &rarr; Secure &rarr; Manage.

Click **Start** when the terminal is ready.
