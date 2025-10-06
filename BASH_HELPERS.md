# Trainset Lite Bash Helpers

## Overview

Trainset Lite now includes optional bash helper scripts that make LLM commands more efficient by:
- Extracting data deterministically (no LLM parsing needed)
- Reducing token usage (read only needed sections)
- Providing standardized JSON output
- Validating structure compliance

These scripts are **optional** - Trainset Lite still works without them, but they enhance performance.

## Philosophy

**Trainset Lite remains manual:**
- Human/LLM still decides when to advance
- No automated phase progression
- No enforced gates
- Markdown files are source of truth

**Bash helpers just extract data:**
- Parse markdown efficiently
- Count checklist items
- Validate structure
- Output JSON for easy parsing

**LLMs orchestrate, bash assists:**
- LLM reads bash JSON output
- LLM formats for human consumption
- LLM makes decisions
- Bash just does the tedious parsing

## What Was Added

### Scripts Directory: `.trainset/scripts/`

1. **`status.sh`** - Extract current phase and progress
2. **`validate-gate.sh`** - Check if gate criteria met
3. **`list-phases.sh`** - List all phases with status
4. **`get-section.sh`** - Extract markdown sections
5. **`validate-structure.sh`** - Validate file structure
6. **`update-progress.sh`** - Mark items complete/incomplete
7. **`README.md`** - Full documentation

### Updated Command Example

**`.opencode/command/status.md`** now uses bash helper:
```markdown
---
tools:
  - bash
---

# Status Command

## Bash Helper (Recommended)
bash .trainset/scripts/status.sh

Parse JSON and format for user.

## Fallback (Manual Read)
Read PROGRESS.md directly if bash unavailable.
```

## Benefits Over Pure LLM Approach

**Before (LLM reads full file):**
- LLM reads entire PROGRESS.md (~2000 tokens)
- LLM parses structure in its head
- LLM counts checkboxes
- LLM calculates percentages
- Total: ~2000+ tokens

**After (bash helper):**
- Bash reads and parses file
- Bash outputs 200-byte JSON
- LLM reads JSON (~50 tokens)
- LLM formats for human
- Total: ~50 tokens

**Token savings: 97.5%**

## Comparison to Trainset Full

### Trainset Lite (with bash helpers)
- **Automation:** None - manual tracking
- **State:** Markdown files
- **Gates:** Manual assessment
- **Commands:** LLM instructions + bash parsers
- **Hierarchy:** Flat (single workflow)
- **Purpose:** Simple projects, manual control

### Trainset Full (Python CLI)
- **Automation:** Full - CLI manages state
- **State:** TOML files with state machine
- **Gates:** Bash scripts with automated execution
- **Commands:** Python CLI commands
- **Hierarchy:** Multi-level (Initiative/Epic/Story)
- **Purpose:** Complex projects, automated tracking

## Design Decisions

### Why Bash Instead of Python?

1. **Simplicity** - Bash is universal, no dependencies
2. **Lite philosophy** - Keep it lightweight
3. **No state changes** - Just read and parse
4. **Optional** - Falls back to manual if unavailable

### Why JSON Output?

1. **Standardized** - Easy for LLMs to parse
2. **Structured** - Type-safe data
3. **Composable** - Can pipe to jq, parse in any language
4. **Error handling** - Clear success/failure

### Why Optional?

1. **Graceful degradation** - Works without bash
2. **User choice** - Some prefer pure manual
3. **Environment flexibility** - Not all systems have bash
4. **Backward compatible** - Existing workflows unaffected

## Usage Example

**Manual approach (still works):**
```bash
# Open PROGRESS.md
cat .trainset/PROGRESS.md

# Manually count: 3 of 8 items complete
# Manually check: Gate not ready
```

**With bash helper:**
```bash
# Run helper
bash .trainset/scripts/status.sh

# Get instant JSON:
{
  "completed": 3,
  "remaining": 5,
  "total": 8,
  "gate_ready": false,
  "progress_percent": 37.5
}
```

## Integration with Commands

LLM commands can now:

1. **Check status efficiently:**
   ```markdown
   !`bash .trainset/scripts/status.sh`
   [Format JSON for user]
   ```

2. **Validate gates before advancing:**
   ```markdown
   !`bash .trainset/scripts/validate-gate.sh`
   [If gate_ready: proceed, else: show blockers]
   ```

3. **Extract specific sections:**
   ```markdown
   !`bash .trainset/scripts/get-section.sh .trainset/WORKFLOW.md "Phase 2"`
   [Show only Phase 2 details]
   ```

4. **Validate structure:**
   ```markdown
   !`bash .trainset/scripts/validate-structure.sh`
   [Report missing sections]
   ```

## Error Handling

All scripts:
- Exit 0 on success, 1 on error
- Output errors to stderr as JSON
- Handle missing files gracefully
- Validate inputs before processing
- Provide helpful error messages

**Example error:**
```json
{
  "success": false,
  "error": "PROGRESS.md not found"
}
```

## Future Enhancements (Maybe)

Potential additions if proven useful:
- `estimate-completion.sh` - Estimate time to gate based on velocity
- `suggest-next.sh` - Suggest which checklist item to tackle next
- `export-status.sh` - Export status as markdown/html
- `compare-phases.sh` - Compare current phase to workflow definition

But keep it simple - only add if genuinely valuable.

## Success Metrics

This enhancement succeeds if:
- ✅ LLM commands run faster (fewer tokens)
- ✅ Status extraction is more reliable
- ✅ Users can still work manually if preferred
- ✅ Scripts are simple and maintainable
- ✅ Trainset Lite remains lightweight

## Meta Note

We built these bash helpers while using Trainset Lite to build Trainset Full. This is dogfooding in action - we identified pain points (LLM reading full files) and solved them with minimal additions.

The fact that we're successfully using Trainset Lite to manage complex development proves it works. These helpers just make it work *better*.
