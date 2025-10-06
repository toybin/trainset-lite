---
description: Advance to the next phase after validating gates
---

# Advance Command

!`bash .trainset/scripts/advance-phase.sh 2>&1`

Parse the JSON output above and respond accordingly:

## If success = true (Advanced successfully)

🎉 **Congratulations! Advanced to Phase [current_phase]**

### [phase_title]

**Purpose:** [phase_purpose]

You've completed Phase [previous_phase] and moved to Phase [current_phase]!

### What's Next

[Read the new phase checklist from PROGRESS.md and explain:]
- Overview of this phase's goals
- First few tasks to tackle
- What success looks like

**Backup created:** [backup file path]

Use `/status` to see your new checklist.

---

## If success = false AND gate_ready = false (Gate not ready)

❌ **Gate Not Ready**

You still have work to complete before advancing:

**Status:** [completed]/[total] items complete  
**Remaining:** [remaining] items

### Blockers
[List unchecked items from PROGRESS.md]

### Suggested Next Steps
1. [Suggest which item to tackle next]
2. [Provide concrete guidance]
3. [Estimate time to completion]

Use `/gate-check` for detailed assessment of each item.

---

## If success = false AND final_phase = true (Workflow complete)

🎉 **Congratulations!**

You've completed the final phase of your workflow!

[message from JSON]

### What's Next
- Review your completed work
- Consider starting a new workflow if needed
- Reflect on what worked well

---

## Error Handling

- If PROGRESS.md doesn't exist: "Run `/setup` first to initialize workflow"
- If WORKFLOW.md is malformed: "Please check `.trainset/WORKFLOW.md` for formatting issues"
- If script error: Fall back to manual gate assessment and PROGRESS.md update
