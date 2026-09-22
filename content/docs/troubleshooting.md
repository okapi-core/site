---
title: Troubleshooting
type: docs
weight: 6
---

### A service never becomes ready

Start with pod events and logs, then verify the dependency DNS names and
credentials. The most common causes are unreachable ClickHouse/PostgreSQL,
missing Secret keys, a migration job that failed, or a version mismatch between
images and values.

```sh
kubectl -n okapi get pods
kubectl -n okapi describe pod <pod>
kubectl -n okapi logs <pod> --all-containers --tail=300
kubectl -n okapi get jobs
```

### Telemetry is accepted but not visible

Check that the collector uses OTLP/HTTP, sends protobuf, and targets the
signal-specific `/v1/*` path. Check the tenant header and the collector's
export queue. Then inspect ingester logs and ClickHouse connectivity. If Kafka
is enabled for that signal, check consumer group lag and topic payloads rather
than the HTTP endpoint.

### Oscar cannot investigate

Verify that Oscar can resolve the ingester and PostgreSQL services, that its
database schema migration completed, and that the model provider Secret has
the key expected by the values file. A healthy Oscar process without a model
provider can still be unable to perform useful investigations.

### Helm install fails at `ops`

Treat this as a database or migration problem first. Confirm the ClickHouse
HTTP port (`8123`), PostgreSQL URL, credentials, schema permissions, and that
the migration job is using the same release version as the services.

### Local install conflicts with another project

Choose a different Compose project name:

```sh
okapictl install --local --project-name okapi-dev
```

Then use the same name with `docker compose -p okapi-dev` when inspecting the
containers.
