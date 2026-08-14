## Task

In namespace `edge-ops`, Pod `web-with-cache` has one entry under `spec.initContainers` and one under `spec.containers`.

The Pod is `Running` and healthy — this is about understanding the design, not fixing anything.

```bash
kubectl get pod web-with-cache -n edge-ops -o yaml
```

Identify which container is the init container and which is the long-running container. Create a file named `web-with-cache.txt` in `/root`, using exactly two lines:

- line 1: the init container's **name**
- line 2: the long-running container's **name**

No trailing spaces. When both lines are correct, click **Check**.
