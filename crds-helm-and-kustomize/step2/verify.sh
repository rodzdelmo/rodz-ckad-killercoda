#!/bin/bash
set -euo pipefail

namespace="tools-ops"
release="internal-api"

status="$(helm status "$release" -n "$namespace" -o json 2>/dev/null | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4 || true)"
if [[ "$status" != "deployed" ]]; then
  echo "Helm release $release must show STATUS: deployed in namespace $namespace (found '${status:-not installed}')."
  exit 1
fi

for i in $(seq 1 30); do
  ready="$(kubectl get pods -n "$namespace" -l app.kubernetes.io/instance="$release" -o jsonpath='{.items[*].status.containerStatuses[*].ready}' 2>/dev/null || true)"
  if [[ -n "$ready" && "$ready" != *"false"* ]]; then
    echo "Success: $release is deployed and its Pod is Ready."
    exit 0
  fi
  sleep 5
done

echo "$release's Pod isn't Ready yet. Give it a moment and check again."
exit 1
