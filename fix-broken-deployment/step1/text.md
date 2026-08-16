## Task

Create a Pod **imperatively** — with a single `kubectl` command, no YAML file involved.

- name: `web-imperative`
- image: `nginx:1.27-alpine`
- namespace: `ckad-lab`

Useful command:

```bash
kubectl run web-imperative --image=nginx:1.27-alpine -n ckad-lab
```

When `web-imperative` is `Running` in `ckad-lab`, click **Check**.
