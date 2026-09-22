---
title: Telemetry
type: docs
weight: 4
---

Okapi ingests metrics, logs, and traces through `okapi-ingester` and stores
them in ClickHouse. The recommended edge is an OpenTelemetry Collector, which
lets you batch, retry, filter, route, and protect telemetry before it reaches
Okapi.

- [Configure OpenTelemetry](otel/)
- [Optional Kafka ingestion](kafka/)
