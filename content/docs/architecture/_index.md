---
title: Architecture
type: docs
weight: 2
---

Okapi has three application services and two data dependencies. Keep the
user-facing service reachable by users, but keep the ingestion and AI services
on the cluster network unless there is a specific reason to expose them.

```text
OpenTelemetry SDKs / Collectors
             │ OTLP over HTTP
             ▼
     okapi-ingester ───────────────► ClickHouse
             │                          (telemetry)
             ├──────── query/API ────┐
             ▼                       │
        okapi-oscar ◄────────────────┘
        (AI agent)       evidence through ingester APIs
             ▲
             │ investigation requests
             ▼
          okapi-web ─────► PostgreSQL
          (UI/API)          (application state)
```

## Components

### `okapi-web`

The user-facing UI and API. It calls `okapi-ingester` for telemetry queries
and `okapi-oscar` for AI-assisted investigations. It stores application state
in PostgreSQL and is the service normally exposed through an ingress.

### `okapi-ingester`

The ingestion and query layer. It accepts OTLP metrics, logs, and traces,
writes telemetry to ClickHouse, and serves query and metadata APIs used by the
web application and Oscar. Its default consumption mode is WAL-backed.

### `okapi-oscar`

The AI investigation service. Oscar uses the ingester's bounded query
interfaces to gather evidence, rather than receiving unrestricted access to
ClickHouse. Oscar stores its own state in PostgreSQL and needs a configured
model provider for useful investigations.

### `ops`

The `ops` Helm chart is a one-shot migration job. Run it before the services
when installing or upgrading a release. It migrates ClickHouse and PostgreSQL
schemas; it is not a continuously running application service.

## Data and trust boundaries

Telemetry belongs in ClickHouse; user, web, and Oscar application state belongs
in PostgreSQL. Back up both independently. Database credentials and the Oscar
API key should be supplied through Kubernetes Secrets or an external secret
system, not committed to values files.

The ingester is the natural boundary for tenant headers, rate limits, TLS,
and telemetry access policy. Use a collector as the controlled edge when
possible, and expose only the endpoints required by your topology.
