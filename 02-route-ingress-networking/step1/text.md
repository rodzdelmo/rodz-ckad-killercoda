## Task

Ingress `storefront-ingress` in namespace `storefront-ops` is meant to route `storefront.example.com` traffic to Service `storefront-svc`.

```bash
kubectl get svc -n storefront-ops
kubectl get ingress storefront-ingress -n storefront-ops -o yaml
```

Kubernetes doesn't check that an Ingress's backend Service name actually exists when you `apply` the manifest - the Ingress object is accepted either way. A typo'd Service name only shows up once real traffic tries to flow through and the ingress controller can't find a matching Service to send it to.

Compare the Service's name against the one referenced in the Ingress's backend (`spec.rules[].http.paths[].backend.service.name`), and fix the mismatch in `/root/manifest/storefront-ingress.yaml`:

```bash
kubectl apply -f /root/manifest/storefront-ingress.yaml
```

When the Ingress's backend service name matches the actual Service, click **Check**.
