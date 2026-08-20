#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

for ns in payments-ops billing-ops; do
  kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -
done

kubectl apply -f /root/assets/invoice-api.yaml
kubectl apply -f /root/assets/billing-ui.yaml
kubectl apply -f /root/assets/payments-db.yaml
kubectl apply -f /root/assets/invoice-api-egress-policy.yaml
