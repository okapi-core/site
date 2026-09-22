---
title: Helm reference
type: docs
weight: 7
---

The charts are published as OCI artifacts under
`oci://ghcr.io/okapi-core/charts`. They intentionally separate application
services from databases.

| Chart | Role | Important dependencies |
| --- | --- | --- |
| `ops` | One-shot schema migrations | ClickHouse and PostgreSQL |
| `ingester` | OTLP ingestion and query service | ClickHouse |
| `oscar` | AI investigation service | PostgreSQL, ingester, model provider |
| `web` | UI and API | PostgreSQL, ingester, Oscar |

## Direct installation

Pin the same release for all charts and install migrations first:

```sh
export OKAPI_VERSION=0.0.2
export OKAPI_NAMESPACE=okapi

helm upgrade --install ops oci://ghcr.io/okapi-core/charts/ops \
  --version "$OKAPI_VERSION" --namespace "$OKAPI_NAMESPACE" --create-namespace \
  -f ops-values.yaml --wait
helm upgrade --install ingester oci://ghcr.io/okapi-core/charts/ingester \
  --version "$OKAPI_VERSION" --namespace "$OKAPI_NAMESPACE" \
  -f ingester-values.yaml --wait
helm upgrade --install oscar oci://ghcr.io/okapi-core/charts/oscar \
  --version "$OKAPI_VERSION" --namespace "$OKAPI_NAMESPACE" \
  -f oscar-values.yaml --wait
helm upgrade --install web oci://ghcr.io/okapi-core/charts/web \
  --version "$OKAPI_VERSION" --namespace "$OKAPI_NAMESPACE" \
  -f web-values.yaml --wait
```

## Common values

All service charts support image repository/tag overrides, resource requests,
node placement, pod annotations and labels, and environment overrides. `web`
and `ingester` additionally support service type, ingress, HPA, and PDB
configuration. Database credentials can be inline for development or read from
an existing Secret using `existingSecret` and the relevant key names.

`springOverrides` is the escape hatch for service-specific Spring settings.
Use it for reviewed, environment-specific settings such as the server port,
ClickHouse WAL locations, or application properties not represented by a
first-class chart value.

## Defaults that need changing

The chart defaults use one replica, `latest` image tags, ClusterIP services,
disabled ingress/HPA/PDB, and development-style database endpoints. Override
all of these deliberately for a shared or production installation. In
particular, do not put plaintext production passwords or API keys in a values
file.
