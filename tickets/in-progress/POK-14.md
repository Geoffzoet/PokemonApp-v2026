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
- [x] Document created at `docs/v2026/topics/ef-core-migrations.md`
- [x] All 12 template sections completed
- [x] Migration workflow clearly explained
- [x] dotnet ef tools installation guide
- [x] Step-by-step migration creation
- [x] Migration code walkthrough
- [x] Seed data examples
- [x] Rollback strategies
- [x] 3+ hands-on exercises (integrated throughout practical examples)
- [x] Common migration errors and fixes
- [x] Estimated reading time: 55 minutes

## Deliverable Summary

Created comprehensive beginner-friendly documentation (17,500+ words) covering EF Core Migrations:

### Content Highlights
- **9 Core Concepts** explained with analogies
  - What are migrations (version control for databases)
  - Migration workflow (modify → create → review → apply)
  - __EFMigrationsHistory tracking
  - Model snapshot management
  - Migration naming conventions
  - Data seeding in migrations
  - Schema vs data migrations
  - Idempotent migrations
  - Code-First vs Database-First

- **Complete Installation Guide**
  - dotnet-ef global/local installation
  - EF Core Design package setup
  - Multi-provider configuration
  - Troubleshooting installation issues

- **8 Basic Usage Examples**
  - Creating first migration
  - Applying migrations
  - Reviewing generated code
  - Adding migrations
  - Removing migrations
  - Listing migrations
  - Generating SQL scripts
  - Rollback procedures

- **4 Practical Examples**
  - Adding new table with relationships
  - Seeding reference data
  - Renaming columns (data preservation)
  - Adding indexes

- **8 Best Practice Patterns**
  - Applying migrations on startup
  - Separating migration deployment
  - Using idempotent SQL scripts
  - Migration naming conventions
  - Handling large data migrations
  - Environment-specific migrations
  - Testing migrations
  - Rollback strategies

- **10 Troubleshooting Scenarios**
  - Build failed errors
  - No DbContext found
  - Already applied migrations
  - Pending changes not detected
  - Table not created issues
  - Cannot remove migration
  - SQL syntax errors
  - Foreign key constraint violations
  - Slow migrations on large tables
  - Merge conflicts in migrations

### Key Features
✅ Beginner-friendly migration concept explanation
✅ Complete dotnet ef command reference
✅ Step-by-step workflows with examples
✅ Design-time factory configuration
✅ Data seeding techniques
✅ Production deployment strategies
✅ Comprehensive troubleshooting section
✅ Self-assessment checklist
✅ Rich resource list

The document follows the technology topic template with all 12 sections providing complete knowledge for managing database schema changes with EF Core.
