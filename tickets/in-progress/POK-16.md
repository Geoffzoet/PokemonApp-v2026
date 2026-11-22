---
title: "Documentation: Dependency Injection in ASP.NET Core"
priority: high
size: L
labels: [documentation, phase-2, web-api, architecture]
created: 2026-11-22
---

## Context
Create beginner-friendly documentation for Dependency Injection following the [technology topic template](../../docs/v2026/templates/technology-topic-template.md).

## Description
This is a **critical architectural pattern** for ASP.NET Core applications.

**Module**: ASP.NET Core Web API (Module 2)
**Type**: Full Template (12 sections)
**Prerequisites**: C# interfaces, basic OOP
**Estimated Reading Time**: 60-75 minutes

## Topics to Cover
- What is Dependency Injection (DI)
- Inversion of Control (IoC) principle
- Service registration (AddScoped, AddTransient, AddSingleton)
- Constructor injection
- Service lifetimes explained
- Injecting services into controllers
- Best practices for DI

## Template Sections to Emphasize
- Overview & Introduction (DI concept, benefits)
- Core Concepts & Theory (IoC, service lifetimes)
- Initial Setup & Configuration (registering services)
- Basic Usage (injecting into controllers)
- Practical Examples (service layer pattern)
- Common Patterns (interface-based design)

## Acceptance Criteria
- [x] Document created at `docs/v2026/topics/dependency-injection.md`
- [x] All 12 template sections completed
- [x] DI benefits clearly explained
- [x] Service lifetimes with diagrams
- [x] Scoped vs Transient vs Singleton examples
- [x] Constructor injection examples
- [x] Real-world service examples
- [x] 3+ hands-on exercises (integrated throughout examples)
- [x] Common DI pitfalls
- [x] Estimated reading time: 65 minutes

## Deliverable Summary

Created comprehensive beginner-friendly documentation (19,500+ words) covering Dependency Injection:

### Content Highlights
- **8 Core Concepts** explained with analogies and diagrams
  - What is Dependency Injection
  - Inversion of Control (IoC) principle
  - DI Container mechanics
  - Service lifetimes (Transient, Scoped, Singleton) with ASCII diagrams
  - Constructor injection
  - Interface-based dependencies
  - Dependency chain resolution
  - Service Locator anti-pattern

- **Service Lifetime Diagrams**
  - Visual representation of Transient (new each time)
  - Scoped (one per request) with request lifecycle
  - Singleton (one for app lifetime)
  - Comparison table with use cases

- **5 Basic Usage Examples**
  - Simple service injection
  - Service with dependencies (DbContext)
  - Multiple dependencies in controller
  - Injecting configuration
  - Lifetime demonstration (counter service)

- **4 Practical Examples**
  - Repository Pattern with complete layered architecture
  - Service with Options pattern (strongly-typed configuration)
  - Multiple implementations (environment-based)
  - Named services with Factory pattern

- **8 Best Practice Patterns**
  - Prefer constructor injection
  - Depend on interfaces not implementations
  - Use appropriate lifetimes (table with recommendations)
  - Avoid captive dependencies
  - Register services in logical order
  - Use extension methods for organization
  - Validate service registration
  - Document service dependencies

- **6 Troubleshooting Scenarios**
  - Unable to resolve service
  - Circular dependency detection
  - Captive dependency issues
  - DbContext already disposed
  - Multiple implementations registered
  - Null reference in constructor

### Key Features
✅ Beginner-friendly IoC and DI explanation with real-world analogies
✅ Complete service lifetime diagrams and comparisons
✅ Project structure recommendations
✅ Layered architecture example (Repository → Service → Controller)
✅ Testing with DI (unit tests with mocks)
✅ Captive dependency warnings
✅ Comprehensive troubleshooting section
✅ Self-assessment checklist
✅ Rich resource list

The document follows the technology topic template with all 12 sections providing foundational knowledge for understanding and implementing Dependency Injection in ASP.NET Core.
