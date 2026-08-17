#!/bin/bash
set -euo pipefail

namespace="place-ops"
pod="web-podantiaffinity"
expected_label="cache"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

actual_label="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].values[0]}' 2>/dev/null || true)"
if [[ "$actual_label" != "$expected_label" ]]; then
  echo "Pod $pod's podAntiAffinity rule must target app=$expected_label (found app=$actual_label)."
  exit 1
fi

echo "Success: $pod's podAntiAffinity rule correctly targets the cache Pod."
exit 0
