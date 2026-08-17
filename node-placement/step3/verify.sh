#!/bin/bash
set -euo pipefail

namespace="place-ops"
pod="web-podaffinity"
expected_label="cache"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

actual_label="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.affinity.podAffinity.requiredDuringSchedulingIgnoredDuringExecution[0].labelSelector.matchLabels.app}' 2>/dev/null || true)"
if [[ "$actual_label" != "$expected_label" ]]; then
  echo "Pod $pod's podAffinity labelSelector must match app=$expected_label (found app=$actual_label)."
  exit 1
fi

echo "Success: $pod is Running, correctly co-located with the cache Pod."
exit 0
