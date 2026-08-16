#!/bin/bash
set -euo pipefail

namespace="ckad-lab"
pod="web-declarative"
expected_image="nginx:1.27-alpine"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
image="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[0].image}' 2>/dev/null || true)"

if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

if [[ "$image" != "$expected_image" ]]; then
  echo "Pod $pod must use image $expected_image."
  exit 1
fi

echo "Success: $pod is Running in $namespace."
exit 0
