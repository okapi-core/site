---
title: Okapi - Debug prod in an AI-first world
layout: hextra-home
toc: false
---

<div class="hx:flex hx:w-full hx:flex-col hx:items-start hx:gap-4 hx:mb-4">
<div class="hx:flex hx:flex-wrap hx:gap-2">
{{< hextra/hero-badge >}}Open source{{< /hextra/hero-badge >}}
{{< hextra/hero-badge >}}AI first{{< /hextra/hero-badge >}}
{{< hextra/hero-badge >}}OTel native{{< /hextra/hero-badge >}}
</div>

{{< hextra/hero-headline >}}
Okapi - debug prod in an AI-first world
{{< /hextra/hero-headline >}}

{{< hextra/hero-subtitle >}}
OpenTelemetry-native observability with full PromQL compatibility, fast ClickHouse-backed queries, and Oscar to help investigate production questions.
{{< /hextra/hero-subtitle >}}

</div>

<p class="home-install-label hx:max-w-4xl hx:text-xl hx:text-gray-600 hx:dark:text-gray-400" style="margin-bottom: 0.5rem">
  Okapi is easy to set up and use with
</p>

{{< home-install-command >}}

<p class="hx:max-w-4xl hx:text-sm hx:text-gray-500 hx:dark:text-gray-500" style="margin: 0.5rem 0 0">
  <a href="docs/getting-started">View the getting started guide →</a>
</p>

<h2 class="hx:mb-4 hx:text-4xl hx:font-bold hx:leading-tight hx:tracking-tight" style="margin-top: 3rem">
  Choose your path
</h2>

<p class="hx:mb-8 hx:max-w-4xl hx:text-xl hx:text-gray-600 hx:dark:text-gray-400">
  Start with a local installation, explore a complete demo, deploy to Kubernetes, or connect the telemetry workflows already in use.
</p>

{{< hextra/feature-grid cols="2" >}}
{{< hextra/feature-card class="home-path-card" title="Try Okapi locally" subtitle="Install Okapi with local PostgreSQL and ClickHouse using `okapictl install --local`.<br><br><strong>Start locally →</strong>" icon="play" link="docs/getting-started/local/" >}}
{{< hextra/feature-card class="home-path-card" title="Explore the demo" subtitle="Run Okapi with the OpenTelemetry Astronomy Shop using `okapictl demo --local`.<br><br><strong>Run the demo →</strong>" icon="sparkles" link="docs/getting-started/local/" >}}
{{< hextra/feature-card class="home-path-card" title="Deploy with Kubernetes" subtitle="Deploy the Okapi services into an existing Kubernetes cluster with externally operated databases.<br><br><strong>Open the production guide →</strong>" icon="cloud" link="docs/getting-started/kubernetes/" >}}
{{< hextra/feature-card class="home-path-card" title="Connect existing telemetry" subtitle="Send OpenTelemetry data and query it with PromQL and Grafana.<br><br><strong>Configure telemetry →</strong>" icon="upload" link="docs/telemetry/" >}}
{{< /hextra/feature-grid >}}

<h2 class="hx:mt-16 hx:mb-4 hx:text-4xl hx:font-bold hx:leading-tight hx:tracking-tight">
  Oscar
</h2>

<p class="hx:mb-8 hx:max-w-4xl hx:text-xl hx:text-gray-600 hx:dark:text-gray-400">
  An AI-powered investigator that does what nobody likes - dig through logs, check traces, check metrics and then find out what went wrong. Oscar has a chat interface and is steerable by a human.
</p>

{{< hextra/feature-grid >}}
{{< hextra/feature-card title="Investigate with Oscar" subtitle="Oscar searches logs, metrics, and traces to gather the evidence behind production questions and investigations." icon="sparkles" >}}
{{< hextra/feature-card title="Automate grunt work" subtitle="Move from symptoms to root by following the evidence." icon="arrow-right" >}}
{{< hextra/feature-card title="For engineers and their agents" subtitle="Oscar uses Okapi's API available to other agents. Oscar posts its evidence so engineers can check the work." icon="book-open" >}}
{{< /hextra/feature-grid >}}

<h2 class="hx:mt-16 hx:mb-4 hx:text-4xl hx:font-bold hx:leading-tight hx:tracking-tight">
  Play nice approach
</h2>

<p class="hx:mb-8 hx:max-w-4xl hx:text-xl hx:text-gray-600 hx:dark:text-gray-400">
  Bring your existing observability workflows and instrumentation with you.
</p>

{{< hextra/feature-grid >}}
{{< hextra/feature-card title="Prometheus compatible" subtitle="Keep using the Prometheus Query Language for familiar queries, aggregations, and time-series analysis." icon="code" >}}
{{< hextra/feature-card title="OpenTelemetry / OTLP Native" subtitle="Ingest metrics, logs, and traces from your existing OpenTelemetry Collectors and instrumented services." icon="upload" >}}
{{< /hextra/feature-grid >}}

<h2 class="hx:mt-16 hx:mb-4 hx:text-4xl hx:font-bold hx:leading-tight hx:tracking-tight">
  Modern Design
</h2>

<p class="hx:mb-8 hx:max-w-4xl hx:text-xl hx:text-gray-600 hx:dark:text-gray-400">
  A fast, unified foundation for exploring the systems that power your production environment.
</p>

{{< hextra/feature-grid >}}
{{< hextra/feature-card title="ClickHouse-Backed Performance" subtitle="Query large volumes of telemetry with a fast, scalable analytical storage engine." icon="arrow-right" >}}
{{< hextra/feature-card title="One Unified System" subtitle="Connect logs, metrics, and traces in one place so every investigation starts with the complete picture." icon="book-open" >}}
{{< /hextra/feature-grid >}}

<h2 class="hx:mt-16 hx:mb-4 hx:text-4xl hx:font-bold hx:leading-tight hx:tracking-tight">
  Less clicks, more value
</h2>

<p class="hx:mb-8 hx:max-w-4xl hx:text-xl hx:text-gray-600 hx:dark:text-gray-400">
  Get useful operational visibility with fewer manual steps and more value from the telemetry you already collect.
</p>

{{< hextra/feature-grid >}}
{{< hextra/feature-card title="Dashboards as Code" subtitle="Define, version, review, and reproduce dashboards alongside your infrastructure and application code." icon="code" >}}
{{< hextra/feature-card title="Zero-Click RED Metrics" subtitle="Get request rate, error rate, and duration metrics from your services without manually building every dashboard." icon="sparkles" >}}
{{< /hextra/feature-grid >}}
