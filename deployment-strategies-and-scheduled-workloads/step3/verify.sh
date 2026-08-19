#!/bin/bash
set -euo pipefail

namespace="media-ops"
job="image-resize-batch"

parallelism="$(kubectl get job "$job" -n "$namespace" -o jsonpath='{.spec.parallelism}' 2>/dev/null || true)"
if [[ -z "$parallelism" || "$parallelism" -lt 2 ]]; then
  echo "Job $job's spec.parallelism must be at least 2 (found '${parallelism:-unset}')."
  exit 1
fi

if kubectl wait --for=condition=complete "job/$job" -n "$namespace" --timeout=180s >/dev/null 2>&1; then
  echo "Success: $job ran with parallelism=$parallelism and completed all 5 runs."
  exit 0
fi

succeeded="$(kubectl get job "$job" -n "$namespace" -o jsonpath='{.status.succeeded}' 2>/dev/null || echo 0)"
echo "Job $job hasn't completed yet (succeeded=${succeeded:-0}/5). Give it a bit more time and check again."
exit 1
