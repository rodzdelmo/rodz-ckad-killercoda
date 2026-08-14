#!/bin/bash
set -euo pipefail

namespace="edge-ops"
pod="web-with-cache"
answer_file="/root/web-with-cache.txt"

expected_init="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.initContainers[0].name}')"
expected_main="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[0].name}')"

if [[ ! -f "$answer_file" ]]; then
  echo "$answer_file does not exist."
  exit 1
fi

line1="$(sed -n '1p' "$answer_file")"
line2="$(sed -n '2p' "$answer_file")"

if [[ "$line1" != "$expected_init" ]]; then
  echo "Line 1 must be the init container's name: $expected_init"
  exit 1
fi

if [[ "$line2" != "$expected_main" ]]; then
  echo "Line 2 must be the long-running container's name: $expected_main"
  exit 1
fi

echo "Success: $answer_file correctly identifies both containers."
exit 0
