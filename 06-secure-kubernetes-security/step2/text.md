## Task

A separate kubeconfig file has been placed at `/root/practice-kubeconfig` (use `--kubeconfig=/root/practice-kubeconfig` for every command in this scenario, so your real cluster access is untouched). It has two contexts: `cluster-old` and `cluster-prod`. The team decommissioned `cluster-old` last week; `cluster-prod` is the real cluster you need for today's task.

```bash
kubectl --kubeconfig=/root/practice-kubeconfig config get-contexts
kubectl --kubeconfig=/root/practice-kubeconfig get pods -A
```

That last command fails with `Unable to connect to the server: dial tcp: lookup cluster-old-api ... no such host`. A kubeconfig "context" is just a named pairing of (which cluster + which user credentials). `kubectl` always operates against whichever context is `current-context` - you're pointed at the decommissioned cluster.

Switch to the real one, then confirm and save which context you're in:

```bash
kubectl --kubeconfig=/root/practice-kubeconfig config use-context cluster-prod
kubectl --kubeconfig=/root/practice-kubeconfig config current-context > /root/current-context.txt
```

When `/root/current-context.txt` contains `cluster-prod` and `kubectl --kubeconfig=/root/practice-kubeconfig get pods -A` succeeds, click **Check**.
