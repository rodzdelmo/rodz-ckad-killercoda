#!/bin/bash
set -euo pipefail

namespace="gpu-ops"
pod="gpu-job"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"

if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

echo "Success: $pod is Running in $namespace."
exit 0
