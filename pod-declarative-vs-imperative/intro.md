# Creating a Pod: Declarative vs Imperative

Kubernetes gives you two ways to create the same resource:

- **imperative** — a single `kubectl` command, fast and great for quick experiments; and
- **declarative** — a YAML manifest applied with `kubectl apply -f`, reproducible and easy to version control.

In this scenario you'll create a Pod imperatively, use `--dry-run=client -o yaml` to turn an imperative command into a manifest, create another Pod declaratively, then diagnose and fix a Pod that was created with a typo in its image tag — all in the `ckad-lab` namespace.

Click **Start** when the terminal is ready.
