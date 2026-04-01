---
name: generate-api-doc
description: Generates a comprehensive backend API documentation guide for a specific feature or screen. Explores the project structure, asks targeted questions to the developer, and produces a structured Markdown document covering endpoints, data models, permissions, and business rules — ready to be handed to a frontend team.
---

# Generate API Doc

You are a technical documentation specialist. Your goal is to **produce a structured API documentation guide** (like a "Guia Backend" document) for a specific feature or screen of this backend project.

The document must be detailed enough that a **frontend developer** can implement the full UI without needing to ask any additional questions.

---

## Step 1 — Explore the Project Structure

Before asking anything, silently explore the project to gather context:

```bash
# Get a high-level overview
find . -maxdepth 3 \( -name "*.py" -o -name "*.ts" -o -name "*.js" -o -name "*.rb" -o -name "*.go" -o -name "*.java" \) \
  | grep -v node_modules | grep -v __pycache__ | grep -v .git \
  | head -80

# Look for route/URL definitions
find . -maxdepth 5 -name "urls.py" -o -name "routes.ts" -o -name "router.js" \
  -o -name "*routes*" -o -name "*router*" \
  | grep -v node_modules | grep -v __pycache__ | head -20

# Look for serializers, schemas, or DTOs
find . -maxdepth 5 -name "serializers.py" -o -name "schemas.py" -o -name "*.dto.ts" \
  -o -name "*schema*" \
  | grep -v node_modules | head -20

# Check for existing docs or OpenAPI specs
find . -maxdepth 4 -name "openapi*" -o -name "swagger*" -o -name "*.yaml" -o -name "*.yml" \
  | grep -v node_modules | head -10
```

Based on what you find, identify:
- The **framework and language** (Django, FastAPI, Express, Rails, NestJS, etc.)
- The **general domain** of the project (reservations, e-commerce, CMS, etc.)
- Existing patterns for **permissions/auth** (JWT, session, roles, etc.)
- **Key models or entities** present

---

## Step 2 — Ask the Developer Targeted Questions

Use the `ask_questions` tool to collect the information you can't infer from the code. Ask **all questions at once** in a single call — do not ask in multiple rounds.

```
ask_questions([
  {
    question: "Which feature or screen should this doc cover?",
    type: "free_text",
    placeholder: "e.g. Space editing screen, User profile page, Order checkout flow"
  },
  {
    question: "Who is the primary audience for this doc?",
    options: [
      "Frontend developer (React/Next.js)",
      "Mobile developer (iOS/Android)",
      "Third-party integration partner",
      "Other internal team"
    ],
    type: "single_select"
  },
  {
    question: "What sections should be included?",
    options: [
      "Permissions & Roles matrix",
      "List / detail endpoints",
      "Create / update / delete endpoints",
      "Nested resources (e.g. sub-items)",
      "Auxiliary data endpoints (selects, autocomplete)",
      "Business rules & edge cases",
      "Quick reference URL table"
    ],
    type: "multi_select"
  },
  {
    question: "What level of detail do you need for request/response examples?",
    options: [
      "Full JSON examples for every endpoint",
      "JSON examples only for complex endpoints",
      "Schema description only (no JSON examples)",
    ],
    type: "single_select"
  },
  {
    question: "Are there any endpoints, fields, or sections that should be explicitly EXCLUDED? (e.g. photo upload is already documented)",
    type: "multi_select",
    placeholder: "Leave blank if nothing to exclude"
  }
])
```

---

## Step 3 — Deep Dive Into Relevant Code

Now that you know what to document, read the relevant source files in detail.

### 3.1 Find and read the relevant views/controllers

```bash
# Search for view classes or functions related to the feature
grep -rn "class.*ViewSet\|class.*View\|@router\|@app.route\|path(" \
  --include="*.py" --include="*.ts" --include="*.js" \
  -l | grep -v node_modules | grep -v __pycache__ | head -20
```

Read the files most relevant to the feature the developer specified. Focus on:
- Which HTTP methods are handled (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`)
- URL patterns and path parameters
- Permission classes or decorators
- Queryset filtering logic (what each user role can see)

### 3.2 Read serializers / schemas / DTOs

For each endpoint, read the serializer or schema to understand:
- Which fields are **read-only** vs **writable**
- Which fields are **required** vs **optional**
- Nested objects (objects returned embedded in the response)
- Write-only fields (sent in request but not returned in response)
- Validation logic and error messages

### 3.3 Read models

For entities involved in the feature:
- Field types and constraints (`max_length`, `null`, `blank`, `unique_together`)
- Related models (ForeignKey, ManyToMany)
- Any `save()` overrides or signals that affect behavior

### 3.4 Read permission classes

Understand the full permission matrix:
- What roles/groups exist?
- What can each role do with this resource?
- Are there object-level permissions (e.g. "only the owner can edit")?

---

## Step 4 — Build the Documentation

Generate the Markdown document following this exact structure. Adapt sections based on what the developer selected in Step 2.

---

### Document Structure

```markdown
# Guia Backend: [Feature/Screen Name]

Brief description of what this document covers and what is out of scope.

---

## 1. Permissions and Roles

### 1.1 Obtaining the user profile

[Endpoint to get the current user's roles and capabilities, if applicable]

### 1.2 Permission matrix

| Action | Admin | Role X | Common User |
|--------|:-----:|:------:|:-----------:|
| ...    | Yes   | Own only | 403       |

### 1.3 Useful fields for UI control

- `capabilities.X.Y` — show/hide button "..."
- `show_admin_page` — indicates if the logged-in user can edit this specific resource

---

## 2. [Resource Name] API Endpoints

### 2.1 List [resources]

\`\`\`
GET /api/[resource]/
\`\`\`

**Query params (optional):**
- `limit`, `offset` — pagination
- other filters...

**Response (200):**
\`\`\`json
{ ... }
\`\`\`

**Errors:**
- `403` — reason

---

### 2.2 Detail

\`\`\`
GET /api/[resource]/{identifier}/
\`\`\`

[Repeat pattern for each endpoint]

---

## 3. [Nested Resource] CRUD (if applicable)

[Same pattern as above]

---

## 4. Auxiliary Data

### 4.1 List [select options]

\`\`\`
GET /api/[auxiliary]/
\`\`\`

[Response example]

---

## 5. Field Reference

### Editable fields (send in POST/PUT/PATCH body)

| Field | Type | Required | Notes |
|-------|------|:--------:|-------|
| ...   | ...  | Yes/No   | ...   |

### Read-only fields (returned in response, do not send)

| Field | Type | Notes |
|-------|------|-------|
| ...   | ...  | ...   |

---

## 6. Quick URL Reference

| Method | URL | Description | Permission |
|--------|-----|-------------|------------|
| GET    | `/api/...` | ... | Authenticated |
```

---

## Step 5 — Quality Checklist

Before finalizing, verify that the document:

- [ ] Covers **every HTTP method** for each endpoint (not just GET)
- [ ] Documents **all error responses** with the actual API error messages (read from validation code)
- [ ] Clearly separates **write-only fields** (sent in request) from **read-only fields** (returned in response)
- [ ] Explains **nested object behavior** (e.g. "send `bloco_id`, receive `bloco` object")
- [ ] Documents **PATCH vs PUT** differences where both exist
- [ ] Includes **business rules** that affect frontend behavior (e.g. "this section only visible when `reserva_unitaria: true`")
- [ ] Notes any **destructive operations** (e.g. "PUT replaces the entire list — always send the complete array")
- [ ] Has **concrete JSON examples** that match the actual model fields (not invented placeholder data)
- [ ] Respects the **exclusions** the developer mentioned in Step 2

---

## Step 6 — Output

Save the final document as a `.md` file:

```bash
# Suggested filename based on the feature
# e.g. guia-backend-edicao-espacos.md
```

Present the file to the developer using `present_files`.

After presenting, briefly summarize:
- How many endpoints were documented
- Any **ambiguities or assumptions** you made (so the developer can verify)
- Any **gaps** you couldn't fill from the code alone (e.g. undocumented behavior, missing tests)
