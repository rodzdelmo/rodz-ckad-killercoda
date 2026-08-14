#!/bin/bash
set -euo pipefail

namespace="auth-ops"
deployment="mail-auth"
secret="mail-secret"
expected_value="M@ilKey789"

kubectl get secret "$secret" -n "$namespace" >/dev/null 2>&1
kubectl get deployment "$deployment" -n "$namespace" >/dev/null 2>&1

secret_value="$(kubectl get secret "$secret" -n "$namespace" -o jsonpath='{.data.SESSION_KEY}' | base64 -d)"
if [[ "$secret_value" != "$expected_value" ]]; then
  echo "Secret $secret must contain SESSION_KEY=$expected_value."
  exit 1
fi

ready_replicas="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.readyReplicas}')"
if [[ "${ready_replicas:-0}" -lt 1 ]]; then
  echo "Deployment $deployment must have at least one ready replica."
  exit 1
fi

pod="$(kubectl get pods -n "$namespace" -l app="$deployment" -o jsonpath='{.items[0].metadata.name}')"
actual_value="$(kubectl exec "$pod" -n "$namespace" -- printenv SESSION_KEY 2>/dev/null || true)"

if [[ "$actual_value" != "$expected_value" ]]; then
  echo "SESSION_KEY inside the $deployment Pod does not match Secret $secret."
  exit 1
fi

echo "Success: $deployment sources SESSION_KEY correctly from $secret."
exit 0
