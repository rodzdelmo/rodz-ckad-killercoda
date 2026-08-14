#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

kubectl create namespace accounts-ops --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment profile-api --image=nginx:1.25 -n accounts-ops --replicas=2
kubectl rollout status deployment/profile-api -n accounts-ops --timeout=60s
