---
title: PromQL compatibility
type: docs
---

Okapi exposes a Prometheus-compatible query API through `okapi-ingester`. The
query API supports instant queries, range queries, label discovery, and metric
metadata under `/api/v1`.

## Sending Prometheus metrics through OTLP

Prometheus metrics can be scraped by an OpenTelemetry Collector and exported
to Okapi as OTLP protobuf. The Prometheus-compatible Okapi path is:

```text
POST /prometheus/v1/metrics
```

The endpoint expects an OTLP `ExportMetricsServiceRequest` encoded as protobuf
with `application/x-protobuf` or `application/octet-stream`. It applies
Okapi’s Prometheus conversion rules before writing the data through the direct
WAL path. In particular, dots in metric and label names are rewritten to
underscores. For example, `http.server.duration` becomes
`http_server_duration`.

For example, a Collector can use the Prometheus receiver and an OTLP/HTTP
exporter with `/prometheus` as its endpoint prefix:

```yaml
receivers:
  prometheus:
    config:
      scrape_configs:
        - job_name: okapi-target
          static_configs:
            - targets: ["example-service:8080"]

processors:
  batch:

exporters:
  otlphttp/okapi-prometheus:
    # The /prometheus prefix selects Okapi's PromQL-compatible conversion.
    # The OTLP/HTTP exporter appends /v1/metrics to this prefix, allowing
    # Prometheus data to use the standard OTLP pipeline and be stored in the
    # form expected by PromQL.
    endpoint: http://ingester:9009/prometheus
    compression: none

service:
  pipelines:
    metrics:
      receivers: [prometheus]
      processors: [batch]
      exporters: [otlphttp/okapi-prometheus]
```

The OTLP/HTTP exporter appends `/v1/metrics`, producing the
`/prometheus/v1/metrics` path required by Okapi. For a local Compose
deployment, `ingester:9009` can be replaced with `okapi-ingester:9009`. For a
Collector in another Kubernetes namespace, the endpoint can use
`http://ingester.okapi.svc.cluster.local:9009/prometheus`.

### Filtering metric tags

The ingester can exclude selected metric tags during OTLP conversion. Exact
tag names can be configured with `okapi.metrics.otel.converter.excludeTags`,
and tag-name prefixes can be configured with
`okapi.metrics.otel.converter.excludeTagPrefixes`. Both properties accept
comma-separated lists when supplied as `.properties` values:

```properties
okapi.metrics.otel.converter.excludeTags=success,type
okapi.metrics.otel.converter.excludeTagPrefixes=telemetry.sdk,internal.
```

The default configuration excludes the exact tags `success` and `type`, and
the `telemetry.sdk` prefix. Prefix matching is literal; wildcard syntax is
not supported. The same properties can be supplied through
`SPRING_APPLICATION_JSON`, for example:

```json
{
  "okapi": {
    "metrics": {
      "otel": {
        "converter": {
          "excludeTags": ["success", "type"],
          "excludeTagPrefixes": ["telemetry.sdk", "internal."]
        }
      }
    }
  }
}
```

This endpoint is not a native Prometheus `remote_write` endpoint. Native
Prometheus remote-write payloads use a different wire format; the Collector
configuration above converts scraped Prometheus data to the OTLP protobuf
format expected by Okapi.

In the default direct-ingestion mode, these writes are sent to the ingester’s
WAL and are not buffered through Kafka. If
`okapi.metrics.consumptionType=kafka` is enabled, direct metrics endpoints,
including `/prometheus/v1/metrics`, are disabled and metrics must instead be
published to the configured Kafka topic.

## Configuring Grafana

Grafana can query Okapi using its built-in Prometheus data source. It is
recommended that the data source URL be set to the ingester base URL without
the `/api/v1` suffix, because Grafana appends the Prometheus API paths itself.

For a Grafana instance in the same Kubernetes namespace as the standard
`ingester` release:

```text
http://ingester:9009
```

For a Grafana instance in another Kubernetes namespace:

```text
http://ingester.okapi.svc.cluster.local:9009
```

For a local port-forward:

```text
http://127.0.0.1:9009
```

The data source type can be set to Prometheus. Grafana’s “Save & test”
operation should then be used to verify connectivity.

## Admins note

Okapi is designed to be fully compatible with PromQL. If an incompatibility
with PromQL is encountered, it is requested that it be reported as an issue in
the [Okapi engine issue tracker](https://github.com/okapi-core/engine/issues).
