#!/bin/bash
set -euo pipefail

namespace="payments-ops"
found=""

for name in $(kubectl get networkpolicy -n "$namespace" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null || true); do
  pod_selector_app="$(kubectl get networkpolicy "$name" -n "$namespace" -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null || true)"
  [[ "$pod_selector_app" == "invoice-api" ]] || continue

  policy_types="$(kubectl get networkpolicy "$name" -n "$namespace" -o jsonpath='{.spec.policyTypes}' 2>/dev/null || true)"
  [[ "$policy_types" == *"Ingress"* ]] || continue

  ports="$(kubectl get networkpolicy "$name" -n "$namespace" -o jsonpath='{.spec.ingress[*].ports[*].port}' 2>/dev/null || true)"
  [[ "$ports" == *"8080"* ]] || continue

  ns_selector="$(kubectl get networkpolicy "$name" -n "$namespace" -o jsonpath='{.spec.ingress[0].from[0].namespaceSelector.matchLabels.kubernetes\.io/metadata\.name}' 2>/dev/null || true)"
  pod_selector="$(kubectl get networkpolicy "$name" -n "$namespace" -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}' 2>/dev/null || true)"

  if [[ "$ns_selector" == "billing-ops" && "$pod_selector" == "billing-ui" ]]; then
    found="$name"
    break
  fi
done

if [[ -z "$found" ]]; then
  echo "No NetworkPolicy in $namespace selects app=invoice-api with a single ingress 'from' entry combining namespaceSelector=billing-ops AND podSelector=app:billing-ui on port 8080."
  exit 1
fi

echo "Success: NetworkPolicy '$found' correctly locks down invoice-api to billing-ui in billing-ops."
exit 0
