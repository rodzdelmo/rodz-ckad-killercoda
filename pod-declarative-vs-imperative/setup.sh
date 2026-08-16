#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

kubectl create namespace ckad-lab --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f /root/assets/web-typo.yaml
