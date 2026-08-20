# 7. Manage &mdash; CRDs, Helm & Kustomize

*"And once our configuration becomes large, we need tools like Helm and Kustomize to manage it."*

Three independent problems:

- a new `Database` custom resource, `orders-db`, was just submitted in namespace `tools-ops` and the operator won't pick it up;
- your onboarding checklist's `helm install` command fails, even though every other engineer already has it working; and
- `kubectl apply -k base` fails outright because one of the files Kustomize expects doesn't match what's actually on disk.

This is the last stop in the CKAD Practice (Part 2) series - Release &rarr; Route &rarr; Protect &rarr; Store &rarr; Stateful &rarr; Secure &rarr; Manage.

Click **Start** when the terminal is ready.
