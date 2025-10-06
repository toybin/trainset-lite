# Project Workflow System

This project uses **Trainset Lite** - a structured workflow management system for AI-assisted development.

## Overview

Trainset Lite provides:
- **Phased workflow** with clear gates between phases
- **Progress tracking** via markdown checklists
- **Bash automation** for efficient state management
- **Slash commands** for workflow operations

## Key Files

- `.trainset/WORKFLOW.md` - Phase definitions with inputs, outputs, gates
- `.trainset/CONTEXT.md` - Project context, tech stack, constraints
- `.trainset/PROGRESS.md` - Current phase and checklist progress
- `.trainset/scripts/` - Bash helpers for automation

## Workflow Commands

Use these slash commands to interact with the workflow:

- **`/status`** - Show current phase, progress, and next steps
- **`/gate-check`** - Assess readiness to advance (detailed gate evaluation)
- **`/advance`** - Move to next phase (only if gates pass)
- **`/context`** - Display project context and technical details
- **`/setup`** - Initialize a new workflow (first-time setup)

## Working with Trainset

### Starting a Session

1. Always run `/status` first to see current phase and progress
2. Review the checklist in `.trainset/PROGRESS.md`
3. Check `.trainset/CONTEXT.md` for project-specific constraints

### During Work

- Mark checklist items complete as you finish them
- Update `.trainset/PROGRESS.md` manually or use bash helpers
- Reference phase gates in `.trainset/WORKFLOW.md` for quality criteria

### Advancing Phases

1. Run `/gate-check` to evaluate all gate criteria
2. Address any incomplete items or blockers
3. When ready, run `/advance` to move to the next phase
4. The system validates gates and updates progress automatically

## Best Practices

- **Don't skip phases** - Each phase builds on the previous
- **Respect gates** - They prevent technical debt and ensure quality
- **Update progress regularly** - Keep `.trainset/PROGRESS.md` current
- **Use bash helpers** - They're faster and more reliable than manual updates

## Bash Helpers

Available in `.trainset/scripts/`:

- `status.sh` - Extract current status (JSON output)
- `validate-gate.sh` - Check gate readiness
- `advance-phase.sh` - Orchestrate phase advancement
- `update-progress.sh` - Mark checklist items complete

These are called automatically by slash commands but can be run directly if needed.

## Example Session

```
> /status
[Shows Phase 2 - Implement Core Features, 3/7 items complete]

> /gate-check
[Shows 4 remaining items with specific guidance]

[Work on items...]

> /advance
[Validates gates, advances to Phase 3 if ready]
```

## Memory Persistence

This file (`.claude/CLAUDE.md`) persists across sessions, so workflow context is always available. The workflow state lives in `.trainset/PROGRESS.md` which is updated as you work.
