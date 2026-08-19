#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

for ns in content-ops platform-ops analytics-ops database-ops; do
  kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -
done

kubectl apply -f /root/assets/quote-cache-warmer.yaml
kubectl apply -f /root/assets/node-inspector.yaml
kubectl apply -f /root/assets/analytics-storage.yaml
kubectl apply -f /root/assets/report-writer.yaml
kubectl apply -f /root/assets/redis-cluster.yaml
