---
description: Set up Trainset Lite workflow for this project
---

# Setup Command

You are helping set up **Trainset Lite** - a lightweight workflow system using markdown files and slash commands.

## Your Task

### 1. Conduct Interview

- Read `.trainset/starter/interviews/base.md` 
- Read relevant domain-specific interview (development.md, learning.md, etc.)
- Ask the user these questions and capture their responses
- Create `INTERVIEW.md` in project root with their answers

### 2. Generate Workflow Files

**Step 1: Create Scaffolds** (run these inline)

!`bash .trainset/scripts/create-workflow.sh`
!`bash .trainset/scripts/create-context.sh`
!`bash .trainset/scripts/create-progress.sh`

These commands create files with `[FILL IN]` placeholders for all mandatory sections.

**Step 2: Synthesize Content**

Now read:
- `.trainset/starter/template-library.md` for patterns and guidance
- The interview responses you collected

Based on the interview, fill in all `[FILL IN]` placeholders in:
- `.trainset/WORKFLOW.md` - Custom phases adapted to their project
- `.trainset/CONTEXT.md` - Project details (tech stack, commands, constraints)
- `.trainset/PROGRESS.md` - Initialize to Phase 1 with checklist from workflow

### 3. Set Up Commands

- Copy all system commands to the appropriate platform directory:
  - Claude Code: `.claude/commands/`
  - OpenCode: `.opencode/command/`
- Copy/adapt relevant project commands based on tech stack
- You can rename, combine, or create new commands as needed
- Tell user to restart their agent CLI so commands register

## Key Principles

- **Be specific** - "Design REST API endpoints" not "Design phase"
- **Make gates assessable** - LLM should be able to evaluate progress through conversation
- **Adapt, don't copy** - Use template library as inspiration, customize to project
- **Start simple** - 4-6 phases max, can always add complexity later

## After Setup

Tell the user:
1. **Restart your agent CLI** so new commands are available
2. **Use `/status`** to see current state
3. **Use `/advance`** when ready to move to next phase
4. **Workflow is in `.trainset/WORKFLOW.md`** if they want to review/adjust

Remember: Trainset Lite is about **guidance, not enforcement**. The workflow should help structure their work, not constrain it.
