---
title: Operations
type: docs
weight: 5
---

## Verify a deployment

```sh
kubectl -n okapi get pods,svc,job
kubectl -n okapi get secret okapi-clickhouse okapi-postgres okapi-openai
helm list -n okapi
```

Check readiness and logs by component:

```sh
kubectl -n okapi logs deploy/web --tail=200
kubectl -n okapi logs deploy/ingester --tail=200
kubectl -n okapi logs deploy/oscar --tail=200
kubectl -n okapi describe job -l app.kubernetes.io/instance=ops
```

The local health endpoints are web `/internal/healthcheck`, ingester `/health`,
and Oscar `/health`. Kubernetes service ports are normally web `9001`,
ingester `9009`, and Oscar `9002`, unless overridden in values.

## Upgrades

Review release notes and chart values, back up both databases, then upgrade
`ops` first and the services in dependency order. Keep the image tag, chart
version, and `okapictl` bundle aligned. Use `helm diff` or a rendered manifest
review before changing a shared namespace.

## Scaling and storage

`web` and `ingester` are the primary stateless scaling targets. Enable HPA and
PDB only after setting realistic resource requests. Ensure ingester WAL paths
are durable if your chosen configuration depends on them; `/tmp` is not a
durable production volume. ClickHouse capacity, partitioning, retention,
replication, and backups are part of the database operating model, not the
Okapi application charts.

## Backups and recovery

Back up PostgreSQL for web and Oscar state and ClickHouse for telemetry. Test
restores into an isolated environment. A Helm release or `okapictl` state file
does not contain your telemetry or application data.
