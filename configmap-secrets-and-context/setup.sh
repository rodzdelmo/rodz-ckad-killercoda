#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

kubectl create namespace config-ops --dry-run=client -o yaml | kubectl apply -f -
kubectl create configmap app-config --from-literal=APP_MODE=production -n config-ops

kubectl create namespace auth-ops --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic token-secret --from-literal=SESSION_KEY='T0kenKey123' -n auth-ops
kubectl create deployment token-auth --image=nginx:1.25 -n auth-ops
kubectl set env deployment/token-auth --from=secret/token-secret -n auth-ops
kubectl rollout status deployment/token-auth -n auth-ops --timeout=60s

kubectl apply -f /root/assets/policy-checker.yaml
