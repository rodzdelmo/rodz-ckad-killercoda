#!/bin/bash
set -euo pipefail

namespace="payments-ops"
policy="invoice-api-egress-lockdown"

if ! kubectl get networkpolicy "$policy" -n "$namespace" >/dev/null 2>&1; then
  echo "NetworkPolicy $policy must still exist in $namespace."
  exit 1
fi

policy_types="$(kubectl get networkpolicy "$policy" -n "$namespace" -o jsonpath='{.spec.policyTypes}' 2>/dev/null || true)"
if [[ "$policy_types" != *"Egress"* ]]; then
  echo "$policy must still be an Egress policy."
  exit 1
fi

pod_selector="$(kubectl get networkpolicy "$policy" -n "$namespace" -o jsonpath='{.spec.egress[0].to[0].podSelector.matchLabels.app}' 2>/dev/null || true)"
if [[ "$pod_selector" != "payments-db" ]]; then
  echo "$policy's egress[0].to must select app=payments-db (found '$pod_selector')."
  exit 1
fi

port="$(kubectl get networkpolicy "$policy" -n "$namespace" -o jsonpath='{.spec.egress[0].ports[0].port}' 2>/dev/null || true)"
if [[ "$port" != "5432" ]]; then
  echo "$policy's egress[0].ports must include port 5432 (found '$port')."
  exit 1
fi

echo "Success: invoice-api can now reach payments-db on 5432, and nothing else."
exit 0
