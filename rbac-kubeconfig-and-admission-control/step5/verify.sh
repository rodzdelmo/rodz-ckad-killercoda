#!/bin/bash
set -euo pipefail

namespace="web-ops"
ingress="legacy-ingress"

if ! kubectl get ingress "$ingress" -n "$namespace" >/dev/null 2>&1; then
  echo "Ingress $ingress does not exist yet in namespace $namespace - apply the fixed manifest."
  exit 1
fi

path_type="$(kubectl get ingress "$ingress" -n "$namespace" -o jsonpath='{.spec.rules[0].http.paths[0].pathType}' 2>/dev/null || true)"
if [[ -z "$path_type" ]]; then
  echo "Ingress $ingress's path must have a pathType set."
  exit 1
fi

backend_name="$(kubectl get ingress "$ingress" -n "$namespace" -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null || true)"
if [[ "$backend_name" != "web-app-svc" ]]; then
  echo "Ingress $ingress's backend.service.name must be web-app-svc (found '$backend_name')."
  exit 1
fi

backend_port="$(kubectl get ingress "$ingress" -n "$namespace" -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null || true)"
if [[ "$backend_port" != "80" ]]; then
  echo "Ingress $ingress's backend.service.port.number must be 80 (found '$backend_port')."
  exit 1
fi

echo "Success: $ingress was re-applied against the current API version."
exit 0
