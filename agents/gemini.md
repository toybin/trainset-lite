# Development Workflow: Trainset Lite

This project uses **Trainset Lite** - a structured workflow system for phase-based development.

## What is Trainset Lite?

A lightweight workflow management system that provides:
- **Phased development** with clear progression
- **Gate validation** between phases
- **Progress tracking** via markdown checklists
- **Bash automation** for workflow operations

## File Locations

Key workflow files in `.trainset/`:

- `WORKFLOW.md` - Phase definitions (purpose, inputs, outputs, gates)
- `CONTEXT.md` - Project context, tech stack, constraints
- `PROGRESS.md` - Current phase and progress checklist
- `scripts/` - Bash helpers for automation

## Before Starting Work

**Always check current state:**

```bash
# Option 1: Use bash helper
bash .trainset/scripts/status.sh

# Option 2: Read directly
cat .trainset/PROGRESS.md
```

This shows:
- Current phase
- Checklist items (complete/incomplete)
- Gate readiness
- Progress percentage

## During Development

### 1. Review Current Phase

Read `.trainset/WORKFLOW.md` for current phase:
- **Purpose**: What this phase accomplishes
- **Inputs**: What's needed to start
- **Outputs**: What you should produce
- **Process**: Steps to follow
- **Gate**: Checklist that must pass

### 2. Work on Checklist Items

In `.trainset/PROGRESS.md`:
- `- [ ]` = Incomplete item
- `- [x]` = Complete item

Mark items complete as you finish them.

### 3. Validate Gates

Before advancing to next phase:

```bash
bash .trainset/scripts/validate-gate.sh
```

This checks if all gate criteria are satisfied.

### 4. Advance Phase

When ready to move forward:

```bash
bash .trainset/scripts/advance-phase.sh
```

This:
- Validates all gates pass
- Updates PROGRESS.md to next phase
- Creates backup of previous state
- Extracts next phase checklist

## Helper Scripts

Available in `.trainset/scripts/`:

**Status & Validation:**
- `status.sh` - Get current phase and progress (JSON)
- `validate-gate.sh` - Check if ready to advance
- `list-phases.sh` - Show all phases and status

**Updates:**
- `advance-phase.sh` - Orchestrate phase advancement
- `update-progress.sh` - Mark checklist items complete/incomplete

**Utilities:**
- `get-section.sh` - Extract markdown sections
- `validate-structure.sh` - Validate file structure
- `extract-context.sh` - Get project context

## Workflow Example

```bash
# Start session - check status
bash .trainset/scripts/status.sh
# Output: Phase 1 - Design, 3/5 complete

# Work on incomplete items
# ... make changes ...

# Update progress
bash .trainset/scripts/update-progress.sh "Create API design" complete

# Check gate readiness
bash .trainset/scripts/validate-gate.sh
# Output: 2 of 5 items remaining

# Continue working...
# ... complete remaining items ...

# Advance when ready
bash .trainset/scripts/advance-phase.sh
# Output: Successfully advanced to Phase 2
```

## Project Context

Always reference `.trainset/CONTEXT.md` for:
- Project overview and goals
- Technical stack and tools
- Key commands (test, lint, build, run)
- Working constraints and standards
- Success criteria

Extract context efficiently:
```bash
bash .trainset/scripts/extract-context.sh
```

## Workflow Principles

**Phase-based Development:**
- Work progresses through defined phases
- Each phase has clear inputs, outputs, and gates
- Phases build sequentially (don't skip)

**Gate Validation:**
- Gates are checklists that must pass to advance
- Ensure quality and completeness
- Prevent technical debt and shortcuts

**Progress Tracking:**
- `.trainset/PROGRESS.md` is source of truth
- Update regularly as you complete items
- Use bash helpers for consistency

## Best Practices

✅ **Do:**
- Check status at start of each session
- Follow the current phase's process
- Mark checklist items as you complete them
- Validate gates before advancing
- Reference CONTEXT.md for project specifics

❌ **Don't:**
- Skip phases or gates
- Advance without completing checklists
- Make architectural decisions outside design phases
- Ignore workflow structure

## Setup New Workflow

If starting fresh, initialize with:

```bash
# Create scaffolds
bash .trainset/scripts/create-workflow.sh
bash .trainset/scripts/create-context.sh
bash .trainset/scripts/create-progress.sh

# Then fill in the [FILL IN] placeholders
# based on project requirements
```

## Support

- Documentation: `.trainset/README.md`
- Bash helpers: `.trainset/scripts/README.md`
- Design rationale: `.trainset/BASH_HELPERS.md`

---

**Remember:** Trainset Lite is about guidance and structure, not rigid enforcement. Adapt as needed, but maintain the core principle of phased, validated progress.
