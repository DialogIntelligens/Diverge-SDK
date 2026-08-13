# Diverge Android SDK

Gradle module `:diverge-sdk` plus a sample app under `sample/` (lives under `android/` in the monorepo).

## Requirements

| | |
|--|--|
| minSdk | **24** |
| compileSdk / targetSdk | 35 |
| Kotlin | 2.0+ |
| JDK | 17 |

minSdk 24 is intentional. Do **not** add desugar / joda-time (or similar) backports solely to paper over older API gaps.

The published SDK UI (`DivergeStatusView`) is built programmatically — no layout XML ships in the library. The sample app may still use XML layouts.

## Local consume

From the `android/` Gradle project:

```kotlin
implementation(project(":diverge-sdk"))
```

Maven Central publish wiring lives in `diverge-sdk/build.gradle.kts` (see `Dev-Docs/releases/MAVEN_CENTRAL.md`).
