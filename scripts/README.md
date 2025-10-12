# Trainset Lite Bash Helper Scripts

These bash scripts provide reliable automation for Trainset Lite workflows using **yq** to query YAML files. They map to slash commands and output standardized JSON.

## Overview

**Location:** `.trainset/scripts/` (when copied to a new project)

**Philosophy:** Use yq to query YAML files for state and structure, avoiding fragile grep/sed/awk parsing.

**Dependencies:**
- bash 4.0+
- **yq** (required) - Install from https://github.com/mikefarah/yq
- bc (for percentage calculations)

---

## Architecture: Story-Level Tracking with YAML + yq

All scripts query YAML files using yq. The system uses a **workflow-as-template** model:

**Project Configuration:**
- `hierarchy.yaml` - Project type and terminology (story/task/lesson)
- `active.yaml` - Points to currently active story

**Workflow Templates** (in `workflows/` directory):
- `feature-workflow.yaml` - Reusable workflow definitions
- `bugfix-workflow.yaml` - Different workflows for different work types
- Each defines phases, gates, and commands

**Stories** (in `stories/` or `tasks/` directory):
- `001-user-auth/story.yaml` - Individual story state tracking
- `002-api-docs/story.yaml` - Each story references a workflow
- Tracks progress through workflow phases independently

**yq Queries:**
```bash
# Get active story
yq '.active_story' active.yaml

# Get current phase from active story
yq '.progress.current_phase' stories/001-user-auth/story.yaml

# Check gate status for active story
yq '.gate_status.gate_id' stories/001-user-auth/story.yaml

# Get phase details from workflow template
yq '.phase[] | select(.id == "phase_1") | .name' workflows/feature-workflow.yaml
```

**Benefits:**
- ✅ Multiple work items (stories/tasks/lessons) per project
- ✅ Different workflows for different types of work
- ✅ Adaptable terminology for your domain
- ✅ No grep parsing bugs - clean yq queries
- ✅ Same structure as Trainset Full for easy migration

---

## Story Management Scripts

Scripts for creating and managing multiple work items:

### `/new-story` → `new-story.sh`
Create a new story/task/lesson with a specific workflow.

**Usage:** `bash .trainset/scripts/new-story.sh "Story Title" [--workflow workflow-id]`

**Examples:**
```bash
# Use default workflow
bash .trainset/scripts/new-story.sh "User Authentication"

# Use specific workflow
bash .trainset/scripts/new-story.sh "Fix Login Bug" --workflow bugfix-workflow

# Generate new workflow (AI will create custom workflow)
bash .trainset/scripts/new-story.sh "API Documentation" --new-workflow
```

**Output:**
```json
{
  "success": true,
  "story_id": "001",
  "story_slug": "001-user-authentication",
  "story_title": "User Authentication",
  "workflow": "feature-workflow",
  "workflow_name": "Feature Development",
  "total_phases": 4,
  "total_gates": 20,
  "message": "Created story '001-user-authentication' using workflow 'feature-workflow'. Now active."
}
```

---

### `/list-stories` → `list-stories.sh`
List all stories with their status and progress.

**Usage:** `bash .trainset/scripts/list-stories.sh [--format json|text]`

**Output:**
```json
{
  "success": true,
  "stories": [
    {
      "id": "001",
      "slug": "001-user-auth",
      "title": "User Authentication System",
      "status": "completed",
      "workflow": "feature-workflow",
      "completion_percentage": 100,
      "is_active": false
    },
    {
      "id": "002",
      "slug": "002-api-endpoints",
      "title": "REST API Endpoints",
      "status": "in_progress",
      "workflow": "feature-workflow",
      "current_phase": "implementation",
      "completion_percentage": 45,
      "is_active": true
    }
  ],
  "count": 2,
  "active_story": "002-api-endpoints"
}
```

---

### `/switch` → `switch-story.sh`
Switch to a different story to make it active.

**Usage:** `bash .trainset/scripts/switch-story.sh <story-id-or-slug>`

**Examples:**
```bash
# Switch by ID
bash .trainset/scripts/switch-story.sh 002

# Switch by full slug
bash .trainset/scripts/switch-story.sh 002-api-endpoints
```

**Output:**
```json
{
  "success": true,
  "story_id": "002",
  "story_slug": "002-api-endpoints",
  "story_title": "REST API Endpoints",
  "status": "in_progress",
  "workflow": "feature-workflow",
  "current_phase": {
    "id": "implementation",
    "name": "Implementation",
    "order": 2
  },
  "message": "Switched to story '002-api-endpoints'"
}
```

---

## Command Scripts

These scripts operate on the currently active story:

### `/status` → `status.sh`
Extract current phase and progress information from the active story.

**Usage:** `bash .trainset/scripts/status.sh`

**How it works:**
```bash
# Get current phase from state
current_phase_id=$(yq '.progress.current_phase' state.yaml)

# Get phase details from workflow
phase_name=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .name" workflow.yaml)

# Count gates
gates=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .gates[]" workflow.yaml)
# Loop through gates and check status in state.yaml
```

**Output:**
```json
{
  "success": true,
  "current_phase_id": "setup_and_basics",
  "current_phase_name": "Project Setup & Go Basics",
  "phase_number": 1,
  "phase_started": "2025-10-11",
  "purpose": "Initialize project and understand fundamental structure",
  "completed": 3,
  "remaining": 2,
  "total": 5,
  "gate_ready": false,
  "progress_percent": 60.0,
  "overall": {
    "total_phases": 4,
    "phases_completed": 0,
    "total_gates": 19,
    "gates_passed": 3,
    "completion_percentage": 15.8
  }
}
```

---

### `/gate-check` → `validate-gate.sh`
Check if current phase gate criteria are met using YAML gate_status.

**Usage:** `bash .trainset/scripts/validate-gate.sh`

**How it works:**
```bash
# Get gates for current phase from workflow.yaml
gates=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .gates[]" workflow.yaml)

# Check each gate's status in state.yaml
for gate in $gates; do
  status=$(yq ".gate_status.$gate" state.yaml)  # true or false
done
```

**Output:**
```json
{
  "success": true,
  "gate_ready": false,
  "phase_id": "setup_and_basics",
  "phase_name": "Project Setup & Go Basics",
  "phase_number": 1,
  "completed": 3,
  "remaining": 2,
  "total": 5,
  "message": "2 of 5 gate(s) remaining",
  "failed_gates": [
    "project_builds: Can run 'go build' without errors",
    "cli_shows_help: Can execute './tasker' and see help text"
  ]
}
```

**Exit code:** 0 if gate ready, 1 if not ready

---

### `/advance` → `advance-phase.sh`
Advance to next phase by updating state.yaml.

**Usage:** `bash .trainset/scripts/advance-phase.sh`

**How it works:**
```bash
# Validate all gates pass in current phase
# Find next phase by order
next_phase_id=$(yq ".phase[] | select(.order == $next_order) | .id" workflow.yaml)

# Update state.yaml with yq -i (in-place)
yq -i ".progress.current_phase = \"$next_phase_id\"" state.yaml
yq -i ".progress.phases_complete += [\"$current_phase_id\"]" state.yaml
yq -i ".stats.phases_completed = $phases_completed" state.yaml
```

**Output (success):**
```json
{
  "success": true,
  "previous_phase": "setup_and_basics",
  "previous_phase_order": 1,
  "current_phase": "core_task_management",
  "current_phase_order": 2,
  "phase_name": "Core Task Management Logic",
  "phase_purpose": "Implement add, list, complete commands with SQLite persistence",
  "backup": ".trainset/state.yaml.bak",
  "message": "Advanced to Phase 2: Core Task Management Logic"
}
```

**Output (gate not ready):**
```json
{
  "success": false,
  "gate_ready": false,
  "completed": 3,
  "remaining": 2,
  "total": 5,
  "message": "Gate not ready: 2 of 5 gate(s) remaining"
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

### `/setup` → `init-workflow.sh`

Creates YAML + Markdown scaffold files with `[FILL IN]` placeholders.

**Usage:** `bash .trainset/scripts/init-workflow.sh`

**Creates:**
1. `.trainset/workflow.yaml` - Phase/gate definitions with placeholders
2. `.trainset/state.yaml` - Initial state (phase 1, all gates false)
3. `.trainset/WORKFLOW.md` - Narrative phase explanations
4. `.trainset/CONTEXT.md` - Project context and constraints
5. `.trainset/INTERVIEW.md` - Interview Q&A template

**Output:**
```json
{
  "success": true,
  "files": ["workflow.yaml", "state.yaml", "WORKFLOW.md", "CONTEXT.md", "INTERVIEW.md"],
  "message": "Workflow scaffolds created in .trainset. Fill in placeholders and run /setup to synthesize custom workflow."
}
```

**Next step:** AI reads INTERVIEW.md and template-library.md to synthesize a custom workflow.yaml and state.yaml.

---

## Utility Scripts

General-purpose scripts for working with YAML workflows:

### `update-gate.sh` *(NEW)*
Mark individual gates as complete or incomplete in state.yaml.

**Usage:** `bash .trainset/scripts/update-gate.sh <gate_id> <true|false>`

**How it works:**
```bash
# Update gate status in state.yaml
yq -i ".gate_status.$gate_id = $status" state.yaml

# Recalculate stats
gates_passed=$(yq '[.gate_status[] | select(. == true)] | length' state.yaml)
yq -i ".stats.gates_passed = $gates_passed" state.yaml
```

**Example:**
```bash
bash .trainset/scripts/update-gate.sh go_module_initialized true
```

**Output:**
```json
{
  "success": true,
  "gate_id": "go_module_initialized",
  "description": "Go module initialized with correct module path",
  "phase": "setup_and_basics",
  "previous_status": false,
  "new_status": true,
  "total_gates_passed": 1,
  "total_gates": 19,
  "message": "Gate 'go_module_initialized' updated to true"
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
- **yq** (required) - Install from https://github.com/mikefarah/yq
  - macOS: `brew install yq`
  - Linux: Download binary from GitHub releases
  - Verify: `yq --version`
- `bc` (for percentage calculations)

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

Both use the same YAML structure for easy migration:

**Trainset Lite:**
- YAML + Markdown files for structure and narrative
- Bash + yq scripts for automation
- Manual gate marking (user decides when gates pass)
- Lightweight, no Python dependency

**Trainset Full (Toybin):**
- Same YAML files (workflow.yaml, state.yaml, hierarchy.yaml)
- Python CLI for full automation
- Automated gate execution
- Multi-level hierarchy (Initiative > Epic > Story)
- DFS bubble-up behavior

**Migration path:** When you outgrow Lite, just add hierarchy.yaml and run Trainset Full's Python CLI - your workflow.yaml and state.yaml work as-is!
