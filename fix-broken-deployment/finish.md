# Scenario complete

You created the same Pod two ways: imperatively with a single `kubectl run` command, and declaratively by fixing and applying a manifest with `kubectl apply -f`. You also diagnosed and fixed a Pod that was stuck because of a typo in its image tag.

Key commands used in this exercise:

```bash
kubectl run web-imperative --image=nginx:1.27-alpine -n ckad-lab
kubectl apply -f /root/manifest/web-pod.yaml
kubectl describe pod web-typo -n ckad-lab
kubectl apply -f /root/manifest/web-typo.yaml
kubectl get pods -n ckad-lab
```

## Helpful tips: imperative vs declarative

This distinction comes up constantly in the CKAD exam and in real Kubernetes work:

1. imperative commands are fastest for one-off, throwaway resources — exactly what the exam rewards under time pressure;
2. declarative manifests are reproducible, diffable, and safe to check into version control — what you actually want for anything long-lived;
3. `kubectl create <resource> ... --dry-run=client -o yaml` is a great shortcut: generate a manifest imperatively, then edit and apply it declaratively;
4. read `kubectl apply` error messages literally — they usually name the exact field, like a `containers` map that should have been a list; and
5. `kubectl describe pod` surfaces image-pull failures (`ErrImagePull`/`ImagePullBackOff`) with the exact image string Kubernetes tried to pull — compare it character by character against what you meant to type.
