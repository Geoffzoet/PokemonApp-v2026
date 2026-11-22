---
title: "Documentation: EF Core Migrations"
priority: high
size: L
labels: [documentation, phase-1, data-access]
created: 2026-11-22
---

## Context
Create beginner-friendly documentation for EF Core Migrations following the [technology topic template](../../docs/v2026/templates/technology-topic-template.md).

## Description
This is a **high-priority topic** for managing database schema changes.

**Module**: ASP.NET Core Web API (Module 2)
**Type**: Full Template (12 sections)
**Prerequisites**: Entity Framework Core Fundamentals (POK-13)
**Estimated Reading Time**: 45-60 minutes

## Topics to Cover
- What are migrations and why use them
- Creating migrations (`dotnet ef migrations add`)
- Applying migrations (`dotnet ef database update`)
- Reviewing migration code
- Removing migrations
- Migration history
- Seed data in migrations

## Template Sections to Emphasize
- Overview & Introduction (migration concept)
- Installation Guide (EF Core tools)
- Basic Usage (create, apply, remove migrations)
- Testing & Validation (verify database changes)
- Practical Examples (common scenarios)
- Troubleshooting (failed migrations, conflicts)

## Acceptance Criteria
- [ ] Document created at `docs/v2026/topics/ef-core-migrations.md`
- [ ] All 12 template sections completed
- [ ] Migration workflow clearly explained
- [ ] dotnet ef tools installation guide
- [ ] Step-by-step migration creation
- [ ] Migration code walkthrough
- [ ] Seed data examples
- [ ] Rollback strategies
- [ ] 3+ hands-on exercises
- [ ] Common migration errors and fixes
- [ ] Estimated reading time: 45-60 minutes
