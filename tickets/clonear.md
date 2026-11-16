---
version: 1.1.0
name: POK
prefix: POK
columns: [todo, in-progress, in-qa, done]
labels: []
---

This file marks the folder as a Clonear project; the board refuses folders
without it. `version` is the clonear.md format version (semver), `name` is
the display name, `prefix` is the ticket id prefix, `columns` is the
column order (each column is a subfolder), and `labels` are the project's
labels, suggested when editing a ticket.

## Tickets

A ticket is `<column>/<ID>.md`, e.g. `todo/POK-7.md`. The filename stem is the
id (`POK-<next number>`); the folder it sits in is its status. To move a
ticket, move the file to another column folder.

## Template

Every field filled in. Only `title` is required; unknown keys are kept.

```markdown
---
title: Fix login redirect loop   # required, one line
assignee: dave                   # free text, optional
priority: medium                 # urgent | high | medium | low (default: low)
size: M                          # S | M | L (t-shirt estimate)
labels: [bug, auth]              # free-text tags; prefer the project's labels
created: 2026-09-30              # YYYY-MM-DD
---

Markdown description: context, what to do, acceptance criteria.
Supports headings, lists, code, links, **bold** and *italic*.
```

## Best Practices

### Writing Good Tickets

**Good Example**:
```markdown
---
title: Add GET endpoint for Pokemon by ID
assignee: claude
priority: high
size: M
labels: [feature, api]
created: 2026-11-13
---

## Context
We need a REST API endpoint to retrieve a single Pokemon by its ID.

## Requirements
- Create GET endpoint at `/api/pokemon/{id}`
- Return 404 if Pokemon not found
- Return 200 with Pokemon JSON if found
- Use async/await pattern

## Acceptance Criteria
- [ ] Endpoint responds to GET /api/pokemon/{id}
- [ ] Returns Pokemon object as JSON when ID exists
- [ ] Returns 404 NotFound when ID doesn't exist
- [ ] Uses async controller action
- [ ] Follows RESTful conventions
- [ ] No compiler warnings
```

**Bad Example**:
```markdown
---
title: Pokemon stuff
---

Add some Pokemon things
```

### Ticket Sizing Guide
- **S** (Small): 1-2 hours, single file, clear implementation
  - Example: Add a simple property, fix a typo, update configuration
- **M** (Medium): Half day, 2-5 files, some decisions needed
  - Example: Add new endpoint, create new model, add validation
- **L** (Large): Full day+, multiple files, architectural decisions
  - Example: Add authentication, create new module, major refactor

### Priority Levels
- **urgent**: Blocking work, must be done immediately
- **high**: Important feature or bug, should be next
- **medium**: Normal priority, planned work
- **low**: Nice to have, can be deferred

## Workflow Diagram

```
┌─────────┐
│  todo/  │  New tickets, not yet started
└────┬────┘
     │ (Start work: move ticket, git commit)
     ▼
┌──────────────┐
│ in-progress/ │  Currently being worked on (supports multiple parallel agents)
└──────┬───────┘
       │ (Implementation complete)
       ▼
    ┌──────┐
    │ QA?  │
    └──┬───┘
      │
  ┌───┴────┐
  │        │
  ▼        ▼
┌──────┐  ┌───────┐
│in-qa/│  │ done/ │  Verified and complete
└──┬───┘  └───────┘
   │
   │ (QA passed)
   ▼
┌───────┐
│ done/ │
└───────┘
```

## Validation Checklist

Before moving a ticket to **done/**:
- [ ] All acceptance criteria are met
- [ ] Code compiles without warnings
- [ ] Code follows project standards (see PROJECT_CONTEXT.md)
- [ ] Git commit created with descriptive message
- [ ] Changes pushed to GitHub
- [ ] PROJECT_CONTEXT.md updated if architectural decisions made
