---
title: Local Docker installation
type: docs
---

Install the CLI and start Okapi with its bundled local Compose project:

```sh
python -m pip install okapi-ctl
okapictl install --local
```

When readiness checks pass, open <http://localhost:9001>. The local bundle
publishes the ingester on `localhost:9009` and Oscar on `localhost:9002`.
ClickHouse and PostgreSQL are included with named Docker volumes.

The bundle uses development credentials and storage defaults. Do not use it as
a production data store or expose its database ports directly to the internet.

To inspect the Compose project after a failed start, use the project name
(`okapi` by default) and the materialized bundle under
`~/.local/state/okapictl/bundles/`:

```sh
docker compose -p okapi ps
docker compose -p okapi logs --tail=200 web ingester oscar
```

For a complete sample workload, use [the local demo](../okapictl/#run-the-local-opentelemetry-demo).
