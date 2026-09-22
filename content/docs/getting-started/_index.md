---
title: Getting started
type: docs
weight: 1
---

## Choose a path

| Goal | Recommended path | What it provides |
| --- | --- | --- |
| Evaluate the product quickly | `okapictl demo --local` | Okapi plus the OpenTelemetry Astronomy Shop demo |
| Run Okapi on a laptop | `okapictl install --local` | Okapi and its local PostgreSQL and ClickHouse dependencies |
| Run a shared environment | `okapictl install --k8s` | The four Okapi Helm releases in an existing Kubernetes cluster |
| Operate production infrastructure | Direct Helm | Full control over external databases, secrets, ingress, and scaling |

The local workflows are for evaluation and development. A production
installation should use managed or separately operated PostgreSQL and
ClickHouse, durable storage, backups, TLS, and a secret manager.

## What you need

For local Docker workflows:

- Docker with the Compose v2 plugin.
- Internet access to pull the versioned Okapi images.
- Git as well if you run the OpenTelemetry demo.

For Kubernetes:

- A working `kubectl` context and Helm 3.
- PostgreSQL reachable from the Okapi namespace.
- ClickHouse reachable over its HTTP interface, normally port `8123`.
- Kubernetes Secrets for database credentials and the Oscar model provider.
- An ingress or load balancer for `web` if users need access outside the cluster.

Okapi's charts do not install or manage production PostgreSQL or ClickHouse.
The repository contains single-node charts for local Kubernetes testing only.
