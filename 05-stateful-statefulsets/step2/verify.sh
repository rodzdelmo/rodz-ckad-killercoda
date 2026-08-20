#!/bin/bash
set -euo pipefail

namespace="database-ops"
statefulset="redis-cluster"

mount_name="$(kubectl get statefulset "$statefulset" -n "$namespace" -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[0].name}' 2>/dev/null || true)"
if [[ "$mount_name" != "data" ]]; then
  echo "Container's volumeMounts[].name must be 'data' (found '$mount_name')."
  exit 1
fi

for i in $(seq 1 30); do
  ready_replicas="$(kubectl get statefulset "$statefulset" -n "$namespace" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo 0)"
  if [[ "${ready_replicas:-0}" -ge 2 ]]; then
    echo "Success: $statefulset has $ready_replicas ready replicas."
    exit 0
  fi
  sleep 5
done

echo "$statefulset still doesn't have 2 ready replicas (found ${ready_replicas:-0}). Give it a bit more time and check again."
exit 1
