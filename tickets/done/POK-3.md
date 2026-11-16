---
title: Implement Option B - Standard Context & Ticketing System Setup
priority: high
size: L
labels: [setup, documentation, tooling]
created: 2026-11-13
---

## Context
Set up proper context and rules for the PokemonApp project to ensure all Claude Code agents have consistent context, follow proper workflows, and maintain high-quality standards. This will make future ticket-based development efficient and consistent.

## Reference
Complete specification is available at: `docs/v2026/TICKET_OPTION_B_SPEC.md`

## Objectives
- Provide automatic context to any Claude Code agent working on this project
- Enforce consistent ticketing workflow using the existing Clonear system
- Document project standards and conventions
- Create helper commands for common ticket operations

## What to Implement

### 1. Claude Code Custom Instructions (`.claude/instructions.md`)
Create a comprehensive instructions file that is automatically loaded by every Claude Code session. Must include:
- Project overview and technology stack
- Required reading on session start
- Ticketing system rules and workflow
- Agent workflow for tickets (before/during/after)
- Code standards (.NET conventions, Git commit standards)
- Common tasks and procedures

**Full content is in the spec document - copy the template provided.**

### 2. Enhanced Ticket Template (Update `tickets/clonear.md`)
Append additional sections to existing clonear.md:
- Best practices for writing tickets (with good/bad examples)
- Ticket sizing guide (S/M/L definitions)
- Priority levels explanation
- Workflow diagram
- Validation checklist before marking tickets done

**Append the content from spec document to existing clonear.md.**

### 3. Project Context Document (`docs/PROJECT_CONTEXT.md`)
Create central documentation that evolves with the project:
- Project overview and goals
- Architecture (current and planned)
- Technology stack
- Development guidelines (naming, async/await, error handling, DI)
- Common patterns (to be filled as implemented)
- Architectural Decision Records (ADRs)
- Known issues

**Full content template is in the spec document.**

### 4. Slash Commands
Create 3 slash command files in `.claude/commands/` directory:

**a. `.claude/commands/ticket-start.md`**
- Automates starting a ticket
- Moves from todo to in-progress
- Reads PROJECT_CONTEXT.md
- Creates git commit
- Sets up TodoWrite tasks

**b. `.claude/commands/ticket-done.md`**
- Verifies acceptance criteria
- Moves from in-progress to done
- Creates git commit
- Clears TodoWrite tasks

**c. `.claude/commands/new-ticket.md`**
- Finds next POK number
- Prompts for ticket details
- Creates properly formatted ticket
- Git commit

**Full content for each command is in the spec document.**

### 5. Documentation
Create `.claude/README.md` explaining the custom instructions setup.

## Implementation Order
1. Create `.claude/instructions.md` (most important)
2. Create `docs/PROJECT_CONTEXT.md`
3. Update `tickets/clonear.md` (append, don't replace)
4. Create `.claude/commands/` directory if needed
5. Create the 3 slash command files
6. Create `.claude/README.md`
7. Commit in logical chunks
8. Push to GitHub

## Testing After Implementation
1. Start a new Claude Code session (verify instructions auto-load)
2. Test `/new-ticket` command
3. Test `/ticket-start POK-X` command
4. Test `/ticket-done POK-X` command

## Acceptance Criteria

### Must Have (Required)
- [ ] `.claude/instructions.md` created with all sections as specified in TICKET_OPTION_B_SPEC.md
- [ ] `tickets/clonear.md` updated (appended) with Best Practices, examples, workflow diagram, and checklist
- [ ] `docs/PROJECT_CONTEXT.md` created with all sections as specified
- [ ] `.claude/commands/` directory exists
- [ ] `.claude/commands/ticket-start.md` created and functional
- [ ] `.claude/commands/ticket-done.md` created and functional
- [ ] `.claude/commands/new-ticket.md` created and functional
- [ ] `.claude/README.md` created explaining the setup
- [ ] All new files committed to git with proper commit messages
- [ ] All new files pushed to GitHub
- [ ] No syntax errors in any markdown files
- [ ] YAML frontmatter in slash commands is valid

### Should Have (Important)
- [ ] Test each slash command works correctly
- [ ] Verify instructions.md is automatically loaded in new Claude Code session

### Nice to Have (Optional)
- [ ] Add more examples to PROJECT_CONTEXT.md
- [ ] Create a quick reference guide

## Notes
- **DO NOT** replace existing content in `tickets/clonear.md`, only append
- Use the exact content templates from `docs/v2026/TICKET_OPTION_B_SPEC.md`
- Create separate git commits for logical groupings (instructions, context doc, clonear update, commands)
- Test the slash commands after implementation
- Update the "Last Updated" date in PROJECT_CONTEXT.md to today's date
