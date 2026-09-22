---
title: Kubernetes installation
type: docs
---

The Kubernetes workflow assumes that PostgreSQL and ClickHouse already exist.
It installs only the four Okapi charts, in this order:

```text
ops → ingester → oscar → web
```

## Prepare the cluster

```sh
kubectl config use-context <context>
kubectl create namespace okapi --dry-run=client -o yaml | kubectl apply -f -
```

Create the namespaced Secrets before installing. The bundled values templates
expect these exact names and keys:

| Secret | Keys |
| --- | --- |
| `okapi-clickhouse` | `username`, `password` |
| `okapi-postgres` | `migration-username`, `migration-password`, `web-username`, `web-password`, `oscar-username`, `oscar-password` |
| `okapi-openai` | `api-key` |

Use External Secrets, Vault, or your platform's secret manager in production.
The following is suitable only as a quick setup pattern:

```sh
kubectl -n okapi create secret generic okapi-clickhouse \
  --from-literal=username=default --from-literal=password="$CLICKHOUSE_PASSWORD"
kubectl -n okapi create secret generic okapi-postgres \
  --from-literal=migration-username=okapi_migration \
  --from-literal=migration-password="$POSTGRES_MIGRATION_PASSWORD" \
  --from-literal=web-username=okapi_web \
  --from-literal=web-password="$POSTGRES_WEB_PASSWORD" \
  --from-literal=oscar-username=okapi_oscar \
  --from-literal=oscar-password="$POSTGRES_OSCAR_PASSWORD"
kubectl -n okapi create secret generic okapi-openai \
  --from-literal=api-key="$OPENAI_API_KEY"
```

## Install with `okapictl`

Materialize the versioned templates, replace the database placeholders, and
pass the directory to the installer. The current controller requires all four
files to be present:

```sh
okapictl install --k8s \
  --namespace okapi \
  --values-dir ./okapi-values
```

The CLI reports the bundled template location if `--values-dir` is omitted.
Review every file before copying it into your deployment repository.

## Production choices

Start with one pinned image tag and versioned values in source control, with
secret references kept separate. For the stateless `web` and `ingester`
services, enable multiple replicas, an HPA, and a PDB after measuring load.
Keep `oscar` internal and expose `web` through an authenticated TLS ingress.
Make the ingester externally reachable only through a protected collector or
an intentional ingestion gateway.

The local `clickhouse` and `postgres` charts are single-node test fixtures.
They have persistence disabled by default and are not a production database
topology.
