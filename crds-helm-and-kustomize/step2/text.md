## Task

Your onboarding checklist says to deploy the `podinfo` chart:

```bash
helm install internal-api opscorp/podinfo -n tools-ops --create-namespace
```

Every other engineer on the team already has this working. You get:

```
Error: INSTALLATION FAILED: failed to download "opscorp/podinfo" (hint: running helm repo update may help)
```

Helm repos are configured **per machine**, not per cluster - `helm repo add` is a one-time local setup step. A brand-new laptop has none configured at all, even if the exact same install already works for everyone else on their own machines.

```bash
helm repo list
```

Add the missing repo, update, and install:

```bash
helm repo add opscorp https://stefanprodan.github.io/podinfo
helm repo update
helm install internal-api opscorp/podinfo -n tools-ops --create-namespace
```

When `helm list -n tools-ops` shows `internal-api` with `STATUS: deployed` and its Pod is `Ready`, click **Check**.
