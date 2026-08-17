#!/bin/bash
set -euo pipefail

node="$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')"
kubectl taint node "$node" dedicated=finance:NoSchedule --overwrite

kubectl apply -f /root/assets/web-taint.yaml
