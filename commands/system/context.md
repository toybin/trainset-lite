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
- `.trainset/CONTEXT.md` - Full project details, architecture, constraints
- `.trainset/WORKFLOW.md` - Narrative workflow explanation with phase details
- `.trainset/INTERVIEW.md` - Original project interview responses
- `.trainset/workflow.yaml` - Machine-readable workflow definition (phases, gates, commands)
- `.trainset/state.yaml` - Current progress state (phase, gate status, stats)

## What to Show

Focus on information most relevant to:
- Understanding the project's purpose and tech stack
- Knowing what commands to run (from workflow.yaml commands section)
- Understanding current phase and goals (from state.yaml + workflow.yaml)
- Orienting after time away or between sessions
- Seeing overall workflow structure and remaining phases

## Enhanced Context Display

When formatting context, consider including:
- Current phase name and purpose (from workflow.yaml)
- Gates completed vs remaining for current phase (from state.yaml)
- Overall progress percentage (from state.yaml stats)
- Project principles and quality standards (from workflow.yaml)
- Upcoming phases preview (from workflow.yaml)

## Usage Notes

- **For users:** Quick reminder of project setup and current context
- **For AI:** Essential context for providing relevant assistance
- **For handoffs:** When switching between AI assistants or sessions
- **For debugging:** When workflow feels off-track or unclear
- **For planning:** Understanding what's ahead in the workflow
