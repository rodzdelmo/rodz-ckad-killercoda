## Task

In namespace `guard-ops`, Pod `policy-checker` was configured months ago with specific security and scheduling rules nobody has re-read since.

The Pod is `Pending` — that's fine, this is a read-only recap, not a bug hunt.

```bash
kubectl get pod policy-checker -n guard-ops -o yaml
```

Write your answer to `/root/policy-checker.txt` using exactly two lines:

- line 1: the `securityContext.runAsUser` **value**, no trailing spaces
- line 2: the `nodeSelector` **key/value** pair, formatted as `key=value`

When `/root/policy-checker.txt` has both lines correct, click **Check**.
