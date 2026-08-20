#!/bin/bash
set -euo pipefail

namespace="database-ops"
service="redis-cluster"

cluster_ip="$(kubectl get svc "$service" -n "$namespace" -o jsonpath='{.spec.clusterIP}' 2>/dev/null || true)"
if [[ "$cluster_ip" != "None" ]]; then
  echo "Service $service's spec.clusterIP must be None (found '$cluster_ip')."
  exit 1
fi

echo "Success: $service is now a headless Service."
exit 0
