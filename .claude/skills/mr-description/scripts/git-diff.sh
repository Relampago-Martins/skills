#!/usr/bin/env bash
# git-diff.sh — Part of the mr-description skill
# Compares two branches using the remote merge-base and writes diff.patch
#
# Usage:
#   bash git-diff.sh <base-branch> <compare-branch>
#   bash git-diff.sh main feature/my-feature

set -euo pipefail

BASE="${1:-}"
COMPARE="${2:-}"
OUTPUT="diff.patch"

# ── helpers ───────────────────────────────────────────────────────────────────
usage() {
  echo "Usage: $0 <base-branch> <compare-branch>"
  echo "  Example: $0 main feature/my-feature"
  exit 1
}

info()    { echo -e "\033[34m[info]\033[0m  $*"; }
success() { echo -e "\033[32m[done]\033[0m  $*"; }
warn()    { echo -e "\033[33m[warn]\033[0m  $*"; }
err()     { echo -e "\033[31m[err]\033[0m   $*" >&2; exit 1; }

# ── validation ────────────────────────────────────────────────────────────────
[[ -z "$BASE" || -z "$COMPARE" ]] && usage

git rev-parse --git-dir > /dev/null 2>&1 || err "Not inside a git repository."

# ── detect remote ─────────────────────────────────────────────────────────────
REMOTE=$(git remote | head -n 1)
if [[ -z "$REMOTE" ]]; then
  warn "No remote found — diffing local branches only."
  BASE_REF="$BASE"
  COMPARE_REF="$COMPARE"
else
  info "Fetching '$BASE' and '$COMPARE' from remote '$REMOTE'..."
  git fetch "$REMOTE" "$BASE"    2>/dev/null || warn "Could not fetch '$BASE' from remote."
  git fetch "$REMOTE" "$COMPARE" 2>/dev/null || warn "Could not fetch '$COMPARE' from remote."

  BASE_REF="$REMOTE/$BASE"
  COMPARE_REF="$REMOTE/$COMPARE"

  git rev-parse --verify "$BASE_REF"    > /dev/null 2>&1 || { warn "Remote ref not found, falling back to local '$BASE'";    BASE_REF="$BASE"; }
  git rev-parse --verify "$COMPARE_REF" > /dev/null 2>&1 || { warn "Remote ref not found, falling back to local '$COMPARE'"; COMPARE_REF="$COMPARE"; }
fi

# ── find merge-base ───────────────────────────────────────────────────────────
MERGE_BASE=$(git merge-base "$BASE_REF" "$COMPARE_REF") \
  || err "Could not determine merge-base between '$BASE_REF' and '$COMPARE_REF'."

info "Merge-base : $(git log -1 --format='%h %s' "$MERGE_BASE")"
info "Base       : $(git log -1 --format='%h %s' "$BASE_REF")"
info "Compare    : $(git log -1 --format='%h %s' "$COMPARE_REF")"

# ── generate patch ────────────────────────────────────────────────────────────
info "Writing $OUTPUT ..."
git diff "$MERGE_BASE" "$COMPARE_REF" > "$OUTPUT"

LINES=$(wc -l < "$OUTPUT")
SIZE=$(du -sh "$OUTPUT" | cut -f1)

if [[ "$LINES" -eq 0 ]]; then
  warn "No differences found between '$BASE_REF' and '$COMPARE_REF'."
  exit 0
fi

success "$OUTPUT — $LINES lines / $SIZE"
echo
echo "── stat ──────────────────────────────────────────────────────"
git diff --stat "$MERGE_BASE" "$COMPARE_REF"
echo "──────────────────────────────────────────────────────────────"
