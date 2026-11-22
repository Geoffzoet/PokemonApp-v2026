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
- [ ] Document created at `docs/v2026/topics/dependency-injection.md`
- [ ] All 12 template sections completed
- [ ] DI benefits clearly explained
- [ ] Service lifetimes with diagrams
- [ ] Scoped vs Transient vs Singleton examples
- [ ] Constructor injection examples
- [ ] Real-world service examples
- [ ] 3+ hands-on exercises
- [ ] Common DI pitfalls
- [ ] Estimated reading time: 60-75 minutes
