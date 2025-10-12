---
description: Show current Trainset Lite workflow status
---

# Status Command

!`bash .trainset/scripts/status.sh 2>&1 || echo '{"success": false, "error": "status.sh not found - reading files manually"}'`

Parse the JSON output above and format it into a user-friendly status report:

## Format as:

### Current State
- **Project:** [from project context or CONTEXT.md]
- **Current Phase:** [phase_number] - [current_phase_name] (id: [current_phase_id])
- **Started:** [phase_started]
- **Purpose:** [purpose from JSON or WORKFLOW.md]

### Progress ([completed]/[total] gates completed)
- ✅ [list completed gates with descriptions from workflow.yaml]
- ⏳ [list remaining gates with descriptions and validation hints]

**Gate Status:** [✅ Ready | ❌ Not ready] ([remaining] gate(s) remaining)

### Overall Progress
- **Phases:** [phases_completed]/[total_phases] complete
- **All Gates:** [gates_passed]/[total_gates] passed
- **Completion:** [completion_percentage]%

### Next Steps
- **Immediate:** [suggest next incomplete gate based on state.yaml + workflow.yaml]
- **Upcoming:** [preview next phase from workflow.yaml if current phase gates complete]

### Available Commands
- `/advance` - Move to next phase (if gate ready)
- `/gate-check` - Assess readiness to advance
- `/context` - Show project context

---

## Notes

- Parse both JSON output and state.yaml/workflow.yaml files for complete picture
- Gates are defined in workflow.yaml with descriptions and validation hints
- Gate status (true/false) is tracked in state.yaml
- Be encouraging about progress made
- Be specific about what's needed to advance
- If JSON shows error, fall back to reading YAML files directly with yq or by reading them
- If state.yaml doesn't exist, suggest running `/setup` first
- Reference gate IDs and their human-readable descriptions from workflow.yaml
