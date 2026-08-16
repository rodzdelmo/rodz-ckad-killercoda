#!/bin/bash
set -euo pipefail

namespace="store-ops"
deployment="store-app"
bad_image="nginx:1.27-alpin"
expected_replicas="3"

actual_image="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.spec.containers[0].image}')"
ready_replicas="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.readyReplicas}')"

if [[ "$actual_image" == "$bad_image" ]]; then
  echo "Deployment $deployment is still on the broken image $bad_image — roll it back."
  exit 1
fi

if [[ "${ready_replicas:-0}" != "$expected_replicas" ]]; then
  echo "Deployment $deployment must have $expected_replicas ready replicas after rolling back."
  exit 1
fi

echo "Success: $deployment rolled back to $actual_image with $expected_replicas ready replicas."
exit 0
