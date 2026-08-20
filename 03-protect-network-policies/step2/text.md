## Task

Once `invoice-api` in `payments-ops` was locked down to only accept traffic from `billing-ui`, it stopped being able to reach its own database. `payments-db` in the same namespace is `Running`, but `invoice-api` can't connect to it on port `5432`.

```bash
kubectl get networkpolicy invoice-api-egress-lockdown -n payments-ops -o yaml
```

This policy has `policyTypes: [Egress]` and an empty `egress: []` list - that combination denies **all** outbound traffic from `invoice-api`, full stop. Unlike the ingress policy you just wrote, an egress policy's deny-by-default applies to *outbound* connections, independently of whatever ingress rules exist. Right now nothing is allowed out, including the one connection `invoice-api` actually needs.

Edit `/root/manifest/invoice-api-egress-policy.yaml`: add one `egress` entry allowing traffic `to` Pods labeled `app: payments-db`, on `port: 5432` - without deleting the empty-list deny posture for everything else.

```bash
kubectl apply -f /root/manifest/invoice-api-egress-policy.yaml
```

When the policy has exactly one egress rule scoped to `payments-db` on port `5432`, click **Check**.
