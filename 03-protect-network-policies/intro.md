# 3. Protect &mdash; Network Policies

*"Then we protect the communication between our applications."*

Two independent problems, one on ingress traffic and one on egress:

- `invoice-api` in `payments-ops` has no traffic restrictions at all, and security wants it locked down to a single caller; and
- once locked down, `invoice-api` also can't reach its own database - an egress-only policy meant to deny everything else accidentally denies the one connection it actually needs.

This is stop 3 in the CKAD Practice (Part 2) series - Release &rarr; Route &rarr; Protect &rarr; Store &rarr; Stateful &rarr; Secure &rarr; Manage.

Click **Start** when the terminal is ready.
