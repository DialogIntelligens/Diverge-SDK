.PHONY: help sync-version check-version ios-test ios-lint android-build android-test android-paparazzi-record docs-docc sample-ios-open install-hooks

help:
	@echo "Diverge SDK make targets:"
	@echo "  make install-hooks  - Enable local pre-commit Git hooks"
	@echo "  make sync-version   - Write VERSION into generated sources/docs"
	@echo "  make check-version  - Fail if VERSION drifts from synced files"
	@echo "  make ios-test       - Run Swift package tests (macOS host)"
	@echo "  make ios-lint       - SwiftLint + SwiftFormat lint"
	@echo "  make android-build  - Assemble library + sample"
	@echo "  make android-test   - Unit test + lint + Dokka + release minify + R8 keeps"
	@echo "  make android-paparazzi-record - Record Android UI snapshots"
	@echo "  make docs-docc      - Build DocC (SDK+UI) + Docs/site into site-dist/"
	@echo "  make sample-ios-open - Open the iOS sample in Xcode"

install-hooks:
	./scripts/install-git-hooks.sh

sync-version:
	./scripts/sync-version.sh

check-version:
	./scripts/check-version.sh

ios-test: check-version
	swift test

ios-lint:
	swiftlint lint --strict
	swiftformat --lint .

android-build:
	cd android && ./gradlew :diverge-sdk:assemble :sample:assembleDebug

android-test:
	cd android && ./gradlew :diverge-sdk:test :diverge-sdk:lint :diverge-sdk:dokkaHtml :diverge-sdk:dokkaJavadoc :sample:assembleRelease :sample:verifyR8PublicApiKeeps

android-paparazzi-record:
	cd android && ./gradlew :diverge-sdk:recordPaparazziDebug

docs-docc:
	./scripts/build-docs-site.sh

sample-ios-open:
	open Samples/iOS/DivergeSample.xcodeproj
