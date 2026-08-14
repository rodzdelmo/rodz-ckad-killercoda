#!/bin/bash
set -euo pipefail

namespace="uptime-ops"
pod="ping-api"

path="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.path}' 2>/dev/null || true)"

if [[ "$path" == "/healthz" ]]; then
  echo "Pod $pod's liveness probe still checks /healthz."
  exit 1
fi

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

restarts="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null || echo 0)"
if [[ "${restarts:-0}" -gt 3 ]]; then
  echo "Pod $pod is still restarting — double check the probe path."
  exit 1
fi

echo "Success: $pod's liveness probe is fixed and it is stable."
exit 0
