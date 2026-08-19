#!/bin/bash
set -euo pipefail

kubeconfig="/root/practice-kubeconfig"

context_user="$(kubectl --kubeconfig="$kubeconfig" config view -o jsonpath='{.contexts[?(@.name=="cluster-prod")].context.user}' 2>/dev/null || true)"
if [[ "$context_user" != "engineer-admin" ]]; then
  echo "cluster-prod context's user must be engineer-admin (found '$context_user')."
  exit 1
fi

if ! kubectl get deployment new-deployment -n prod-ops >/dev/null 2>&1; then
  echo "Deployment new-deployment must exist in namespace prod-ops - apply /root/manifest/new-deployment.yaml with the fixed kubeconfig."
  exit 1
fi

echo "Success: cluster-prod now uses engineer-admin, and new-deployment was created."
exit 0
