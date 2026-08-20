#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

for ns in retail-ops canary-ops media-ops batch-ops; do
  kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -
done

kubectl apply -f /root/assets/checkout-blue.yaml
kubectl apply -f /root/assets/checkout-green.yaml
kubectl apply -f /root/assets/checkout-service.yaml

kubectl apply -f /root/assets/recs-stable.yaml
kubectl apply -f /root/assets/recs-canary.yaml
kubectl apply -f /root/assets/recs-service.yaml

kubectl apply -f /root/assets/thumbnail-batch.yaml
kubectl apply -f /root/assets/image-resize-batch.yaml

# nightly-cleanup.yaml is intentionally NOT applied here - its manifest is
# invalid and the learner needs to see the API server reject it themselves.
