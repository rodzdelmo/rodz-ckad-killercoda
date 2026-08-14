#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

kubectl apply -f /root/assets/store-replicas.yaml

kubectl create namespace orders-ops --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment orders-api --image=nginx:1.25 -n orders-ops --replicas=2
kubectl rollout status deployment/orders-api -n orders-ops --timeout=60s
kubectl set image deployment/orders-api nginx=nginx:1.27 -n orders-ops
kubectl rollout status deployment/orders-api -n orders-ops --timeout=60s
