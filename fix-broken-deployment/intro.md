# Creating a Pod: Declarative vs Imperative

Kubernetes gives you two ways to create the same resource:

- **imperative** — a single `kubectl` command, fast and great for quick experiments; and
- **declarative** — a YAML manifest applied with `kubectl apply -f`, reproducible and easy to version control.

In this scenario you'll create the same Pod both ways in the `ckad-lab` namespace, then diagnose and fix a third Pod that was created with a typo in its image tag.

Click **Start** when the terminal is ready.
