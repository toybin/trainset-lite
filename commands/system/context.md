---
description: Show project context and configuration
---

# Context Command

!`bash .trainset/scripts/extract-context.sh 2>&1 || echo '{"success": false, "error": "extract-context.sh not found - reading files manually"}'`

Parse the JSON output above and format it for the user:

## Format as:

### Project Overview
- **Name:** [project.name]
- **Type:** [project.type]
- **Workflow:** [project.workflow]

### Technical Stack
[Parse tech_stack and format as bullet list]

### Key Commands
[Parse commands and format cleanly]

### Current Focus
- **Active Phase:** [active_phase]
- [Parse current_focus.details if available]

---

## Additional Context (if needed)

If JSON error or missing info, read these files directly:
- `.trainset/CONTEXT.md` - Full project details
- `.trainset/WORKFLOW.md` - Workflow principles (overview only)
- `.trainset/trainset.toml` - Basic configuration

## What to Show

Focus on information most relevant to:
- Understanding the project's purpose and tech stack
- Knowing what commands to run (test, lint, build, etc.)
- Understanding current phase and goals
- Orienting after time away or between sessions

## Usage Notes

- **For users:** Quick reminder of project setup and current context
- **For AI:** Essential context for providing relevant assistance
- **For handoffs:** When switching between AI assistants
- **For debugging:** When workflow feels off-track or unclear
