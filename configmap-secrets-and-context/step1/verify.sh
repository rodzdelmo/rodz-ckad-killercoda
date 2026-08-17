#!/bin/bash
set -euo pipefail

namespace="config-ops"
pod="app-pod"
configmap="app-config"

kubectl get configmap "$configmap" -n "$namespace" >/dev/null 2>&1

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

expected_value="$(kubectl get configmap "$configmap" -n "$namespace" -o jsonpath='{.data.APP_MODE}')"
actual_value="$(kubectl exec "$pod" -n "$namespace" -- printenv APP_MODE 2>/dev/null || true)"

if [[ -z "$actual_value" ]]; then
  echo "APP_MODE is not set inside $pod."
  exit 1
fi

if [[ "$actual_value" != "$expected_value" ]]; then
  echo "APP_MODE inside $pod does not match ConfigMap $configmap."
  exit 1
fi

echo "Success: $pod loads APP_MODE=$actual_value from ConfigMap $configmap."
exit 0
