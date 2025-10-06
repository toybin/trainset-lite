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
- ✅ [List completed items from PROGRESS.md]

### What's Remaining
- ⏳ [List remaining items from PROGRESS.md with specific guidance]

### Recommendations

[If gate_ready = true:]
- **All gate criteria satisfied!** Ready to advance.
- Run `/advance` when ready to move to next phase

[If gate_ready = false:]
- **Priority tasks:** [List remaining items]
- **Estimated time to gate:** [Estimate based on remaining work]
- **Suggestions:** [Specific next steps for each incomplete item]

---

## Assessment Guidelines

For each remaining item:
- Ask user about progress if needed
- Provide specific feedback on what's needed
- Estimate completion time
- Suggest concrete next actions
- Be encouraging about progress made

## Helpful Prompts

When assessing items, consider asking:
- "Can you walk me through [specific item]?"
- "What does [deliverable] look like in your project?"
- "How confident are you that [item] meets the requirement?"
- "What would need to change for this to be complete?"
- "Is there anything blocking you on [item]?"
