# CKAD Practice: Storage Fundamentals & StatefulSets

Four independent storage problems:

- `quote-cache-warmer` in `content-ops` rebuilds its cache from scratch on every restart because nothing is mounted at all;
- `node-inspector` in `platform-ops` won't start because its `hostPath` volume declares the wrong type;
- `report-writer` in `analytics-ops` is stuck first on an unbound PVC, then on a `subPath` that doesn't exist; and
- `redis-cluster`, a StatefulSet in `database-ops`, can't create a single Pod because its container references a volume name that doesn't match its `volumeClaimTemplates`.

Click **Start** when the terminal is ready.
