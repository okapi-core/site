---
title: Sending data to Okapi
type: docs
weight: 4
---

Okapi receives metrics, logs, and traces through `okapi-ingester` and stores
them in ClickHouse. Data can be sent directly to the ingester, or it can be
routed through Kafka when buffered, independently consumable ingestion is
required.

- [Direct ingestion](otel/)
- [PromQL compatibility](promql/)
- [Kafka ingestion](kafka/)
