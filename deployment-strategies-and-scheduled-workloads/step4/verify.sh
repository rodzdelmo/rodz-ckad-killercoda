#!/bin/bash
set -euo pipefail

namespace="batch-ops"
cronjob="nightly-cleanup"

if ! kubectl get cronjob "$cronjob" -n "$namespace" >/dev/null 2>&1; then
  echo "CronJob $cronjob does not exist yet in namespace $namespace - apply the fixed manifest."
  exit 1
fi

restart_policy="$(kubectl get cronjob "$cronjob" -n "$namespace" -o jsonpath='{.spec.jobTemplate.spec.template.spec.restartPolicy}' 2>/dev/null || true)"
if [[ "$restart_policy" != "OnFailure" && "$restart_policy" != "Never" ]]; then
  echo "CronJob $cronjob's restartPolicy must be OnFailure or Never (found '$restart_policy')."
  exit 1
fi

echo "Success: $cronjob exists with a valid restartPolicy ($restart_policy)."
exit 0
