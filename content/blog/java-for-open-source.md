---
title: "Java for open source? Why?"
type: blog
date: 2026-09-22
authors:
  - name: Kushal Sharma
    image: https://github.com/kushal-sharma.png
tags:
  - Java
  - Open Source
  - Engineering
---

In 2026, Python and Rust are the fashionable choices for new open-source
projects.

Where there is AI, there is Python. Rust is what authors reach for when systems require performance and safety. So why am I building Okapi in Java?

The short answer is that Java remains a very good contender for open-source
infrastructure. It is not the only good choice, and it is not the right choice
for every component. But for Okapi's particular job, Java has a practical
combination of maturity and ecosystem depth that's hard to beat.

## Okapi is a long-running system

Okapi is not primarily a command-line tool or a short-lived batch job. It is a
set of services that ingest telemetry, write data to ClickHouse, query large
datasets, serve a web application, and help investigate incidents with Oscar.
Java and the JVM are poor fits for CLIs where cold-start is everything. Plus, CLIs are supposed to be cheap to download, which Java is certainly not. For example, `ghcr.io/okapi-core/ingester` is the Okapi ingester Docker image, and it is 867 MB. Surely downloading this is a nightmare nobody wants to deal with. I personally just [build from source](https://github.com/okapi-core/engine/blob/main/Makefile#L166).

But in a Kubernetes cluster, download times are (controversially?) less important. The Okapi ingester starts up in about 2 seconds. Once a system starts up, I am more interested in ongoing performance, and Java delivers here.

## Modern Java has less boilerplate

Some of the resistance to Java comes from memories of older versions of the
language: verbose classes, repetitive getters and setters, and ceremony around
simple data structures.

Java 21 is a different experience. Records, pattern matching, improved switch
expressions, text blocks, sealed types, and local variable type inference make
the language considerably more expressive. Lombok also helps Okapi remove
repetitive constructors, accessors, and builders where that makes the code
clearer. Obviously, Okapi's codebase uses all of these features, sometimes
multiple in one place. See this [example](https://github.com/okapi-core/engine/blob/main/okapi-cloud-web-dtos/src/main/java/org/okapi/web/dtos/dashboards/CreateDashboardPanelRequest.java).

For example, a small value object can be expressed directly as a record:

```java
public record AnImmutable(String value) {}
```

And there is, of course, Lombok, which is the recommended way of creating DTOs in Okapi.

And a multi-line query or configuration document can use a text block rather
than a collection of concatenated strings. These are small improvements, but
they add up across a large codebase. Modern Java lets me keep the type safety
and tooling of the Java ecosystem without accepting all of the ceremony that
gave the language its old reputation.

## The ecosystem is the real argument

Okapi needs to speak HTTP, protobuf, OpenTelemetry, PostgreSQL, ClickHouse, and
Kafka. It is also a monorepo-ish project, and this author has zero interest or
skill in build tooling.

Java already has mature solutions for all of those problems.

Spring gives Okapi dependency injection, configuration binding, lifecycle
management, health endpoints, HTTP services, and integrations for nearly every
infrastructure component. That is a lot of useful machinery available through familiar conventions.

As an example, Maven is unglamorous and uses XML (yikes). It is old, mature, and boring—and that is exactly what I want from a build tool. It handles the things Okapi needs:

- dependency management;
- multi-module builds;
- test execution;
- packaging and releases;
- generated protobuf sources; and
- formatting and build checks.

There is no novelty prize for a build tool. A mature tool that does everything
I need is a feature.

## How this shows up in Okapi

The Okapi engine is organized as a Maven multi-module project. The modules reflect real
boundaries in the system: ingestion, query services, storage, WAL handling,
web, Oscar, clients, and shared protocols.

The project also has explicit conventions. Spotless enforces Google Java Format. Tests cover application contexts, HTTP clients, database connectivity, migrations, and permission boundaries. The goal is not to make every contributor memorize a style guide. The build should make the expected style and quality checks automatic.
This matters for open source.

Contributors should be able to find the module
that owns a behavior, make a change, run the checks, and understand what the
project expects. Good tooling does not replace good design, but it lowers the
cost of participating in the project.

## Why not Python or Rust?

Python would be a natural choice for parts of Oscar and for experimentation in
the AI layer. Rust would be a compelling choice for a small, highly efficient
systems component. Both are excellent languages, and Okapi does not need to
pretend otherwise.

The question is not which language wins in the abstract. The question is which
language gives the whole platform the best trade-off.

Java gives me a common foundation for long-running services, mature production libraries, and a direct path through the systems Okapi already needs to integrate with. Those advantages are more important to me than choosing the language with the most momentum in a given year.

## The trade-offs are real

As with all engineering, choosing Java is not free of drawbacks.

There is a JVM to operate. That means memory configuration, startup overhead,
and another runtime layer to understand when diagnosing a problem. Java is
also not the natural choice for a tiny CLI where instant startup and a single
small binary matter more than a large application ecosystem.

Maven's build-cache story is not particularly strong. So far, this is not a
problem, but it may become one as the project grows. If that happens, Okapi
can always graduate to Gradle.

## Java is still a good open-source choice

Popularity comes and goes. Python and Rust are rightly attracting a lot
of energy, and I am happy to use the right tool when a problem calls for it.
Okapi already uses Python: [`okapictl`](https://github.com/okapi-core/controller),
for example, is written entirely in Python.

But Java remains a strong contender for open-source infrastructure. Java 21 is
less verbose than its reputation suggests. Maven is mature and dependable.
Spring provides a deep foundation for services and integrations. The JVM is a
time-tested beast.

For Okapi, that is enough of a reason to choose it.
