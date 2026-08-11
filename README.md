# Diverge SDK

Open-source ecommerce SDK for **iOS** (Swift Package Manager) and **Android** (local module today; Maven Central pending).

Configure with a sandbox or production API key, then use the shared client for environment and version introspection.

## Requirements

| Platform | Minimum |
|----------|---------|
| iOS | 15.0+ |
| Android | API 24+ |
| Swift | 6.0 language mode (Xcode 16+) |
| Xcode | 16+ |

## Installation

### iOS — Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/DialogIntelligens/Diverge-SDK.git", from: "0.1.0")
]
```

Add products `DivergeSDK` (required) and `DivergeSDKUI` (optional status UI).

```swift
import DivergeSDK
import DivergeSDKUI

try Diverge.configure(
    Configuration(apiKey: "sk_sandbox_demo", environment: .sandbox)
)
let client = try Diverge.shared
DivergeStatusView(client: client)
```

Publish = push a SemVer Git tag (`v0.1.0`); consumers resolve from GitHub via SPM.

### Android — Maven Central (pending)

> **Not published to Maven Central yet.** Namespace `ai.askdiverge` is verified; Portal user token + GPG secrets still needed for the first deploy.
> Publish wiring (signing + Central Portal staging) is ready — see [`Dev-Docs/releases/MAVEN_CENTRAL.md`](Dev-Docs/releases/MAVEN_CENTRAL.md).
> Until published, depend on the local Gradle module in [`android/`](android/).

```kotlin
implementation(project(":diverge-sdk"))
// after Central publish: implementation("ai.askdiverge:diverge-sdk:0.1.0")

Diverge.configure(
    Configuration(apiKey = "sk_sandbox_demo", environment = Environment.SANDBOX)
)
val client = Diverge.shared
```

Environment wire names match iOS raw values: `sandbox` / `production` (`Environment.wireName`).

## Versioning and channels

Single source of truth: the root [`VERSION`](VERSION) file. After changing it, run:

```bash
./scripts/sync-version.sh
./scripts/check-version.sh
```

| Channel | Git tag example | GitHub Release |
|---------|-----------------|----------------|
| Stable | `v1.2.3` | Latest release |
| Beta | `v1.2.3-beta.1` | Prerelease |
| Canary | `v1.2.3-canary.1` | Prerelease |

## Documentation

- Getting started / ATT: [`Docs/site/`](Docs/site/)
- Integration baseline: [`Docs/integration/v0.1.0.md`](Docs/integration/v0.1.0.md)
- Engineering (a11y checklists, privacy templates, Maven publish): [`Dev-Docs/`](Dev-Docs/)

## Samples

- iOS: [`Samples/iOS`](Samples/iOS) — links `DivergeSDK` + `DivergeSDKUI`
- Android: [`android/sample`](android/sample) — release builds enable R8 minify

## Concurrency (iOS)

Swift 6 language mode. `Diverge.configure` / `shared` are lock-synchronized. Prefer `@_spi(Testing) Diverge.reset()` only from tests.

## Make targets

```bash
make help
make ios-test
make android-test
make android-paparazzi-record   # requires Android SDK; commit PNGs after
```

## License

[MIT](LICENSE.md) — Copyright © 2026 Diverge
