---
title: Direct ingestion
type: docs
---

Direct ingestion sends data to `okapi-ingester` over HTTP. In the default WAL
mode, the ingester writes the received data to its write-ahead log and then
processes it into ClickHouse. This path does not use Kafka.

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

## Collector example: local or Docker Compose

For a local Compose deployment, the collector can reach the Okapi ingester at
the Compose service name `okapi-ingester`:

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

## Collector example: Kubernetes

The Helm installation creates a Kubernetes Service named after the Helm
release. With the standard release name `ingester`, the Service listens on
port `9009`. A collector running in the `okapi` namespace should use:

```yaml
exporters:
  otlphttp/okapi:
    endpoint: http://ingester:9009
    compression: none
```

For a collector in another namespace, use the fully qualified Service name:

```yaml
exporters:
  otlphttp/okapi:
    endpoint: http://ingester.okapi.svc.cluster.local:9009
    compression: none
```

The rest of the collector configuration is unchanged:

```yaml
receivers:
  otlp:
    protocols:
      grpc:
      http:

processors:
  batch:

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

The default ingester Service type is `ClusterIP`, so it is reachable only
inside the cluster. For a collector outside Kubernetes, expose the ingester
through a protected ingress or load balancer and use its HTTPS base URL, for
example `https://ingester.example.com`. The exporter will append
`/v1/metrics`, `/v1/logs`, and `/v1/traces` to that base URL.

## Admins note

Use batching and retries in the collector, monitor its export queue, and keep
the collector close to the workloads it serves.

TLS at `okapi-ingester` boundary is optional

DO NOT expose ClickHouse to instrumented applications.

DO NOT expose `okapi-ingester` to the external world.
