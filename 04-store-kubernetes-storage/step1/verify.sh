#!/bin/bash
set -euo pipefail

namespace="content-ops"
deployment="quote-cache-warmer"

ready_replicas="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
if [[ "${ready_replicas:-0}" -lt 1 ]]; then
  echo "Deployment $deployment must have at least one ready replica."
  exit 1
fi

mount_path="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[?(@.mountPath=="/var/cache/quotes")].mountPath}' 2>/dev/null || true)"
if [[ "$mount_path" != "/var/cache/quotes" ]]; then
  echo "Container must have a volumeMounts entry with mountPath /var/cache/quotes."
  exit 1
fi

mount_name="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[?(@.mountPath=="/var/cache/quotes")].name}' 2>/dev/null || true)"
volume_has_emptydir="$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath="{.spec.template.spec.volumes[?(@.name==\"$mount_name\")].emptyDir}" 2>/dev/null || true)"

if [[ -z "$volume_has_emptydir" ]]; then
  echo "Volume '$mount_name' must be an emptyDir volume."
  exit 1
fi

echo "Success: $deployment now mounts an emptyDir volume at /var/cache/quotes."
exit 0
