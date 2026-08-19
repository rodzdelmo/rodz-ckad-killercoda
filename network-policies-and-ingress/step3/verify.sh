#!/bin/bash
set -euo pipefail

namespace="docs-ops"
ingress="docs-ingress"

rewrite_target="$(kubectl get ingress "$ingress" -n "$namespace" -o jsonpath='{.metadata.annotations.nginx\.ingress\.kubernetes\.io/rewrite-target}' 2>/dev/null || true)"
if [[ "$rewrite_target" != "/\$2" ]]; then
  echo "Ingress $ingress must carry annotation nginx.ingress.kubernetes.io/rewrite-target: /\$2 (found '$rewrite_target')."
  exit 1
fi

use_regex="$(kubectl get ingress "$ingress" -n "$namespace" -o jsonpath='{.metadata.annotations.nginx\.ingress\.kubernetes\.io/use-regex}' 2>/dev/null || true)"
if [[ "$use_regex" != "true" ]]; then
  echo "Ingress $ingress must carry annotation nginx.ingress.kubernetes.io/use-regex: \"true\" (found '$use_regex')."
  exit 1
fi

echo "Success: $ingress now rewrites the path before forwarding to docs-svc."
exit 0
