---
title: Getting started locally
type: docs
---

These recipes only deploy Okapi locally on a single node. Useful for trying out features without much setup. Both the pathways here use `okapictl` to remove most of setup friction, the only pre-requisite is an OpenAI API key that is required to power Oscar. In case, you're simply interested in checking out the UI, a dummy key can be provided. The only drawback is Oscar won't work but everything else such as logs browser, trace viewer, dashboards will work just as well.

## Getting started with just Okapi

To locally spin an Okapi cluster, use the following:

```
export OPENAI_API_KEY=<your-key>
okapictl install --local
```

This command will start a testable Okapi cluster than can be used for quick tests. Useful for a simple try-out.
See [Configure OpenTelemetry](telemetry/otel) on how to configure an Otel collector.

A lightweight way to submit test data is to checkout the [engine source code](https://github.com/okapi-core/engine) and run `make test-data`.
Either would allow piping test data into Okapi to test out its features.

## Getting started locally with Astronomy shop demo

To locally spin an Okapi cluster along with the astronomy shop demo, use the following:

```
export OPENAI_API_KEY=<your-key>
okapictl demo --local
```

This command will first print the docker-compose setup that a local `okapi` demo will use, wire all the dependencies such as Postgres and Clickhouse, patch / configure the Otel Demo compose files so that they send data to okapi and then start the cluster as well as the demo.
It allows users who just want to play with the UI an easy way to get started.

Recommended if you want more test-data to play with.
