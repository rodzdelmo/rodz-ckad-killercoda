#!/bin/bash
set -euo pipefail

namespace="store-ops"
deployment="store-app"
expected_image="nginx:1.25"
expected_replicas="3"

kubectl get deployment "$deployment" -n "$namespace" >/dev/null 2>&1

actual_image="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.spec.containers[0].image}')"
ready_replicas="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.readyReplicas}')"

if [[ "$actual_image" != "$expected_image" ]]; then
  echo "Deployment $deployment must use image $expected_image."
  exit 1
fi

if [[ "${ready_replicas:-0}" != "$expected_replicas" ]]; then
  echo "Deployment $deployment must have $expected_replicas ready replicas."
  exit 1
fi

echo "Success: $deployment is running $expected_replicas ready replicas of $expected_image."
exit 0
