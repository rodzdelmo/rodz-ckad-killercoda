#!/bin/bash
set -euo pipefail

namespace="jobs-ops"
pod="job-runner"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
restarts="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null || echo 0)"
actual_command="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[0].command}' 2>/dev/null || true)"

if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace."
  exit 1
fi

if [[ "$actual_command" == *"run.sh"* ]]; then
  echo "Pod $pod is still using the broken command."
  exit 1
fi

if [[ "${restarts:-0}" -gt 3 ]]; then
  echo "Pod $pod is still restarting — the command may still be wrong."
  exit 1
fi

echo "Success: $pod is Running with a working startup command."
exit 0
