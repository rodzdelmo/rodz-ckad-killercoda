#!/bin/bash
set -euo pipefail

until kubectl get nodes >/dev/null 2>&1; do
  sleep 2
done

until kubectl wait --for=condition=Ready node --all --timeout=10s >/dev/null 2>&1; do
  sleep 2
done

for ns in pipelines-ops prod-ops production-ops web-ops; do
  kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -
done

### Step 1: RBAC ###
kubectl apply -f /root/assets/ci-deployer-rbac.yaml

### Steps 2-3: KubeConfig ###
kubectl create serviceaccount engineer-admin -n default --dry-run=client -o yaml | kubectl apply -f -
kubectl create serviceaccount contractor-readonly -n default --dry-run=client -o yaml | kubectl apply -f -
kubectl create clusterrolebinding engineer-admin-edit --clusterrole=edit --serviceaccount=default:engineer-admin --dry-run=client -o yaml | kubectl apply -f -
kubectl create clusterrolebinding contractor-readonly-view --clusterrole=view --serviceaccount=default:contractor-readonly --dry-run=client -o yaml | kubectl apply -f -

engineer_token="$(kubectl create token engineer-admin -n default --duration=24h)"
contractor_token="$(kubectl create token contractor-readonly -n default --duration=24h)"

real_server="$(kubectl config view --raw -o jsonpath='{.clusters[0].cluster.server}')"
real_ca="$(kubectl config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')"

cat > /root/practice-kubeconfig <<EOF
apiVersion: v1
kind: Config
clusters:
- name: cluster-old
  cluster:
    server: https://cluster-old-api:6443
- name: cluster-prod
  cluster:
    server: ${real_server}
    certificate-authority-data: ${real_ca}
users:
- name: engineer-admin
  user:
    token: ${engineer_token}
- name: contractor-readonly
  user:
    token: ${contractor_token}
contexts:
- name: cluster-old
  context:
    cluster: cluster-old
    user: engineer-admin
- name: cluster-prod
  context:
    cluster: cluster-prod
    user: contractor-readonly
current-context: cluster-old
EOF
chmod 600 /root/practice-kubeconfig

### Step 4: Admission control ###
mkdir -p /tmp/webhook-certs
openssl req -x509 -newkey rsa:2048 -keyout /tmp/webhook-certs/tls.key -out /tmp/webhook-certs/tls.crt \
  -days 365 -nodes -subj "/CN=label-validator.production-ops.svc" \
  -addext "subjectAltName=DNS:label-validator.production-ops.svc,DNS:label-validator.production-ops.svc.cluster.local" \
  >/dev/null 2>&1

kubectl create secret tls label-validator-tls -n production-ops \
  --cert=/tmp/webhook-certs/tls.crt --key=/tmp/webhook-certs/tls.key \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap label-validator-code -n production-ops \
  --from-file=server.py=/root/assets/label-validator-server.py \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f /root/assets/label-validator-deploy.yaml
kubectl rollout status deployment/label-validator -n production-ops --timeout=120s

for i in $(seq 1 30); do
  addr_count="$(kubectl get endpoints label-validator -n production-ops -o jsonpath='{.subsets[*].addresses}' 2>/dev/null | grep -o '"ip"' | wc -l | tr -d ' ')"
  [[ "${addr_count:-0}" -ge 1 ]] && break
  sleep 2
done

ca_bundle="$(base64 -w0 /tmp/webhook-certs/tls.crt)"
cat <<EOF | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: enforce-labels
webhooks:
  - name: enforce-labels.production-ops.svc
    admissionReviewVersions: ["v1"]
    sideEffects: None
    failurePolicy: Fail
    timeoutSeconds: 5
    namespaceSelector:
      matchLabels:
        kubernetes.io/metadata.name: production-ops
    clientConfig:
      service:
        name: label-validator
        namespace: production-ops
        path: /validate
        port: 443
      caBundle: ${ca_bundle}
    rules:
      - apiGroups: [""]
        apiVersions: ["v1"]
        operations: ["CREATE"]
        resources: ["pods"]
        scope: "Namespaced"
EOF

sleep 3
kubectl apply -f /root/assets/checkout-service.yaml || true

### Step 5: Deprecated API ###
kubectl apply -f /root/assets/web-app.yaml
# legacy-ingress.yaml is intentionally NOT applied here - the learner needs to
# see the API server reject it themselves.
