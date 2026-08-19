# CKAD Practice: RBAC, KubeConfig & Admission Control

Five independent problems:

- CI service account `ci-deployer` in `pipelines-ops` can view Deployments but can't restart one;
- a separate kubeconfig at `/root/practice-kubeconfig` is pointed at a decommissioned cluster;
- once you're on the right cluster, that same kubeconfig is bound to a read-only identity;
- a Deployment's Pods in `production-ops` are being rejected by a real validating webhook that's already running in the cluster; and
- `legacy-ingress.yaml` in `web-ops` is written against an API version this cluster no longer serves.

Click **Start** when the terminal is ready - the setup step takes a little longer than usual since it stands up a real webhook server.
