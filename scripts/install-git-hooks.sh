#!/usr/bin/env bash
# Point this repo at .githooks/ so `git commit` runs local checks.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

chmod +x .githooks/pre-commit
git config core.hooksPath .githooks

echo "Installed Git hooks (core.hooksPath=.githooks)."
echo "Commits will run: version check, SwiftLint/SwiftFormat (if Swift staged),"
echo "and Android lint (if android/ staged)."
