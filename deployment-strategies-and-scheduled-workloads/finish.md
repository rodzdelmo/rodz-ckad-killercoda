# Scenario complete

You completed a blue-green cutover, fixed a canary rollout, corrected a Job's parallelism, and repaired an invalid CronJob pod template.

Key commands used in this exercise:

```bash
kubectl patch service <name> -n <namespace> -p '{"spec":{"selector":{"version":"green"}}}'
kubectl get endpoints <service> -n <namespace>
kubectl patch job <name> -n <namespace> -p '{"spec":{"parallelism":2}}'
kubectl apply -f /root/manifest/<file>.yaml
```

## Helpful tips: deployment strategies and scheduled workloads at a glance

1. blue-green cutover is a one-line Service `selector` change — the old and new Deployments both keep running until you flip it, so rollback is just flipping it back;
2. canary rollout depends on the Service selector being *broader* than any single track's labels (e.g. `app: recs` alone) so it matches Pods from both the stable and canary Deployments at once — if a canary Pod's template is missing that shared label, it's invisible to the Service even while `Running` and `Ready`;
3. a Job's `parallelism` is mutable and can be patched on a running Job to speed it up; `completions` and the pod template's immutable fields cannot;
4. a Job or CronJob's pod template `restartPolicy` must be `OnFailure` or `Never` — `Always` is rejected by the API server at admission time, before any Pod is ever created, so the object never even exists on the cluster until you fix it.
