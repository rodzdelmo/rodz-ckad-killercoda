#!/bin/bash
set -euo pipefail

namespace="store-ops"
deployment="store-app"

kubectl set image deployment/"$deployment" nginx=nginx:1.27-alpin -n "$namespace"
