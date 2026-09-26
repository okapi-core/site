---
title: Overriding properties
type: docs
---

Okapi services ship with application defaults. It is recommended that
properties be overridden only when a documented deployment setting does not
cover a specific requirement, and that overrides be versioned with the Okapi
release against which they were tested.

## Configuration model

The Spring Boot services load their defaults from `application.properties`:

- [`okapi-ingester` application.properties](https://github.com/okapi-core/engine/blob/main/okapi-ingester/src/main/resources/application.properties)
- [`okapi-web` application.properties](https://github.com/okapi-core/engine/blob/main/okapi-web/src/main/resources/application.properties)
- [`okapi-oscar` application.properties](https://github.com/okapi-core/engine/blob/main/okapi-oscar/src/main/resources/application.properties)

The common application-level mechanism for overriding Spring properties is
`SPRING_APPLICATION_JSON`. It is understood by Spring Boot regardless of
whether the service is running in Docker or Kubernetes.

For example, the following overrides the ingester Kafka settings:

```sh
export SPRING_APPLICATION_JSON='{
  "okapi": {
    "metrics": {
      "consumptionType": "kafka",
      "kafka": {
        "bootstrapServers": "kafka:9092",
        "topic": "otel-metrics",
        "groupId": "okapi-metrics"
      }
    }
  }
}'
```

The equivalent native `.properties` representation is:

```properties
okapi.metrics.consumptionType=kafka
okapi.metrics.kafka.bootstrapServers=kafka:9092
okapi.metrics.kafka.topic=otel-metrics
okapi.metrics.kafka.groupId=okapi-metrics
```

The `.properties` form is useful for understanding the underlying Spring
configuration. The deployment mechanism can supply the same values through
`SPRING_APPLICATION_JSON`, without replacing the application’s packaged
properties file.

See [optional Kafka ingestion](../telemetry/kafka/) for a complete example where we use property overriding mechanism to point `okapi-ingester` to ingest telemetry data from Kafka.

## Docker deployments

Docker Compose can provide `SPRING_APPLICATION_JSON` as a service environment
variable. A Compose override file can therefore apply the same Spring
configuration used by a Kubernetes deployment:

```yaml
services:
  ingester:
    environment:
      SPRING_APPLICATION_JSON: >-
        {"okapi":{"metrics":{"consumptionType":"kafka","kafka":{
        "bootstrapServers":"kafka:9092","topic":"otel-metrics",
        "groupId":"okapi-metrics"}}}}
```

Spring Boot also supports relaxed environment-variable binding. It is
appropriate for simple individual properties, for example:

```yaml
services:
  ingester:
    environment:
      OKAPI_CLICKHOUSE_HOST: clickhouse
      OKAPI_CLICKHOUSE_PORT: "8123"
```

For nested or grouped application settings, `SPRING_APPLICATION_JSON` is the
recommended common representation.

## Kubernetes Helm deployments

The Helm charts provide convenience layers for injecting the common Spring
configuration mechanism.

### Web and ingester

The `web` and `ingester` charts explicitly expose `springOverrides`. The chart serializes
this Helm values map into `SPRING_APPLICATION_JSON` for the container:

```yaml
springOverrides:
  okapi:
    metrics:
      consumptionType: kafka
      kafka:
        bootstrapServers: kafka:9092
        topic: otel-metrics
        groupId: okapi-metrics
```

This mechanism is provided purely as a convenience wrapper.

### Oscar

The `okapi-oscar` chart does not _currently_ expose a named `springOverrides` value, but Oscar
can still receive `SPRING_APPLICATION_JSON` through its `env` values:

```yaml
env:
  - name: SPRING_APPLICATION_JSON
    value: >-
      {"okapi":{"oscar":{"memory":{"max-messages":40}}}}
```

It is recommended that first-class Oscar chart values be preferred where they
exist. For example:

```yaml
openai:
  existingSecret: okapi-openai
  apiKeyKey: api-key

ingester:
  endpoint: http://ingester:9009
```

The `envFrom` value can be used when the JSON configuration is supplied from a
Secret or ConfigMap. Sensitive credentials are best kept in Secrets rather
than embedded in `SPRING_APPLICATION_JSON`.

### Ops

`okapi-ops` is a one-time migration Job rather than a long-running Spring Boot
service. Its database and Job settings are configured through the chart’s
first-class values:

```yaml
clickhouse:
  host: clickhouse
  port: 8123
  existingSecret: okapi-clickhouse
  usernameKey: username
  passwordKey: password

postgres:
  url: jdbc:postgresql://postgres:5432/okapi_oscar?currentSchema=okapi_web
  existingSecret: okapi-postgres
  usernameKey: migration-username
  passwordKey: migration-password
```

## Guidance

- It is recommended that first-class chart values be preferred over generic
  overrides.
- `SPRING_APPLICATION_JSON` is most useful for documented or reviewed Spring
  properties that do not have a first-class chart value.
- Values such as `kafka` and `wal` should be written in the form expected by
  the deployed release.
- It is recommended that overrides be tested against the exact Okapi image and
  chart version being deployed.
- The full `application.properties` files should not be treated as a stable
  public API; undocumented properties may change between releases.
- Secrets and API keys should be supplied through Kubernetes Secrets or an
  equivalent secret-management system rather than committed configuration.
