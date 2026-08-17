#!/bin/bash
set -euo pipefail

namespace="place-ops"
pod="web-nodeselector"
expected_disktype="ssd"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

actual_disktype="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.nodeSelector.disktype}' 2>/dev/null || true)"
if [[ "$actual_disktype" != "$expected_disktype" ]]; then
  echo "Pod $pod's nodeSelector.disktype must be $expected_disktype (found $actual_disktype)."
  exit 1
fi

echo "Success: $pod is Running with a matching nodeSelector."
exit 0
