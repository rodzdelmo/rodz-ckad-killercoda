#!/bin/bash
set -euo pipefail

namespace="database-ops"
pod="redis-cluster-0"
pvc="data-redis-cluster-0"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace (found '$phase')."
  exit 1
fi

if ! kubectl get pvc "$pvc" -n "$namespace" >/dev/null 2>&1; then
  echo "PVC $pvc must still exist in namespace $namespace."
  exit 1
fi

volume_name="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.volumes[?(@.persistentVolumeClaim.claimName=="'"$pvc"'")].persistentVolumeClaim.claimName}' 2>/dev/null || true)"
if [[ "$volume_name" != "$pvc" ]]; then
  echo "Pod $pod must be bound to PVC $pvc (its original volume claim)."
  exit 1
fi

echo "Success: $pod kept its stable identity and reattached to $pvc."
exit 0
