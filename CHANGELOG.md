# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-08-13

### Added

- Public API: `Configuration`, `Environment`, `DivergeClient`, `Diverge.configure` / `shared` (iOS + Android)
- `DivergeStatusView` + sample apps with sandbox configure flow
- Separate `DivergeSDKUI` SPM product so core `DivergeSDK` does not depend on SwiftUI
- Swift 6 language mode; accessibility dump contract tests (iOS/macOS) and Paparazzi goldens (Android, enforced in CI)
- Narrow ProGuard consumer rules; `:sample:verifyR8PublicApiKeeps` mapping check after release minify
- Maven Central publish-ready wiring (signing + Central Portal staging) — see `Dev-Docs/releases/MAVEN_CENTRAL.md`
- DocC for `DivergeSDK` + `DivergeSDKUI`; GitHub Pages site assembly (`scripts/build-docs-site.sh`)
- ATT docs, WCAG 2.1 AA / VoiceOver / TalkBack checklists (v0.1.0 code baseline under `Dev-Docs/accessibility/`), integration guide `Docs/integration/v0.1.0.md`
- Repository scaffold: SPM package, Android library + sample, CI workflows, docs and privacy templates
- Single `VERSION` source of truth with sync/check scripts
- Release validation (SemVer tags, changelog section, version consistency)

### Changed

- Relicensed from MIT to Apache License, Version 2.0
- Android `DivergeStatusView` builds UI programmatically (removed SDK layout XML)
- Minimum iOS deployment target raised from 15.0 to **18.0**
- iOS / DocC CI runs on `macos-26` and selects the newest installed Xcode (no longer pins 16.4)
- Documented Android minSdk 24 policy (no desugar/joda-style backports)
- Snapshots use stable accessibility text dumps (cross-platform); Paparazzi PNGs committed and verified
- `Diverge.reset` is `@_spi(Testing)` on iOS; API keys redacted in `Configuration` descriptions
- Removed always-true `DivergeClient.isConfigured`; use `Diverge.isConfigured`
- Android session state uses `AtomicReference`; `Environment.wireName` aligns with iOS raw values
- `DivergeError` / `DivergeException` user-facing messages; keep `Environment` class name under R8

### Fixed

- iOS CI: warm CoreSimulator before probes, and soft-fail flaky `downloadPlatform` instead of hard-failing with exit 70
