#!/bin/bash
set -euo pipefail

namespace="store-ops"
deployment="store-app"
answer_file="/root/store-app.txt"

actual_image="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.spec.containers[0].image}')"
expected_tag="${actual_image##*:}"

if [[ ! -f "$answer_file" ]]; then
  echo "$answer_file does not exist."
  exit 1
fi

actual_tag="$(cat "$answer_file")"

if [[ "$actual_tag" != "$expected_tag" ]]; then
  echo "$answer_file must contain exactly: $expected_tag"
  exit 1
fi

echo "Success: $answer_file correctly identifies tag $expected_tag."
exit 0
