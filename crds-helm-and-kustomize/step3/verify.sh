#!/bin/bash
set -euo pipefail

namespace="default"

if ! kubectl get deployment web-app -n "$namespace" >/dev/null 2>&1; then
  echo "Deployment web-app does not exist in namespace $namespace - fix base/kustomization.yaml and reapply with kubectl apply -k base."
  exit 1
fi

if ! kubectl get service web-app-svc -n "$namespace" >/dev/null 2>&1; then
  echo "Service web-app-svc does not exist in namespace $namespace - fix base/kustomization.yaml and reapply with kubectl apply -k base."
  exit 1
fi

ready_replicas="$(kubectl get deployment web-app -n "$namespace" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo 0)"
if [[ "${ready_replicas:-0}" -lt 1 ]]; then
  echo "Deployment web-app must have at least one ready replica."
  exit 1
fi

echo "Success: both resources were created via kubectl apply -k base."
exit 0
