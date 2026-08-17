# CKAD Practice: Node Placement

Five independent scheduling constraints, all broken, all in namespace `place-ops`:

- a `nodeSelector` that doesn't match the node's actual label;
- a `nodeAffinity` rule pointing at the wrong zone;
- a `podAffinity` rule with a typo in its label selector;
- a `podAntiAffinity` rule pointing at the wrong label; and
- a Pod missing the toleration for a taint that was just added.

This is a single-node cluster, so a couple of these constraints behave a little differently than they would on a multi-node cluster — each step's task explains what to expect.

Click **Start** when the terminal is ready.
