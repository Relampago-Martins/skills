# MR Description Template & Patterns

This is the canonical output format for the `mr-description` skill.
Follow this exactly — every section has a purpose.

---

## Full Template

```markdown
## <title>

> <one-line summary: what this MR does and why>

---

### 🧩 Overview

<2–4 sentences. Describe the problem being solved or the feature being added.
Focus on the "what" and "why" — not "how". No implementation details here.>

---

### ✅ Changes

#### 🚀 Features
- <Verb phrase describing change. Include component/file name when helpful.>
- ...

#### 🐛 Fixes
- <...>

#### ♻️ Refactors
- <...>

#### 🎨 Styles
- <...>

#### 🔧 Chores
- <...>

> Skip any category that has no changes. Keep only non-empty sections.

---

### 📁 Key Files

| File | What changed |
|------|-------------|
| `path/to/file.tsx` | Brief description |
| `path/to/other.ts` | Brief description |

> Only include files that need reviewer attention.
> Skip: lock files, auto-generated, trivial config.

---

### ⚠️ Notes

> Use this section for anything the reviewer needs to know before merging:
> - Breaking changes
> - New environment variables required
> - Database migrations
> - Feature flags
> - Deployment steps
> - Known limitations

<If nothing special, write: "No special deployment steps required.">

---

### 🧪 Testing

<Describe how this was tested or how a reviewer can test it:>
- [ ] <Manual test step>
- [ ] <Manual test step>

---

### 📸 Screenshots _(if applicable)_

<Delete this section if not applicable.
Otherwise add before/after screenshots or a short screen recording.>
```

---

## Writing Guidelines

### Title patterns

| Situation | Pattern | Example |
|---|---|---|
| New feature | `Add <feature>` | `Add agenda space creation flow` |
| Bug fix | `Fix <what was broken>` | `Fix coordinate paste not triggering on blur` |
| Refactor | `Refactor <what> to <why>` | `Refactor location search to use Nominatim API` |
| Multiple topics | `<Primary change> and minor improvements` | `Add OSM search and fix StepperContext type error` |
| Dependency bump | `Bump <package> to <version>` | `Bump next to 14.2.5` |

### Bullet verb starters

Use strong, specific verbs. Avoid: "update", "change", "modify", "improve" (too vague).

| Category | Good verbs |
|---|---|
| feat | Add, Implement, Introduce, Create, Enable, Expose |
| fix | Fix, Resolve, Correct, Handle, Guard against |
| refactor | Extract, Rename, Move, Replace, Simplify, Consolidate |
| style | Adjust, Polish, Align, Standardize |
| chore | Bump, Remove, Configure, Enable, Disable |

### Specificity examples

❌ Too vague:
```
- Update location component
- Fix bug in form
- Improve performance
```

✅ Specific:
```
- Add `useClipboardCoordinates` hook that detects lat/lng patterns on paste
- Fix `StepperContext` type error when `currentStep` is undefined
- Memoize subspace list with `useMemo` to avoid unnecessary re-renders
```

### Handling large diffs (50+ files)

Group related changes together. Lead with the most impactful ones:

```markdown
#### 🚀 Features
- Add full agenda management module (`src/modules/agenda/`)
- Implement `AgendaForm` with recurrence support
- Expose `useAgendaQuery` hook for data fetching

#### ♻️ Refactors
- Migrate location inputs across all forms to `OsmPlaceSearch` component
- ... and 12 other minor consistency fixes
```

### Breaking changes format

```markdown
### ⚠️ Notes

**Breaking change**: `SpaceForm` no longer accepts `latitude` and `longitude` as separate props.
Pass a `location: { lat, lng, label }` object instead.

**New env var required**: `NEXT_PUBLIC_NOMINATIM_URL` — add to `.env.local`.
```
