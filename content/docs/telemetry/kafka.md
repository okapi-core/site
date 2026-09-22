---
title: Optional Kafka ingestion
type: docs
---

Kafka is an optional ingestion architecture for teams that already buffer
telemetry in Kafka or need Kafka's operational replay and decoupling model.
It is not required for Okapi, and it is not started by the standard local
install or the default Helm values.

Each signal can be configured independently in `okapi-ingester`:

```yaml
okapi:
  metrics:
    consumptionType: KAFKA
    kafka:
      bootstrapServers: kafka:9092
      topic: otel-metrics
      groupId: okapi-metrics
  logs:
    consumptionType: KAFKA
    kafka:
      bootstrapServers: kafka:9092
      topic: otel-logs
      groupId: okapi-logs
  traces:
    consumptionType: KAFKA
    kafka:
      bootstrapServers: kafka:9092
      topic: otel-traces
      groupId: okapi-traces
```

When a signal is set to `KAFKA`, its Kafka bootstrap servers, topic, and group
ID are required. The consumer uses byte-array deserialization and manual
offset commits. Configure the topics and producer serialization to carry the
corresponding OTLP protobuf payloads.

Leave `consumptionType` as `WAL` (or omit it) when sending directly to the
OTLP/HTTP endpoints. Do not enable Kafka for a signal until its topic,
consumer group, retention, security, lag monitoring, and replay procedure are
operationally defined.
