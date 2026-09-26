---
title: Production deployment
type: docs
---

This pathway is more involved, since a prod deployment requires taking care of secrets, access control, network ACLs.

Helm charts are published with every Okapi release as OCI artifacts under
`oci://ghcr.io/okapi-core/charts`. The Kubernetes installation deploys only
Okapi: `ops`, `ingester`, `oscar`, and `web`. PostgreSQL and ClickHouse are
production dependencies and must be deployed and operated separately.

### Prerequisites

You'll need:

- a Kubernetes cluster and a configured `kubectl` context;
- Helm 3 with OCI registry support;
- PostgreSQL and ClickHouse reachable through Kubernetes Services;
- the matching PostgreSQL and ClickHouse credentials;
- an OpenAI API key for Oscar, if AI-assisted investigation is required; and
- `okapictl` installed at the same release as the Okapi charts.

Select the target context and create the namespace:

```sh
kubectl config use-context <context-name>
kubectl create namespace okapi --dry-run=client -o yaml | kubectl apply -f -
```

### Create the reserved Secrets

Create these Secrets in the Okapi namespace. The Secret names and keys form the
interface between the deployment configuration and the Helm charts:

```sh
kubectl -n okapi create secret generic okapi-clickhouse \
  --from-literal=username=<clickhouse-user> \
  --from-literal=password='<clickhouse-password>'

kubectl -n okapi create secret generic okapi-postgres \
  --from-literal=migration-username=<migration-user> \
  --from-literal=migration-password='<migration-password>' \
  --from-literal=web-username=<web-user> \
  --from-literal=web-password='<web-password>' \
  --from-literal=oscar-username=<oscar-user> \
  --from-literal=oscar-password='<oscar-password>'

kubectl -n okapi create secret generic okapi-openai \
  --from-literal=api-key='<openai-api-key>'
```

_IMPORTANT_
Do NOT commit these values to any repository. It is strongly recommended to use Kubernetes secrets for storing sensitive credentials bundle for Okapi.

Verify that the Secrets exist without printing their values:

```sh
kubectl -n okapi get secret okapi-clickhouse okapi-postgres okapi-openai

for item in \
  okapi-clickhouse:username \
  okapi-clickhouse:password \
  okapi-postgres:migration-username \
  okapi-postgres:migration-password \
  okapi-postgres:web-username \
  okapi-postgres:web-password \
  okapi-postgres:oscar-username \
  okapi-postgres:oscar-password \
  okapi-openai:api-key; do
  secret="${item%%:*}"
  key="${item#*:}"
  kubectl -n okapi get secret "$secret" \
    -o go-template="{{if not (index .data \"$key\")}}missing $secret/$key{{end}}"
done
```

### Prepare values

Create a directory these four files:

```text
ops-values.yaml
ingester-values.yaml
oscar-values.yaml
web-values.yaml
```

Use the version-matched templates bundled with `okapictl`, then replace the
placeholders with the PostgreSQL and ClickHouse Service names, database names,
and Secret references. The important settings are:

```yaml
# ingester-values.yaml and ops-values.yaml
clickhouse:
  host: <clickhouse-service>
  port: 8123
  existingSecret: okapi-clickhouse
  usernameKey: username
  passwordKey: password

# oscar-values.yaml and web-values.yaml
postgres:
  host: <postgres-service>
  port: 5432
  database: <database>
  existingSecret: okapi-postgres

# oscar-values.yaml
openai:
  existingSecret: okapi-openai
  apiKeyKey: api-key
```

Set the PostgreSQL username and password key names for each chart as shown in
the Secret contract above. Keep the image repository and tag pinned to the
same Okapi release across all four files. Make sure `openai.apiKeyKey` in
`oscar-values.yaml` matches the key used when creating `okapi-openai`; the
example above uses `api-key`.

### Install Okapi

Point `okapictl` to the values directory:

```sh
okapictl install --k8s \
  --namespace okapi \
  --values-dir ./okapi-values \
  --timeout 900
```

The controller installs the charts in dependency order:

```text
ops → ingester → oscar → web
```

It uses the current `kubectl` context and does not change cluster selection or
install PostgreSQL or ClickHouse. To check the resulting workloads:

```sh
kubectl -n okapi get pods,deployments,jobs
helm -n okapi list
kubectl -n okapi get events --sort-by=.lastTimestamp
```

### Admins note

In production deployment, Okapi depends on already deployed Clickhouse and Postgres instances. The reason to do this is simple - there are multiple variables that must be considered most importantly resource provisioning when running a prod cluster which depend on org requirements. e.g. if Okapi only stores and analyzes a smaller chunk of telemetry, you may consider reducing hardware thrown at Clickhouse, similarly you may consider increasing hardware as telemetry sent to Okapi increases. Okapi has its own dashboards to monitor metrics such as throughput, query latency and has pre-built dashboards for Postgres and Clickhouse.
