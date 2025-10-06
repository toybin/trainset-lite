# Trainset Lite Bash Helper Scripts

These optional bash scripts help LLMs and humans efficiently work with Trainset Lite workflows. They map to slash commands and output standardized JSON.

## Overview

**Location:** `.trainset/scripts/` (when copied to a new project)

**Philosophy:** Each script corresponds to a command or provides a specific utility. Flat structure for simplicity.

**All scripts are optional** - Commands can fall back to manual file reading if scripts aren't available.

---

## Command Scripts

These scripts directly support slash commands:

### `/status` → `status.sh`
Extract current phase and progress information.

**Usage:** `bash .trainset/scripts/status.sh`

**Output:**
```json
{
  "success": true,
  "current_phase": "Phase 1 - Design Architecture",
  "phase_number": 1,
  "completed": 3,
  "remaining": 5,
  "total": 8,
  "gate_ready": false,
  "progress_percent": 37.5
}
```

---

### `/gate-check` → `validate-gate.sh`
Check if current phase gate criteria are met.

**Usage:** `bash .trainset/scripts/validate-gate.sh`

**Output:**
```json
{
  "success": true,
  "gate_ready": false,
  "completed": 3,
  "remaining": 5,
  "total": 8,
  "message": "5 of 8 items remaining"
}
```

**Exit code:** 0 if gate ready, 1 if not ready

---

### `/advance` → `advance-phase.sh`
Orchestrate phase advancement (validate gate → update PROGRESS.md → extract next phase info).

**Usage:** `bash .trainset/scripts/advance-phase.sh`

**Output (success):**
```json
{
  "success": true,
  "previous_phase": 1,
  "current_phase": 2,
  "phase_title": "Implement Core Features",
  "phase_purpose": "Build the main functionality",
  "backup": ".trainset/PROGRESS.md.bak"
}
```

**Output (gate not ready):**
```json
{
  "success": false,
  "gate_ready": false,
  "completed": 3,
  "remaining": 2,
  "message": "Gate not ready: 2 of 5 items remaining"
}
```

---

### `/context` → `extract-context.sh`
Extract commonly-needed context information efficiently.

**Usage:** `bash .trainset/scripts/extract-context.sh`

**Output:**
```json
{
  "success": true,
  "project": {
    "name": "My Project",
    "type": "Development",
    "workflow": "Iterative Development"
  },
  "tech_stack": "Python|Django|PostgreSQL",
  "commands": "...",
  "active_phase": "Phase 1 - Setup"
}
```

---

### `/setup` → Setup Scripts

Three scripts create document scaffolds with `[FILL IN]` placeholders:

#### `create-workflow.sh`
**Usage:** `bash .trainset/scripts/create-workflow.sh`

**Creates:** `.trainset/WORKFLOW.md` with sections:
- `## Principles`
- `## Phases` (with Purpose/Inputs/Outputs/Process/Gate)
- `## Commands`
- `## Adaptation Notes`

#### `create-context.sh`
**Usage:** `bash .trainset/scripts/create-context.sh`

**Creates:** `.trainset/CONTEXT.md` with sections:
- `## Project Overview`
- `## Technical Details`
- `## Architecture`
- `## Working Context`
- `## Project Constraints`
- `## Success Criteria`
- `## Current Focus`

#### `create-progress.sh`
**Usage:** `bash .trainset/scripts/create-progress.sh`

**Creates:** `.trainset/PROGRESS.md` initialized to Phase 1 with sections:
- `## Current Phase`
- `## Phase 1 Checklist`
- `## Progress Summary`
- `## Gate Check`
- `## Notes`
- `## Upcoming`

---

## Utility Scripts

General-purpose scripts for working with workflows:

### `list-phases.sh`
List all workflow phases with their status.

**Usage:** `bash .trainset/scripts/list-phases.sh`

**Output:**
```json
{
  "success": true,
  "phases": [
    {"number": 1, "title": "Design", "status": "active"},
    {"number": 2, "title": "Implement", "status": "pending"}
  ],
  "current_phase": 1
}
```

---

### `get-section.sh`
Extract specific section from markdown files.

**Usage:** `bash .trainset/scripts/get-section.sh <file> <section-heading>`

**Example:**
```bash
bash .trainset/scripts/get-section.sh .trainset/WORKFLOW.md "Phase 2"
```

**Output:** Section content (markdown)

---

### `validate-structure.sh`
Validate that workflow files have required sections.

**Usage:** `bash .trainset/scripts/validate-structure.sh`

**Output:**
```json
{
  "success": true,
  "valid": true,
  "errors": [],
  "warnings": ["CONTEXT.md missing recommended section: ## Success Criteria"]
}
```

---

### `update-progress.sh`
Mark checklist items as complete or incomplete.

**Usage:** `bash .trainset/scripts/update-progress.sh <item-text> <status>`

**Example:**
```bash
bash .trainset/scripts/update-progress.sh "Create template library" complete
```

**Output:**
```json
{
  "success": true,
  "message": "Item 'Create template library' marked complete",
  "backup": ".trainset/PROGRESS.md.bak"
}
```

---

## JSON Schema Standards

All scripts output JSON with consistent structure:

**Success:**
```json
{
  "success": true,
  // ... script-specific data
}
```

**Error:**
```json
{
  "success": false,
  "error": "Error message"
}
```

---

## Error Handling

All scripts:
- Exit with code 0 on success
- Exit with code 1 on error
- Output JSON errors to stderr
- Handle missing files gracefully
- Validate inputs before processing
- Create backups before modifications (where applicable)

---

## Environment Variables

**`TRAINSET_DIR`** - Override default `.trainset` directory:
```bash
TRAINSET_DIR=/custom/path bash scripts/status.sh
```

---

## Integration with Commands

Slash commands (`.trainset/starter/commands/system/*.md`) are updated to:

1. **Try bash helper first** (Option A - Recommended)
2. **Fall back to manual** (Option B - if bash unavailable)

**Example from status.md:**
```markdown
## Usage

### Option A: Bash Helper (Recommended)
bash .trainset/scripts/status.sh

Parse JSON and format for user.

### Option B: Manual Read (Fallback)
Read PROGRESS.md directly if bash unavailable.
```

---

## Benefits

✅ **Token efficient** - Extract only needed data  
✅ **Deterministic** - Bash parsing vs LLM interpretation  
✅ **Fast** - No LLM processing for extraction  
✅ **Standardized** - Consistent JSON schemas  
✅ **Optional** - Fall back to manual if needed  
✅ **1-to-1 mapping** - Each script clearly maps to a command or utility

---

## Dependencies

- bash 4.0+
- Standard Unix tools: `grep`, `sed`, `awk`
- Optional: `jq` (gracefully degrades without it)
- Optional: `bc` (for percentage calculations)

---

## Testing

Test in a new project:
```bash
# Copy scripts to your project
cp -r ~/Code/trainset/.trainset/starter/scripts .trainset/

# Test status extraction
bash .trainset/scripts/status.sh

# Test gate validation
bash .trainset/scripts/validate-gate.sh

# Test advancement (gate must be ready)
bash .trainset/scripts/advance-phase.sh

# Test context extraction
bash .trainset/scripts/extract-context.sh
```

---

## Design Rationale

**Why flat structure?**
- Simple mental model (11 scripts, one directory)
- Clear mapping to commands
- Easy to find and modify
- No nested navigation

**Why JSON output?**
- Standardized parsing for LLMs
- Type-safe data structures
- Composable with other tools
- Clear success/failure

**Why optional?**
- Works without bash in restricted environments
- Users can choose manual control
- Backward compatible
- Graceful degradation

---

## Relationship to Trainset Full

These bash helpers are **Trainset Lite only**:
- **Lite:** Manual tracking, bash helpers optional
- **Full:** Python CLI automation, TOML state, bash gates required

The patterns here inform Full's design but are implemented differently.
