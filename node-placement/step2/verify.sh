#!/bin/bash
set -euo pipefail

namespace="place-ops"
pod="web-nodeaffinity"
expected_zone="us-east-1a"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

actual_zone="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0]}' 2>/dev/null || true)"
if [[ "$actual_zone" != "$expected_zone" ]]; then
  echo "Pod $pod's nodeAffinity zone value must be $expected_zone (found $actual_zone)."
  exit 1
fi

echo "Success: $pod is Running with a matching nodeAffinity rule."
exit 0
