# CKAD Practice: Network Policies & Ingress

Three independent problems:

- `invoice-api` in `payments-ops` has no traffic restrictions at all, and security wants it locked down to a single caller;
- `storefront-ingress` in `storefront-ops` routes to a Service name that doesn't exist; and
- `docs-ingress` in `docs-ops` forwards the full request path to its backend instead of stripping the route prefix first.

There's no Ingress controller running in this cluster, so these Ingress fixes are graded on the resource's fields, not live HTTP traffic - exactly what a `kubectl explain` / manifest-reading question on the exam looks like.

Click **Start** when the terminal is ready.
