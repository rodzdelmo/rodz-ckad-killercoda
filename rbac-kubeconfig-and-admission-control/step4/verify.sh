#!/bin/bash
set -euo pipefail

namespace="production-ops"
deployment="checkout-service"

template_team_label="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.metadata.labels.team}' 2>/dev/null || true)"
if [[ -z "$template_team_label" ]]; then
  echo "Deployment $deployment's pod template (spec.template.metadata.labels) must carry a 'team' label."
  exit 1
fi

for i in $(seq 1 30); do
  ready_replicas="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo 0)"
  if [[ "${ready_replicas:-0}" -ge 2 ]]; then
    echo "Success: $deployment's Pods now carry the required label and are Running."
    exit 0
  fi
  sleep 5
done

echo "$deployment still doesn't have 2 ready replicas (found ${ready_replicas:-0}). Give the webhook-passing Pods a moment and check again."
exit 1
