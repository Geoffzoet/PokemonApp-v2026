---
title: "Documentation: Data Transfer Objects (DTOs)"
priority: high
size: L
labels: [documentation, phase-2, web-api, patterns]
created: 2026-11-22
---

## Context
Create beginner-friendly documentation for DTOs following the [technology topic template](../../docs/v2026/templates/technology-topic-template.md).

## Description
This is a **high-priority pattern** for API data exposure.

**Module**: ASP.NET Core Web API (Module 2)
**Type**: Full Template (12 sections)
**Prerequisites**: Entity Framework Core (POK-13), Controllers (POK-12)
**Estimated Reading Time**: 45-60 minutes

## Topics to Cover
- What are DTOs and why use them
- Entity vs DTO
- Creating DTOs (Get, Create, Update DTOs)
- Mapping entities to DTOs (manual and AutoMapper)
- DTO validation
- When to use DTOs vs entities

## Template Sections to Emphasize
- Overview & Introduction (security, separation of concerns)
- Core Concepts & Theory (DTO pattern)
- Basic Usage (creating and using DTOs)
- Practical Examples (CRUD with DTOs)
- Common Patterns (DTO naming conventions)

## Acceptance Criteria
- [x] Document created at `docs/v2026/topics/data-transfer-objects.md`
- [x] All 12 template sections completed
- [x] Security benefits explained
- [x] Entity vs DTO comparison
- [x] Manual mapping examples
- [x] AutoMapper introduction and setup
- [x] Different DTO types (Read, Create, Update)
- [x] 3+ hands-on exercises (integrated throughout examples)
- [x] Best practices for DTO design
- [x] Estimated reading time: 50 minutes

## Deliverable Summary

Created comprehensive beginner-friendly documentation (16,500+ words) covering Data Transfer Objects:

### Content Highlights
- **6 Core Concepts** explained with comparisons
  - What are DTOs and why use them
  - Entity vs DTO differences (table comparison)
  - DTO types (Read, Create, Update, Patch)
  - Mapping strategies (manual, methods, AutoMapper)
  - Flattening nested objects
  - Projection for performance

- **Complete Setup Guide**
  - Project structure recommendations
  - Manual mapping extension methods
  - AutoMapper installation and configuration
  - Dependency injection setup

- **5 Basic Usage Examples**
  - Simple DTO without navigation
  - Create DTO with validation
  - Update DTO
  - Using AutoMapper
  - Nested DTOs with collections

- **3 Practical Examples**
  - User profile with security (public/private DTOs)
  - Computed properties in DTOs
  - Partial updates with PATCH DTOs

- **8 Best Practice Patterns**
  - DTO naming conventions
  - Separate folder organization
  - Validation attributes usage
  - Separate DTOs per operation
  - AutoMapper vs manual mapping decision
  - Query projection performance
  - Circular reference handling
  - Input validation and over-posting prevention

- **6 Troubleshooting Scenarios**
  - Circular reference exceptions
  - AutoMapper missing type map
  - Null reference in navigation properties
  - Over-posting attack prevention
  - Performance issues with large collections
  - AutoMapper flattening issues

### Key Features
✅ Security-focused explanation (over-posting, sensitive data)
✅ Entity vs DTO comparison table
✅ Manual mapping and AutoMapper examples
✅ Multiple DTO types for different operations
✅ Flattening and projection techniques
✅ Validation patterns
✅ Comprehensive troubleshooting section
✅ Self-assessment checklist
✅ Rich resource list

The document follows the technology topic template with all 12 sections providing complete knowledge for implementing DTOs in ASP.NET Core APIs.
