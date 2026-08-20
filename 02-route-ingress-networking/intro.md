# 2. Route &mdash; Ingress Networking

*"Then we need users to reach it."*

Two independent problems, both about the Ingress controller routing traffic to a Service:

- `storefront-ingress` in `storefront-ops` routes to a Service name that doesn't exist; and
- `docs-ingress` in `docs-ops` forwards the full request path to its backend instead of stripping the route prefix first.

There's no Ingress controller running in this cluster, so these fixes are graded on the resource's fields, not live HTTP traffic - exactly what a `kubectl explain` / manifest-reading question on the exam looks like.

This is stop 2 in the CKAD Practice (Part 2) series - Release &rarr; Route &rarr; Protect &rarr; Store &rarr; Stateful &rarr; Secure &rarr; Manage.

Click **Start** when the terminal is ready.
