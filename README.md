# Diverge SDK

Documentation hub. Platform SDKs are **separate repositories**:

| Platform | Repository |
|----------|------------|
| **iOS** | https://github.com/mohamedaldahoul/Diverge-SDK-iOS |
| **Android** | https://github.com/mohamedaldahoul/Diverge-SDK-Android |

## Install

**iOS (SPM)** — pin a release; do not track `main`:

```swift
.package(url: "https://github.com/mohamedaldahoul/Diverge-SDK-iOS.git", from: "0.1.0")
```

**Android** — see [Diverge-SDK-Android](https://github.com/mohamedaldahoul/Diverge-SDK-Android) (`implementation(project(":diverge-sdk"))` or Maven Central when published).

Each platform has its own SemVer + GitHub Releases.

> Org note: repos are under `mohamedaldahoul/` until a `DialogIntelligens` admin transfers them to `DialogIntelligens/Diverge-SDK-iOS` and `DialogIntelligens/Diverge-SDK-Android`.

## License

[Apache-2.0](LICENSE.md)
