---
description: Advance to the next phase after validating gates
---

# Advance Command

!`bash .trainset/scripts/advance-phase.sh 2>&1`

Parse the JSON output above and respond accordingly:

## If success = true (Advanced successfully)

🎉 **Congratulations! Advanced to Phase [current_phase_order]**

### [phase_name]

**Phase ID:** [current_phase]
**Purpose:** [phase_purpose]

You've completed Phase [previous_phase_order] ([previous_phase]) and moved to Phase [current_phase_order]!

### What's Next

[Read the new phase gates from workflow.yaml and state.yaml, and explain:]
- Overview of this phase's goals (from workflow.yaml purpose field)
- Gates for this phase (list gate IDs, descriptions, and validation_hint from workflow.yaml)
- First few gates to tackle
- What success looks like for this phase

**State backup created:** [backup file path]

Use `/status` to see your new checklist and gate status.

---

## If success = false AND gate_ready = false (Gate not ready)

❌ **Gate Not Ready**

You still have work to complete before advancing:

**Status:** [completed]/[total] gates complete
**Remaining:** [remaining] gate(s)

### Incomplete Gates
[List incomplete gates from state.yaml with descriptions and validation_hint from workflow.yaml]

### Suggested Next Steps
1. [Suggest which gate to tackle next based on validation_hint]
2. [Provide concrete guidance for completing the gate]
3. [Estimate time to completion]

Use `/gate-check` for detailed assessment of each gate.

---

## If success = false AND final_phase = true (Workflow complete)

🎉 **Congratulations!**

You've completed the final phase of your workflow!

[message from JSON]

### What's Next
- Review your completed work
- Consider starting a new workflow if needed
- Reflect on what worked well
- Consider adding a reflection session to state.yaml

---

## Error Handling

- If state.yaml doesn't exist: "Run `/setup` first to initialize workflow"
- If workflow.yaml is malformed: "Please check `.trainset/workflow.yaml` for syntax issues"
- If yq not installed: "Install yq from https://github.com/mikefarah/yq"
- If script error: Fall back to reading YAML files directly for manual assessment

## Context Files

The advance script updates state.yaml. After advancing:
- state.yaml reflects the new current_phase
- workflow.yaml defines the gates for the new phase
- WORKFLOW.md provides narrative explanation of the new phase
