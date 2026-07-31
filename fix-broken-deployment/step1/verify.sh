#!/bin/bash
set -euo pipefail

namespace="ckad-lab"
deployment="web"
expected_image="nginx:1.27-alpine"
expected_replicas="3"

kubectl get namespace "$namespace" >/dev/null 2>&1
kubectl get deployment "$deployment" -n "$namespace" >/dev/null 2>&1

actual_image="$(
  kubectl get deployment "$deployment" -n "$namespace"     -o jsonpath='{.spec.template.spec.containers[?(@.name=="nginx")].image}'
)"

desired_replicas="$(
  kubectl get deployment "$deployment" -n "$namespace"     -o jsonpath='{.spec.replicas}'
)"

ready_replicas="$(
  kubectl get deployment "$deployment" -n "$namespace"     -o jsonpath='{.status.readyReplicas}'
)"

available_replicas="$(
  kubectl get deployment "$deployment" -n "$namespace"     -o jsonpath='{.status.availableReplicas}'
)"

if [[ "$actual_image" != "$expected_image" ]]; then
  echo "The nginx container must use image $expected_image."
  exit 1
fi

if [[ "$desired_replicas" != "$expected_replicas" ]]; then
  echo "The Deployment must request $expected_replicas replicas."
  exit 1
fi

if [[ "${ready_replicas:-0}" != "$expected_replicas" ]]; then
  echo "Not all replicas are ready yet."
  exit 1
fi

if [[ "${available_replicas:-0}" != "$expected_replicas" ]]; then
  echo "Not all replicas are available yet."
  exit 1
fi

echo "Success: the Deployment uses the correct image and all three replicas are ready."
exit 0
