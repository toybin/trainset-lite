# Trainset Lite Workflow System

This project uses **Trainset Lite** for structured, phase-based development.

## System Overview

Trainset Lite provides:
- Phased workflow with validation gates
- Progress tracking via markdown checklists
- Bash automation for state management
- Slash commands for workflow operations

## Essential Rules

1. **Always check status first**: Run `/status` at the start of each session
2. **Follow current phase**: Work on items in `.trainset/PROGRESS.md` checklist
3. **Mark items complete**: Update progress as you finish tasks
4. **Validate before advancing**: Use `/gate-check` before `/advance`
5. **Respect gates**: Only advance when all gate criteria are satisfied

## File Structure

```
.trainset/
├── WORKFLOW.md     # Phase definitions (inputs, outputs, gates)
├── CONTEXT.md      # Project details and constraints
├── PROGRESS.md     # Current state and checklist
└── scripts/        # Bash helpers for automation
```

## Available Commands

- `/status` - Current phase, progress, next steps
- `/gate-check` - Detailed readiness assessment
- `/advance` - Move to next phase (validates gates)
- `/context` - Project context and tech details
- `/setup` - Initialize new workflow

## Workflow Process

### 1. Start Session
```
/status
```
Check current phase and see what needs to be done.

### 2. Work on Tasks
- Review checklist in `.trainset/PROGRESS.md`
- Complete items according to phase requirements
- Update progress markers as you go

### 3. Gate Validation
```
/gate-check
```
Get detailed assessment of readiness to advance.

### 4. Advance Phase
```
/advance
```
Move to next phase when all gates pass.

## Working Guidelines

**Phase Structure:**
- Each phase has: Purpose, Inputs, Outputs, Process, Gate
- Gates are checklists that must be completed
- Phases build sequentially - don't skip

**Progress Tracking:**
- `.trainset/PROGRESS.md` contains current checklist
- Mark items: `- [x]` for complete, `- [ ]` for incomplete
- Bash helpers can update this automatically

**Context Awareness:**
- `.trainset/CONTEXT.md` has project-specific details
- Tech stack, commands, constraints, success criteria
- Reference this for project-specific decisions

## Automation

Bash scripts in `.trainset/scripts/` provide:
- `status.sh` - JSON status extraction
- `validate-gate.sh` - Gate validation
- `advance-phase.sh` - Orchestrated advancement
- Plus utilities for structure validation and updates

Commands use these automatically but you can call them directly.

## Best Practices

✅ **Do:**
- Check `/status` at session start
- Update progress regularly
- Use `/gate-check` before advancing
- Follow phase order
- Mark items complete as you finish

❌ **Don't:**
- Skip phases
- Advance without validating gates
- Ignore checklist items
- Make architectural decisions outside current phase

## Example Workflow

```
Session 1:
> /status
Phase 1 - Design (2/5 complete)

[Complete 3 more items]

> /gate-check
Not ready - 1 item remaining

Session 2:
> /status
Phase 1 - Design (4/5 complete)

[Complete final item]

> /advance
✅ Advanced to Phase 2 - Implementation
```

This rule file persists context across sessions so the workflow system is always in context.
