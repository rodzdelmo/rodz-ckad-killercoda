#!/bin/bash
set -euo pipefail

namespace="store-ops"
deployment="store-app"
old_replicaset="store-replicas"
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

if kubectl get replicaset "$old_replicaset" -n "$namespace" >/dev/null 2>&1; then
  echo "The original ReplicaSet $old_replicaset must be deleted once $deployment is up."
  exit 1
fi

echo "Success: $deployment replaces $old_replicaset with $expected_replicas ready replicas."
exit 0
