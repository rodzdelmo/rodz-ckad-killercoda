#!/bin/bash
set -euo pipefail

namespace="retail-ops"

selector_version="$(kubectl get svc checkout-service -n "$namespace" -o jsonpath='{.spec.selector.version}' 2>/dev/null || true)"
if [[ "$selector_version" != "green" ]]; then
  echo "Service checkout-service's spec.selector.version must be 'green' (found '$selector_version')."
  exit 1
fi

green_ips="$(kubectl get pods -n "$namespace" -l app=checkout,version=green -o jsonpath='{.items[*].status.podIP}')"
endpoint_ips="$(kubectl get endpoints checkout-service -n "$namespace" -o jsonpath='{.subsets[*].addresses[*].ip}')"

if [[ -z "$endpoint_ips" ]]; then
  echo "checkout-service has no endpoints yet."
  exit 1
fi

for ip in $endpoint_ips; do
  if [[ ! " $green_ips " =~ " $ip " ]]; then
    echo "checkout-service endpoint $ip does not belong to a checkout-green Pod."
    exit 1
  fi
done

echo "Success: checkout-service now routes only to checkout-green."
exit 0
