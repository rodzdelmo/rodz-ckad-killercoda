#!/bin/bash
set -euo pipefail

namespace="pipelines-ops"
sa="system:serviceaccount:pipelines-ops:ci-deployer"

can_patch="$(kubectl auth can-i patch deployments -n "$namespace" --as="$sa" 2>/dev/null || true)"
if [[ "$can_patch" != "yes" ]]; then
  echo "ci-deployer must be able to patch deployments in $namespace (kubectl auth can-i said '$can_patch')."
  exit 1
fi

can_list="$(kubectl auth can-i list deployments -n "$namespace" --as="$sa" 2>/dev/null || true)"
if [[ "$can_list" != "yes" ]]; then
  echo "ci-deployer should still be able to list deployments in $namespace - don't remove the existing verbs."
  exit 1
fi

echo "Success: ci-deployer can now patch (and still view) Deployments in $namespace."
exit 0
