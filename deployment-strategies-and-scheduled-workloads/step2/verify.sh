#!/bin/bash
set -euo pipefail

namespace="canary-ops"

canary_app_label="$(kubectl get deploy recs-canary -n "$namespace" -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null || true)"
if [[ "$canary_app_label" != "recs" ]]; then
  echo "Deployment recs-canary's pod template must carry label app=recs (found '$canary_app_label')."
  exit 1
fi

for i in $(seq 1 30); do
  endpoint_count="$(kubectl get endpoints recs-service -n "$namespace" -o jsonpath='{.subsets[*].addresses}' 2>/dev/null | grep -o '"ip"' | wc -l | tr -d ' ')"
  if [[ "$endpoint_count" == "4" ]]; then
    echo "Success: recs-service now routes to all 4 stable+canary Pods."
    exit 0
  fi
  sleep 5
done

echo "recs-service still doesn't show 4 endpoints (found $endpoint_count). Give the new canary Pods a moment to become Ready and check again."
exit 1
