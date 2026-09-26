---
title: Okapi documentation
type: docs
cascade:
  params:
    sidebar:
      open: true
---

Okapi is an OpenTelemetry-native observability platform for metrics, logs, and
traces, with ClickHouse-backed storage and Oscar, an AI-assisted investigation
service.

This documentation is written for the people who install and operate Okapi.
Start with [Choose an installation path](getting-started/) if you are evaluating
Okapi, or go directly to [Kubernetes installation](installation/kubernetes/) for
a production-oriented deployment.

## Documentation map

- [Getting started](getting-started/) — choose a deployment model and understand the prerequisites.
- [Architecture](architecture/) — understand the services, data paths, and storage boundaries.
- [Installation](installation/) — install locally with Docker or on Kubernetes.
- [okapictl](okapictl/) — use the supported command-line installer and demo runner.
- [Helm reference](helm/) — deploy and tune the individual charts.
- [Telemetry](telemetry/) — configure OpenTelemetry clients and optional Kafka ingestion.
- [Operations](operations/) — validate, scale, upgrade, back up, and troubleshoot a deployment.

{{< callout type="warning" >}}
Okapi is under active development. Found an issue ? Please file [here](https://github.com/okapi-core/engine/issues)
{{< /callout >}}
