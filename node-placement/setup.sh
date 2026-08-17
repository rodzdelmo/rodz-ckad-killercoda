#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

node="$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')"
kubectl label node "$node" disktype=ssd zone=us-east-1a --overwrite

kubectl create namespace place-ops --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f /root/assets/cache-pod.yaml
kubectl apply -f /root/assets/web-nodeselector.yaml
kubectl apply -f /root/assets/web-nodeaffinity.yaml
kubectl apply -f /root/assets/web-podaffinity.yaml
kubectl apply -f /root/assets/web-podantiaffinity.yaml
