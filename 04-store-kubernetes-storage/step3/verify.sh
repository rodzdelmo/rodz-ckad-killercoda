#!/bin/bash
set -euo pipefail

namespace="analytics-ops"
pvc="analytics-writer"
pod="report-writer"

pvc_phase="$(kubectl get pvc "$pvc" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$pvc_phase" != "Bound" ]]; then
  echo "PVC $pvc must be Bound (found '$pvc_phase')."
  exit 1
fi

pod_phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$pod_phase" != "Running" ]]; then
  echo "Pod $pod must be Running (found '$pod_phase')."
  exit 1
fi

sub_path="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.containers[0].volumeMounts[0].subPath}' 2>/dev/null || true)"
if [[ "$sub_path" != "reports/2024" ]]; then
  echo "Container's volumeMounts[].subPath must be reports/2024 (found '$sub_path')."
  exit 1
fi

echo "Success: analytics-writer is Bound and report-writer is Running with the correct subPath."
exit 0
