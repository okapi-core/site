---
title: Getting started
type: docs
weight: 1
---

The preferred way to install and manage okapi is via the `okapictl` CLI. Although each Okapi sub-system is released as a separate Docker image, its recommended to go through the `okapictl` route to avoid going through configuration hassles and / or dealing with Docker stuff yourself.
Here's some recipes to get started quickly.

## Install okapictl

The supported installation and demo workflows use `okapictl`. It is
distributed on PyPI and should be installed before choosing a workflow:

```sh
python -m pip install okapi-ctl
```

The package is available from the [`okapi-ctl` PyPI project](https://pypi.org/project/okapi-ctl/).
The controller release, Okapi images, and Helm charts should be kept aligned
to the same Okapi version. See the [`okapictl` reference](../okapictl/) for
the available commands and versioning guidance.

## Choose a path

| Goal                       | Recommended path                     | What it provides                                               |
| -------------------------- | ------------------------------------ | -------------------------------------------------------------- |
| Evaluate Okapi locally     | [Getting started locally](local/)    | Okapi with local PostgreSQL and ClickHouse                     |
| Deploy Okapi in production | [Production deployment](kubernetes/) | The four Okapi Helm releases in an existing Kubernetes cluster |

The local workflows are intended for evaluation and development. Production
deployments should use separately operated PostgreSQL and ClickHouse, durable
storage, backups, TLS, and a secret manager.
