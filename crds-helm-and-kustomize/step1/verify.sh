#!/bin/bash
set -euo pipefail

namespace="tools-ops"
name="orders-db"

if ! kubectl get database "$name" -n "$namespace" >/dev/null 2>&1; then
  echo "Database $name does not exist yet in namespace $namespace - apply the fixed manifest."
  exit 1
fi

engine="$(kubectl get database "$name" -n "$namespace" -o jsonpath='{.spec.engine}' 2>/dev/null || true)"
if [[ "$engine" != "postgres" ]]; then
  echo "Database $name's spec.engine must be 'postgres' (found '$engine')."
  exit 1
fi

echo "Success: $name passed CRD schema validation with engine=postgres."
exit 0
