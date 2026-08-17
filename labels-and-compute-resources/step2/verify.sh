#!/bin/bash
set -euo pipefail

namespace="accounts-ops"
deployment="profile-api"
expected_req_cpu="100m"
expected_req_mem="128Mi"
expected_lim_cpu="500m"
expected_lim_mem="256Mi"

kubectl get deployment "$deployment" -n "$namespace" >/dev/null 2>&1

req_cpu="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')"
req_mem="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')"
lim_cpu="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}')"
lim_mem="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')"

if [[ "$req_cpu" != "$expected_req_cpu" ]]; then
  echo "requests.cpu must be $expected_req_cpu (found $req_cpu)."
  exit 1
fi

if [[ "$req_mem" != "$expected_req_mem" ]]; then
  echo "requests.memory must be $expected_req_mem (found $req_mem)."
  exit 1
fi

if [[ "$lim_cpu" != "$expected_lim_cpu" ]]; then
  echo "limits.cpu must be $expected_lim_cpu (found $lim_cpu)."
  exit 1
fi

if [[ "$lim_mem" != "$expected_lim_mem" ]]; then
  echo "limits.memory must be $expected_lim_mem (found $lim_mem)."
  exit 1
fi

ready_replicas="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.readyReplicas}')"
desired_replicas="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.replicas}')"
if [[ "${ready_replicas:-0}" != "$desired_replicas" ]]; then
  echo "Deployment $deployment must be fully rolled out ($ready_replicas/$desired_replicas ready)."
  exit 1
fi

echo "Success: $deployment is rolled out with the requested CPU/memory requests and limits."
exit 0
