---
description: Show current Trainset Lite workflow status
---

# Status Command

!`bash .trainset/scripts/status.sh 2>&1 || echo '{"success": false, "error": "status.sh not found - reading files manually"}'`

Parse the JSON output above and format it into a user-friendly status report:

## Format as:

### Current State
- **Project:** [from project context or CONTEXT.md]
- **Current Phase:** [phase_number] - [current_phase]
- **Purpose:** [purpose from JSON or WORKFLOW.md]

### Progress ([completed]/[total] completed)
- ✅ [completed items from PROGRESS.md]
- ⏳ [remaining items from PROGRESS.md]

**Gate Status:** [✅ Ready | ❌ Not ready] ([remaining] items remaining)

### Next Steps
- **Immediate:** [suggest next unchecked item]
- **Upcoming:** [preview next phase from WORKFLOW.md]

### Available Commands
- `/advance` - Move to next phase (if gate ready)
- `/gate-check` - Assess readiness to advance
- `/context` - Show project context

---

## Notes

- Be encouraging about progress made
- Be specific about what's needed to advance
- If JSON shows error, fall back to reading files manually
- If PROGRESS.md doesn't exist, suggest running `/setup` first
