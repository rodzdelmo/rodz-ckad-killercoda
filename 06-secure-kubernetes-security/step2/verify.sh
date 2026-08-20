#!/bin/bash
set -euo pipefail

kubeconfig="/root/practice-kubeconfig"

current_context="$(kubectl --kubeconfig="$kubeconfig" config current-context 2>/dev/null || true)"
if [[ "$current_context" != "cluster-prod" ]]; then
  echo "current-context in $kubeconfig must be cluster-prod (found '$current_context')."
  exit 1
fi

file_context="$(cat /root/current-context.txt 2>/dev/null || true)"
if [[ "$file_context" != "cluster-prod" ]]; then
  echo "/root/current-context.txt must contain exactly 'cluster-prod' (found '$file_context')."
  exit 1
fi

if ! kubectl --kubeconfig="$kubeconfig" get pods -A >/dev/null 2>&1; then
  echo "kubectl get pods -A must succeed against cluster-prod with this kubeconfig."
  exit 1
fi

echo "Success: practice-kubeconfig now points at cluster-prod."
exit 0
