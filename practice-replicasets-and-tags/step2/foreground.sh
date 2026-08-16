#!/bin/bash
set -euo pipefail

namespace="store-ops"
deployment="store-app"

kubectl set image deployment/"$deployment" nginx=nginx:1.27 -n "$namespace"
kubectl rollout status deployment/"$deployment" -n "$namespace" --timeout=60s
