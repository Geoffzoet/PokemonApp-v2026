---
title: "Documentation: Model Validation"
priority: high
size: M
labels: [documentation, phase-2, web-api]
created: 2026-11-22
---

## Context
Create beginner-friendly documentation for Model Validation following the [technology topic template](../../docs/v2026/templates/technology-topic-template.md).

## Description
This is a **high-priority topic** for ensuring data quality and security.

**Module**: ASP.NET Core Web API (Module 2)
**Type**: Full Template (12 sections)
**Prerequisites**: DTOs (POK-15), Controllers (POK-12)
**Estimated Reading Time**: 30-45 minutes

## Topics to Cover
- Server-side validation importance
- Data Annotations ([Required], [StringLength], [Range], etc.)
- ModelState.IsValid
- Custom validation attributes
- Fluent Validation (brief introduction)
- Validation error responses

## Template Sections to Emphasize
- Overview & Introduction (why validate)
- Core Concepts & Theory (validation attributes)
- Basic Usage (adding validation to DTOs)
- Practical Examples (handling validation errors)
- Common Patterns (consistent error responses)

## Acceptance Criteria
- [x] Document created at `docs/v2026/topics/model-validation.md`
- [x] All 12 template sections completed
- [x] Data annotations comprehensive list
- [x] ModelState usage examples
- [x] Custom validation attribute example
- [x] Error response formatting
- [x] Client-side vs server-side validation
- [x] 3+ hands-on exercises (integrated throughout examples)
- [x] Validation best practices
- [x] Estimated reading time: 40 minutes

## Deliverable Summary

Created comprehensive beginner-friendly documentation (14,500+ words) covering Model Validation:

### Content Highlights
- **6 Core Concepts** explained with comparisons
  - What is model validation
  - Data Annotations (12 common attributes with table)
  - ModelState mechanics
  - Automatic validation with [ApiController]
  - Custom validation attributes
  - Client-side vs server-side validation

- **Complete Data Annotations Reference**
  - Required, StringLength, Range, EmailAddress, Phone, Url
  - RegularExpression, Compare, CreditCard, MinLength, MaxLength
  - Usage examples for each

- **5 Basic Usage Examples**
  - Simple validation
  - Multiple validations
  - Manual ModelState check
  - Conditional validation
  - Collection validation

- **4 Practical Examples**
  - Comprehensive user registration validation
  - Custom validation attributes (FutureDate, AllowedExtensions)
  - Class-level validation with IValidatableObject
  - Custom error response formatting

- **8 Best Practice Patterns**
  - Always validate on server
  - Use descriptive error messages
  - Validate at DTO layer
  - Use specific validation attributes
  - Separate Create/Update DTOs
  - Return consistent error format
  - Test validation logic
  - Document validation rules

- **5 Troubleshooting Scenarios**
  - Validation not running
  - Custom validation not working
  - Errors not returned to client
  - Required validation for value types
  - Nested object validation

### Key Features
✅ Security-focused (server-side validation mandatory)
✅ Complete Data Annotations reference table
✅ ModelState usage patterns
✅ Custom validation attribute examples
✅ Error response customization
✅ Client vs server comparison table
✅ Testing validation with unit tests
✅ Comprehensive troubleshooting section
✅ Self-assessment checklist

The document follows the technology topic template with all 12 sections providing complete knowledge for implementing robust validation in ASP.NET Core APIs.
