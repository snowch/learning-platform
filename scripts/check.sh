#!/usr/bin/env bash
# Copyright © 2026 Christopher Snow

# Exactly what CI runs. Run it before pushing: `npm run check`.
#
# CI invokes this same script, so a laptop and CI cannot drift. Each stage says what it protects,
# because a check nobody understands is a check somebody eventually deletes.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== formatting =="
# One formatter, pinned, so a diff is never a reformat. Prose files keep their own line breaks.
npx prettier --check .

echo "== copyright =="
# Every source file carries its author's copyright line; a new file without it fails here.
# `node scripts/copyright.mjs` adds the line.
node scripts/copyright.mjs --check

echo "== types =="
# Strict TypeScript over every package and the tests, with no emit: nothing here is bundled, so
# this is the only stage that typechecks everything.
npx tsc --noEmit -p tsconfig.json

echo "== unit and integration tests =="
# The schema under Node with no DOM; the runtime and the primitives under jsdom.
npx vitest run

echo "== the contract is current =="
# contract/lesson.schema.json is the lesson format as JSON Schema, generated from the zod schema.
# A schema change without the regenerated file fails here: run `npm run -s schema >
# contract/lesson.schema.json`.
generated="$(mktemp)"
npx vite-node scripts/export-schema.mts > "$generated"
if ! diff -q "$generated" contract/lesson.schema.json > /dev/null; then
  echo "contract/lesson.schema.json is out of date. Run: npm run -s schema > contract/lesson.schema.json"
  diff "$generated" contract/lesson.schema.json | head -40 || true
  rm -f "$generated"
  exit 1
fi
rm -f "$generated"

echo
echo "All checks passed."
