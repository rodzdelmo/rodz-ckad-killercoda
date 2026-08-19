#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

kubectl create namespace tools-ops --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f /root/assets/database-crd.yaml
kubectl wait --for=condition=Established crd/databases.ops.example.com --timeout=30s

if ! command -v helm >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash >/dev/null 2>&1
fi

# orders-db.yaml is intentionally NOT applied here - it violates the CRD's
# schema, and the learner needs to see the API server reject it themselves.
