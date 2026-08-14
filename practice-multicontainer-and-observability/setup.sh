#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

kubectl apply -f /root/assets/web-with-cache.yaml
kubectl apply -f /root/assets/ping-api.yaml
kubectl apply -f /root/assets/metrics-relay.yaml
