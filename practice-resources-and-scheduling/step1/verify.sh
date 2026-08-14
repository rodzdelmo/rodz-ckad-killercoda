#!/bin/bash
set -euo pipefail

namespace="ledger-ops"
pod="ledger-worker"
answer_file="/root/ledger-worker-sa.txt"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

req_cpu="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[0].resources.requests.cpu}')"
req_mem="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[0].resources.requests.memory}')"
lim_cpu="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[0].resources.limits.cpu}')"
lim_mem="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[0].resources.limits.memory}')"

if [[ "$req_cpu" != "500m" || "$req_mem" != "512Mi" ]]; then
  echo "requests must be cpu=500m, memory=512Mi (found cpu=$req_cpu, memory=$req_mem)."
  exit 1
fi

if [[ "$lim_cpu" != "1" && "$lim_cpu" != "1000m" ]]; then
  echo "limits.cpu must be 1000m (found $lim_cpu)."
  exit 1
fi

if [[ "$lim_mem" != "1Gi" ]]; then
  echo "limits.memory must be 1Gi (found $lim_mem)."
  exit 1
fi

expected_sa="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.serviceAccountName}')"

if [[ ! -f "$answer_file" ]]; then
  echo "$answer_file does not exist."
  exit 1
fi

actual_sa="$(cat "$answer_file")"
if [[ "$actual_sa" != "$expected_sa" ]]; then
  echo "$answer_file must contain exactly: $expected_sa"
  exit 1
fi

echo "Success: resources updated and ServiceAccount correctly identified as $expected_sa."
exit 0
