---
title: Kafka ingestion
type: docs
---

`okapi-ingester` supports Kafka consumption for installations that already
buffer telemetry in Kafka. Kafka is optional and is not part of the standard
local installation or the default Kubernetes values.

For installations that do not require Kafka's buffering, replay, or decoupling
model, the standard WAL-backed ingestion mode is recommended because it avoids
an additional operational dependency.

## Default behavior

Each signal consumes from the local WAL by default:

```properties
okapi.metrics.consumptionType=wal
okapi.logs.consumptionType=wal
okapi.traces.consumptionType=wal
```

The property override mechanisms are described in
[Overriding properties](../properties/). Kafka is enabled by setting the
relevant signal's `consumptionType` to `kafka` through
`SPRING_APPLICATION_JSON` or the deployment-specific wrapper around it.

Signals can be configured independently. For example, metrics can consume
from Kafka while logs and traces continue to use the WAL.

## Kafka properties

For each signal configured with `kafka`, the following properties are
required:

```properties
okapi.metrics.consumptionType=kafka
okapi.metrics.kafka.bootstrapServers=kafka:9092
okapi.metrics.kafka.topic=otel-metrics
okapi.metrics.kafka.groupId=okapi-metrics
```

The same structure applies to `okapi.logs` and `okapi.traces`:

```properties
okapi.logs.consumptionType=kafka
okapi.logs.kafka.bootstrapServers=kafka:9092
okapi.logs.kafka.topic=otel-logs
okapi.logs.kafka.groupId=okapi-logs

okapi.traces.consumptionType=kafka
okapi.traces.kafka.bootstrapServers=kafka:9092
okapi.traces.kafka.topic=otel-traces
okapi.traces.kafka.groupId=okapi-traces
```

The optional per-signal properties are `pollTimeoutMs` and `maxPollRecords`.
Their defaults are `100` and `1024`. The consumer uses byte-array
deserialization, disabled auto-commit, and expects the corresponding OTLP
protobuf payload on each topic.

## Kafka ingestion notes

The Kafka record value is expected to contain the serialized OTLP protobuf for
the corresponding signal:

- the metrics topic carries an OTLP `ExportMetricsServiceRequest`;
- the logs topic carries an OTLP `ExportLogsServiceRequest`; and
- the traces topic carries an OTLP `ExportTraceServiceRequest`.

The ingester uses byte-array deserializers for both Kafka keys and values. The
record value is the payload consumed by the signal-specific OTLP protobuf
parser; JSON, text, or an application-specific wrapper is not the expected
encoding.

## Docker Compose

For a Docker deployment, the same properties can be supplied through
`SPRING_APPLICATION_JSON`:

```yaml
services:
  ingester:
    environment:
      SPRING_APPLICATION_JSON: >-
        {"okapi":{"metrics":{"consumptionType":"kafka","kafka":{
        "bootstrapServers":"kafka:9092","topic":"otel-metrics",
        "groupId":"okapi-metrics"}}}}
```

An additional Compose override can apply this configuration without changing
the versioned Okapi bundle.

## Kubernetes Helm deployment

The `ingester` chart provides `springOverrides` as a convenience wrapper. It
serializes the values into `SPRING_APPLICATION_JSON` for the ingester
container:

```yaml
springOverrides:
  okapi:
    metrics:
      consumptionType: kafka
      kafka:
        bootstrapServers: kafka:9092
        topic: otel-metrics
        groupId: okapi-metrics
    logs:
      consumptionType: kafka
      kafka:
        bootstrapServers: kafka:9092
        topic: otel-logs
        groupId: okapi-logs
    traces:
      consumptionType: kafka
      kafka:
        bootstrapServers: kafka:9092
        topic: otel-traces
        groupId: okapi-traces
```

This block can be added to the version-matched `ingester-values.yaml` supplied
to `okapictl install --k8s`. It is recommended that only the signals intended
to consume from Kafka be included; omitted signals retain their WAL defaults.

## Operational requirements

Before enabling a signal, it is recommended that the corresponding Kafka
topic, consumer group, retention policy, authentication, lag monitoring, and
replay procedure be established. The Kafka producer should publish the
corresponding OTLP protobuf payload expected by that signal.
