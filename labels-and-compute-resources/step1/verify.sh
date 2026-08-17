#!/bin/bash
set -euo pipefail

namespace="accounts-ops"
deployment="profile-api"
expected_label="accounts"

kubectl get deployment "$deployment" -n "$namespace" >/dev/null 2>&1

template_label="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.metadata.labels.team}' 2>/dev/null || true)"
if [[ "$template_label" != "$expected_label" ]]; then
  echo "Deployment $deployment's Pod template must have label team=$expected_label."
  exit 1
fi

ready_replicas="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.readyReplicas}')"
desired_replicas="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.replicas}')"
if [[ "${ready_replicas:-0}" != "$desired_replicas" ]]; then
  echo "Deployment $deployment must be fully rolled out ($ready_replicas/$desired_replicas ready)."
  exit 1
fi

unlabeled="$(kubectl get pods -n "$namespace" -l "team!=$expected_label" -o name)"
if [[ -n "$unlabeled" ]]; then
  echo "Every Pod in $namespace must carry team=$expected_label."
  exit 1
fi

echo "Success: $deployment is rolled out with team=$expected_label on every Pod."
exit 0
