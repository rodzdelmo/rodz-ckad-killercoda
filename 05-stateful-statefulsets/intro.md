# 5. Stateful &mdash; StatefulSets

*"Some applications need stable identities and dedicated storage."*

Three connected problems on the same StatefulSet, `redis-cluster` in namespace `database-ops`:

- its governing Service isn't actually headless, so per-Pod DNS identity doesn't work;
- its container references a volume name that doesn't match its `volumeClaimTemplates`, so no Pod can even be created; and
- once both are fixed, you'll prove to yourself that a StatefulSet Pod's name and storage survive being deleted - the whole reason StatefulSets exist.

This is stop 5 in the CKAD Practice (Part 2) series - Release &rarr; Route &rarr; Protect &rarr; Store &rarr; Stateful &rarr; Secure &rarr; Manage.

Click **Start** when the terminal is ready.
