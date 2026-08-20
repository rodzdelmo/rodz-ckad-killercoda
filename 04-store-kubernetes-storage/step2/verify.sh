#!/bin/bash
set -euo pipefail

namespace="platform-ops"
pod="node-inspector"

phase="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [[ "$phase" != "Running" ]]; then
  echo "Pod $pod must be Running in namespace $namespace (found phase '$phase')."
  exit 1
fi

hostpath_type="$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.spec.volumes[0].hostPath.type}' 2>/dev/null || true)"
if [[ "$hostpath_type" != "Directory" && "$hostpath_type" != "DirectoryOrCreate" ]]; then
  echo "Pod $pod's hostPath.type must be Directory (found '$hostpath_type')."
  exit 1
fi

echo "Success: $pod is Running with a correctly-typed hostPath volume."
exit 0
