---
name: mr-description
description: >
  Generates a beautiful, structured Merge Request (MR) / Pull Request (PR) description by comparing
  two git branches. Run this skill whenever the user asks to: write a PR/MR description, document
  a branch, summarize changes for a merge, "generate a PR desc", "create an MR", "describe this
  branch vs main", or anything that involves communicating what changed between branches.
  The skill diffs the branches (respecting the remote merge-base), saves diff.patch, and then
  produces a polished, human-readable description following structured patterns.
---

# MR Description Generator

Generates a clean, developer-friendly Merge Request description from a git diff between two branches.

## Overview

**What this skill does:**
1. Fetches both branches from remote (so the diff is always fresh)
2. Finds the true merge-base to avoid noise from diverged history
3. Writes `diff.patch` to disk
4. Reads and analyzes the diff
5. Produces a structured, beautiful MR description

## Step 0 — Gather inputs

If the user didn't provide branches, ask:
- **Base branch** (e.g. `main`, `develop`) — the branch being merged *into*
- **Compare branch** (e.g. `feature/my-feature`) — the branch being merged

If they're already in the conversation, skip asking.

---

## Step 1 — Generate the diff

Run the script at `scripts/git-diff.sh`. It handles fetching, merge-base detection, and writing `diff.patch`.

```bash
bash .claude/skills/mr-description/scripts/git-diff.sh <base-branch> <compare-branch>
```

If the script isn't installed yet, create it inline from the source in `scripts/git-diff.sh` (copy the file).

After running, confirm:
- `diff.patch` exists and is non-empty
- Print the file-stat summary (files changed, insertions, deletions)

---

## Step 2 — Read and analyze the diff

Read `diff.patch` fully. Build an internal mental model before writing anything:

### Classify each changed file into a category:
| Category | Examples |
|---|---|
| `feat` | new component, new route, new API endpoint, new hook |
| `fix` | bug correction, null check, error handling |
| `refactor` | rename, restructure, extract function/component, no behavior change |
| `style` | CSS/Tailwind changes, formatting, visual-only |
| `chore` | deps, config, tooling, scripts, env files |
| `test` | new/updated tests |
| `docs` | README, comments, JSDoc |
| `perf` | optimization, memoization, lazy loading |

### For each changed file, note:
- What was **added** (new exports, new props, new logic)
- What was **removed** (deleted code, dropped props)
- What was **modified** (changed behavior, renamed)

Read `references/mr-template.md` for the exact output format and writing guidelines.

---

## Step 3 — Write the MR description

Follow the template in `references/mr-template.md` strictly.

### Writing rules:
- **Title**: imperative mood, concise, max ~72 chars. e.g. `Add agenda space creation with OSM location search`
- **Summary**: 2–4 sentences max. What + Why. No implementation details here.
- **Changes**: grouped by category (feat → fix → refactor → style → chore). Each bullet starts with a verb. Be specific.
- **Files**: only list files the reviewer should pay attention to. Skip trivial changes (lock files, auto-generated).
- **Notes**: flag anything unusual — breaking changes, env vars needed, migrations, feature flags.

### Tone:
- Clear and direct — no filler like "This PR introduces..."
- Confident — you're communicating to a peer reviewer, not apologizing
- Specific — prefer "adds `useClipboardCoordinates` hook" over "adds new functionality"

---

## Step 4 — Output

Print the MR description to the conversation in a clean markdown code block so it's easy to copy.

Then ask: *"Want me to save this as `MR_DESCRIPTION.md`?"*

If yes, write it to disk.

---

## Edge cases

- **Empty diff**: warn the user and ask if they chose the wrong branches.
- **Huge diff** (1000+ lines): process in chunks; focus on the most impactful changes and note "… and X other minor changes".
- **Only lock file / auto-generated changes**: say so explicitly — "This MR only contains dependency updates".
- **No remote**: warn, but continue with local refs.
