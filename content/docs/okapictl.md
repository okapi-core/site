---
title: okapictl
type: docs
weight: 8
---

`okapictl` is the supported command-line entry point for local installation,
Kubernetes installation, and the local OpenTelemetry demo. Use the controller
release and Okapi bundle published for the same release; do not mix arbitrary
CLI, image, and chart versions.

The package is published as [`okapi-ctl` on PyPI](https://pypi.org/project/okapi-ctl/):

```sh
python -m pip install okapi-ctl
okapictl --help
```

## Commands and options

```text
okapictl install --local [--project-name NAME] [--timeout SECONDS]
okapictl install --k8s [--namespace NAME] --values-dir PATH [--timeout SECONDS]
okapictl demo --local [--project-name NAME] [--timeout SECONDS]
okapictl demo --aws
```

`install` requires exactly one of `--local` or `--k8s`. The local install
defaults to project `okapi` and a 180-second readiness timeout. Kubernetes
defaults to namespace `okapi`; it installs the four OCI charts using the
version bundled with the controller and passes `--wait` to Helm.

`demo --local` defaults to project `okapi-otel-demo` and a 300-second timeout.
It clones a pinned OpenTelemetry Astronomy Shop revision into
`~/.local/state/okapictl/bundles/<version>/otel-demo`, overlays the Okapi
collector configuration, and starts the demo.

## Run the local OpenTelemetry demo

```sh
python -m pip install okapi-ctl
okapictl demo --local
```

The command prints:

```text
OpenTelemetry demo is ready: http://localhost:8080
Okapi is ready: http://localhost:9001
```

Set `OPENAI_API_KEY` before starting if Oscar should use a real model
integration. Without it, the bundled local setup uses its development model
configuration.

## Important current limitations

The current CLI source implements local install, local demo, and Kubernetes
install. `demo --aws` is present in the argument parser but currently returns
“AWS demo workflow is not implemented yet.” The CLI does not currently provide
stop or destroy subcommands; use the generated Docker Compose project for
local lifecycle management and Helm for Kubernetes lifecycle management.

Local and Kubernetes state is recorded under
`~/.local/state/okapictl/`. Treat this as controller bookkeeping, not as a
backup of Okapi data.
