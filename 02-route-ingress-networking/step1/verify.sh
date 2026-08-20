#!/bin/bash
set -euo pipefail

namespace="storefront-ops"
ingress="storefront-ingress"

if ! kubectl get svc storefront-svc -n "$namespace" >/dev/null 2>&1; then
  echo "Service storefront-svc must exist in $namespace (don't rename the Service - fix the Ingress)."
  exit 1
fi

backend_name="$(kubectl get ingress "$ingress" -n "$namespace" -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null || true)"
if [[ "$backend_name" != "storefront-svc" ]]; then
  echo "Ingress $ingress's backend service name must be 'storefront-svc' (found '$backend_name')."
  exit 1
fi

echo "Success: $ingress now points at the correct Service."
exit 0
