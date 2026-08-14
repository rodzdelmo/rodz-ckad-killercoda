#!/bin/bash
set -euo pipefail

namespace="hello-ops"
pod="hello-service"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"

if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

expected_value="$(kubectl get configmap hello-config -n "$namespace" -o jsonpath='{.data.GREETING_MESSAGE}')"
actual_value="$(kubectl exec "$pod" -n "$namespace" -- printenv GREETING_MESSAGE 2>/dev/null || true)"

if [[ -z "$actual_value" ]]; then
  echo "GREETING_MESSAGE is not set inside $pod."
  exit 1
fi

if [[ "$actual_value" != "$expected_value" ]]; then
  echo "GREETING_MESSAGE inside $pod does not match the ConfigMap value."
  exit 1
fi

echo "Success: GREETING_MESSAGE resolves correctly inside $pod."
exit 0
