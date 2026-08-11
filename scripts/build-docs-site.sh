#!/usr/bin/env bash
# Build DocC for DivergeSDK + DivergeSDKUI and assemble Docs/site into site-dist/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SITE_DIST="${SITE_DIST:-$ROOT/site-dist}"
DOCS_OUT="${DOCS_OUT:-$ROOT/docs-out}"
rm -rf "$SITE_DIST" "$DOCS_OUT"
mkdir -p "$DOCS_OUT" "$SITE_DIST"

generate_docc() {
  local target="$1"
  local base_path="$2"
  local out_archive="$DOCS_OUT/${target}.doccarchive"

  echo "Generating DocC for ${target}..."
  swift package \
    --allow-writing-to-directory "$DOCS_OUT" \
    generate-documentation \
    --target "$target" \
    --output-path "$out_archive" \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path "$base_path"
}

generate_docc "DivergeSDK" "documentation/divergesdk"
generate_docc "DivergeSDKUI" "documentation/divergesdkui"

# Static marketing / guides site first
cp -R "$ROOT/Docs/site/." "$SITE_DIST/"

# Custom domain for GitHub Pages (DNS still human-owned)
printf 'docs.askdiverge.ai\n' > "$SITE_DIST/CNAME"

# Merge transformed DocC trees so hosting-base-path URLs resolve from site root.
rsync -a "$DOCS_OUT/DivergeSDK.doccarchive/documentation/" "$SITE_DIST/documentation/"
rsync -a "$DOCS_OUT/DivergeSDKUI.doccarchive/documentation/" "$SITE_DIST/documentation/"
for asset in css js data img images index downloads videos; do
  if [[ -d "$DOCS_OUT/DivergeSDK.doccarchive/$asset" ]]; then
    mkdir -p "$SITE_DIST/$asset"
    rsync -a "$DOCS_OUT/DivergeSDK.doccarchive/$asset/" "$SITE_DIST/$asset/"
  fi
  if [[ -d "$DOCS_OUT/DivergeSDKUI.doccarchive/$asset" ]]; then
    mkdir -p "$SITE_DIST/$asset"
    rsync -a "$DOCS_OUT/DivergeSDKUI.doccarchive/$asset/" "$SITE_DIST/$asset/"
  fi
done

# Raw .doccarchive trees are kept under docs-out/ for local use only.
# Do not copy them into site-dist — they duplicate data/ and include the same
# operator-symbol filenames that break GitHub Actions artifact uploads.

# GitHub Actions artifacts / Pages reject NTFS-illegal path characters.
# DocC names some operator overloads with ':' (e.g. !=(_:_:).json).
SITE_DIST="$SITE_DIST" python3 - <<'PY'
import os
from pathlib import Path

illegal = set('":<>|*?\r\n')
root = Path(os.environ["SITE_DIST"])
removed = []
for path in root.rglob("*"):
    if path.is_file() and any(ch in path.name for ch in illegal):
        removed.append(path.relative_to(root).as_posix())
        path.unlink()
print(f"Removed {len(removed)} artifact-incompatible DocC file(s)")
for rel in removed[:20]:
    print(f"  - {rel}")
if len(removed) > 20:
    print(f"  … and {len(removed) - 20} more")
PY

echo "Site assembled at $SITE_DIST"
# Archives remain available locally for inspection:
echo "DocC archives (local only): $DOCS_OUT"
