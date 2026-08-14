#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

kubectl apply -f /root/assets/ledger-worker.yaml

node="$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')"
kubectl taint node "$node" dedicated=gpu:NoSchedule --overwrite

kubectl apply -f /root/assets/gpu-pods.yaml
