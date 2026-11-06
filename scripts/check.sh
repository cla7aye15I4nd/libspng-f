#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
expected=46c81dc2b3747fa43aac33704c890a468f195d6e
actual=$(git -C libspng rev-parse HEAD)
[ "$actual" = "$expected" ] || { echo "Unexpected libspng revision: $actual" >&2; exit 1; }
[ -z "$(git -C libspng status --porcelain)" ] || { echo 'libspng checkout has modifications' >&2; exit 1; }
lake build
lake env lean tests/Audit.lean
binary=$(mktemp "${TMPDIR:-/tmp}/libspng-size.XXXXXX")
trap 'rm -f "$binary"' EXIT HUP INT TERM
${CC:-cc} -std=c99 -O2 -Wall -Wextra tests/size.c -lz -lm -o "$binary"
"$binary"
