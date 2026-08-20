## Task

The retail team ran a blue-green cutover in namespace `retail-ops`: `checkout-blue` (v1) is the old Deployment, `checkout-green` (v2) is the new one, and both sit behind Service `checkout-service`.

```bash
kubectl get deploy -n retail-ops --show-labels
kubectl get svc checkout-service -n retail-ops -o yaml
kubectl get endpoints checkout-service -n retail-ops
```

A Service doesn't know about Deployments — it just matches its `spec.selector` against Pod labels and routes to whatever matches. `checkout-service`'s selector still reads `version: blue`, so every request still lands on the old Deployment even though `checkout-green` has been `Running` and `Ready` the whole time.

Patch the Service's selector so `version` reads `green` instead of `blue`:

```bash
kubectl patch service checkout-service -n retail-ops -p '{"spec":{"selector":{"version":"green"}}}'
```

When `kubectl get endpoints checkout-service -n retail-ops` lists only `checkout-green` Pod IPs, click **Check**.
