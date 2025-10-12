---
description: Assess readiness to advance to next phase
---

# Gate Check Command

!`bash .trainset/scripts/validate-gate.sh 2>&1 || echo '{"success": false, "error": "validate-gate.sh not found"}'`

Parse the JSON output above and provide a detailed gate assessment:

## Format as:

### Overall Assessment: [Ready ✅ | Nearly Ready ⚠️ | Not Ready ❌]

**Status:** [completed]/[total] items complete

**Gate Ready:** [Yes/No]

### What's Complete
- ✅ [List completed gates with descriptions from workflow.yaml]

### What's Remaining
- ⏳ [List remaining gates with descriptions and validation_hint from workflow.yaml]

### Recommendations

[If gate_ready = true:]
- **All gate criteria satisfied!** Ready to advance.
- Run `/advance` when ready to move to Phase [next_phase_number]

[If gate_ready = false:]
- **Priority gates:** [List remaining gates with specific validation hints]
- **Estimated time to gate:** [Estimate based on remaining work]
- **Suggestions:** [Specific next steps for each incomplete gate, using validation_hint field]

---

## Assessment Guidelines

For each remaining gate:
- Reference the gate's description and validation_hint from workflow.yaml
- Ask user about progress if needed
- Provide specific feedback based on validation_hint
- Estimate completion time
- Suggest concrete next actions
- Be encouraging about progress made

The JSON output includes a "failed_gates" array with gate IDs and descriptions. Use this to focus the assessment.

## Helpful Prompts

When assessing gates, consider asking:
- "Can you walk me through [gate description]?"
- "Have you [validation_hint]?"
- "How confident are you that [gate] meets the requirement?"
- "What would need to change for [gate] to pass?"
- "Is there anything blocking you on [gate]?"

## Reading YAML Files

If you need more context beyond the JSON output:
- workflow.yaml contains gate definitions, descriptions, and validation_hint
- state.yaml contains the current gate_status (true/false) for each gate
- WORKFLOW.md contains narrative explanations of what each gate means
