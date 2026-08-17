#!/bin/bash
set -euo pipefail

namespace="guard-ops"
pod="policy-checker"
answer_file="/root/policy-checker.txt"

expected_run_as_user="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.securityContext.runAsUser}')"
selector_key="$(kubectl get pod "$pod" -n "$namespace" -o go-template='{{range $k, $v := .spec.nodeSelector}}{{$k}}{{end}}')"
selector_value="$(kubectl get pod "$pod" -n "$namespace" -o go-template='{{range $k, $v := .spec.nodeSelector}}{{$v}}{{end}}')"
expected_selector_line="${selector_key}=${selector_value}"

affinity_key="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key}')"
affinity_value="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0]}')"
expected_affinity_line="${affinity_key}=${affinity_value}"

if [[ ! -f "$answer_file" ]]; then
  echo "$answer_file does not exist."
  exit 1
fi

line1="$(sed -n '1p' "$answer_file")"
line2="$(sed -n '2p' "$answer_file")"
line3="$(sed -n '3p' "$answer_file")"

if [[ "$line1" != "$expected_run_as_user" ]]; then
  echo "Line 1 must be the runAsUser value: $expected_run_as_user"
  exit 1
fi

if [[ "$line2" != "$expected_selector_line" ]]; then
  echo "Line 2 must be the nodeSelector key=value pair: $expected_selector_line"
  exit 1
fi

if [[ "$line3" != "$expected_affinity_line" ]]; then
  echo "Line 3 must be the required nodeAffinity key=value pair: $expected_affinity_line"
  exit 1
fi

echo "Success: $answer_file correctly records the SecurityContext, nodeSelector, and nodeAffinity."
exit 0
