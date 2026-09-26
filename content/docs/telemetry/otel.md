---
title: Configure OpenTelemetry
type: docs
---

## Protocol and paths

Okapi supports OTLP over HTTP with protobuf request bodies. These are HTTP
endpoints carrying OTLP protobuf; they are not OTLP/gRPC endpoints. Send each
signal to the matching path:

| Signal  | Path          |
| ------- | ------------- |
| Metrics | `/v1/metrics` |
| Logs    | `/v1/logs`    |
| Traces  | `/v1/traces`  |

The ingester accepts `application/x-protobuf` and
`application/octet-stream`. Configure an OTLP/HTTP exporter with the base URL
only; the exporter appends the signal paths. For metrics that should use the
Prometheus-compatible conversion path, use `/prometheus/v1/metrics` instead.

There is no need to deploy Kafka for a normal OTLP/HTTP installation. The
default signal consumption mode is WAL-backed inside the ingester.

## Collector example

```yaml
receivers:
  otlp:
    protocols:
      grpc:
      http:

processors:
  batch:

exporters:
  otlphttp/okapi:
    endpoint: http://okapi-ingester:9009
    compression: none
    headers:
      X-Okapi-Tenant-Id: demo

service:
  pipelines:
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlphttp/okapi]
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlphttp/okapi]
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlphttp/okapi]
```

Use the service DNS name inside Kubernetes and an ingress or load-balancer
URL for remote collectors. Keep the tenant header consistent for the data
being sent. Confirm the exact header name expected by the release you deploy;
some older examples use `X-Okapi-Tenant` while the current ingester clients
use `X-Okapi-Tenant-Id`.

## Operational advice

Use batching and retries in the collector, monitor its export queue, and keep
the collector close to the workloads it serves. Put TLS and authentication at
the boundary where telemetry enters the cluster. Do not expose ClickHouse to
instrumented applications; only the ingester should need direct ClickHouse
access.
