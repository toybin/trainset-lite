#!/usr/bin/env bash
# Initialize Trainset Lite workflow files
# Creates workflow.yaml, state.yaml, WORKFLOW.md, CONTEXT.md, and INTERVIEW.md scaffolds
# Requires: yq (https://github.com/mikefarah/yq)

set -euo pipefail

TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo '{"error": "yq not found - install from https://github.com/mikefarah/yq", "success": false}' >&2
    exit 1
fi

# Check if workflow files already exist
if [[ -f "$TRAINSET_DIR/workflow.yaml" ]] || [[ -f "$TRAINSET_DIR/state.yaml" ]]; then
    echo '{"success": false, "error": "Workflow files already exist. Remove them first if you want to reinitialize."}' >&2
    exit 1
fi

CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Create workflow.yaml scaffold
cat > "$TRAINSET_DIR/workflow.yaml" << 'EOF'
# workflow.yaml - Project Workflow Definition
# Define phases, gates, and commands for your project

metadata:
  name: "[FILL IN: Project Name]"
  description: "[FILL IN: Brief project description]"
  created: "[FILL IN: Creation date]"
  workflow_type: "custom"  # custom, learning, feature, refactor, etc.

commands:
  test: "[FILL IN: test command, e.g., npm test, go test ./...]"
  lint: "[FILL IN: lint command]"
  build: "[FILL IN: build command]"
  run: "[FILL IN: run command]"

# Define your phases - typically 3-6 phases
phase:
  - id: "phase_1"
    name: "[FILL IN: Phase 1 Name]"
    order: 1
    purpose: "[FILL IN: What this phase accomplishes]"
    gates:
      - "gate_1"
      - "gate_2"
      - "gate_3"

  - id: "phase_2"
    name: "[FILL IN: Phase 2 Name]"
    order: 2
    purpose: "[FILL IN: What this phase accomplishes]"
    gates:
      - "gate_4"
      - "gate_5"

# Add more phases as needed...

# Define gate criteria for each phase
gates:
  gate_1:
    description: "[FILL IN: What this gate validates]"
    phase: "phase_1"
    validation_hint: "[FILL IN: How to verify this gate]"

  gate_2:
    description: "[FILL IN: What this gate validates]"
    phase: "phase_1"
    validation_hint: "[FILL IN: How to verify this gate]"

  gate_3:
    description: "[FILL IN: What this gate validates]"
    phase: "phase_1"
    validation_hint: "[FILL IN: How to verify this gate]"

  gate_4:
    description: "[FILL IN: What this gate validates]"
    phase: "phase_2"
    validation_hint: "[FILL IN: How to verify this gate]"

  gate_5:
    description: "[FILL IN: What this gate validates]"
    phase: "phase_2"
    validation_hint: "[FILL IN: How to verify this gate]"

# Add more gates as needed...

principles:
  incremental: true
  validation_driven: true

quality:
  test_coverage_min: 80
  documentation_required: true
EOF

# Calculate total phases and gates (will be filled in by AI during setup)
TOTAL_PHASES=2
TOTAL_GATES=5

# Create state.yaml scaffold
cat > "$TRAINSET_DIR/state.yaml" << EOF
# state.yaml - Project Progress State
# Tracks current progress through the workflow

metadata:
  last_updated: "$CURRENT_TIMESTAMP"
  workflow_version: "1.0"

progress:
  current_phase: "phase_1"
  started_date: "$CURRENT_DATE"
  phases_complete: []
  current_phase_started: "$CURRENT_DATE"
  current_phase_progress: "0/3"

gate_status:
  gate_1: false
  gate_2: false
  gate_3: false
  gate_4: false
  gate_5: false

milestones:
  setup_complete: false
  core_functionality_complete: false
  testing_complete: false
  documentation_complete: false

stats:
  total_phases: $TOTAL_PHASES
  phases_completed: 0
  total_gates: $TOTAL_GATES
  gates_passed: 0
  completion_percentage: 0

session:
  - date: "$CURRENT_DATE"
    phase: "phase_1"
    work_summary: "Initial workflow setup"
    gates_completed: []
    notes: "Starting project workflow"
EOF

# Create WORKFLOW.md for human-readable context
cat > "$TRAINSET_DIR/WORKFLOW.md" << 'EOF'
# Workflow: [FILL IN: Workflow Name]

A narrative explanation of the workflow defined in workflow.yaml.

## Philosophy

[FILL IN: What is this workflow optimized for? When should it be used?]

**Optimizes for:**
- [FILL IN: Key optimization 1]
- [FILL IN: Key optimization 2]

**When to use:**
- [FILL IN: Scenario 1]
- [FILL IN: Scenario 2]

**Trade-offs:**
- [FILL IN: What this approach sacrifices]

---

## Phase 1: [FILL IN: Phase Name]

**Purpose:** [FILL IN: Detailed explanation of what this phase accomplishes]

[FILL IN: Narrative description of this phase - what you'll build, what concepts you'll learn, what challenges you might face]

**Gates explained:**

1. **[Gate 1 name]** - [FILL IN: Explain what this gate means, why it matters, how to verify it]

2. **[Gate 2 name]** - [FILL IN: Explain what this gate means, why it matters, how to verify it]

3. **[Gate 3 name]** - [FILL IN: Explain what this gate means, why it matters, how to verify it]

**Common pitfalls:**
- [FILL IN: Common mistake 1]
- [FILL IN: Common mistake 2]

**Resources:**
- [FILL IN: Helpful links, docs, tutorials]

---

## Phase 2: [FILL IN: Phase Name]

[FILL IN: Same structure as Phase 1]

---

[FILL IN: Continue for all phases]

## Commands Reference

**Test:** `[command from workflow.yaml]`
[FILL IN: Explain what this command does, when to use it]

**Lint:** `[command from workflow.yaml]`
[FILL IN: Explain what this command does, when to use it]

**Build:** `[command from workflow.yaml]`
[FILL IN: Explain what this command does, when to use it]

---

## Workflow Notes

[FILL IN: Any additional context about how this workflow was adapted for your project]
EOF

# Create CONTEXT.md for project background
cat > "$TRAINSET_DIR/CONTEXT.md" << 'EOF'
# Project Context: [FILL IN: Project Name]

## Project Overview

**Name:** [FILL IN: Project name]
**Type:** [FILL IN: Development/Learning/Feature/Refactor]
**Workflow:** [FILL IN: Workflow type from workflow.yaml]

[FILL IN: 2-3 sentences explaining what this project is and why it exists]

## Technical Stack

**Primary Technologies:**
- [FILL IN: Language/framework 1]
- [FILL IN: Language/framework 2]
- [FILL IN: Key dependencies]

**Development Environment:**
- [FILL IN: Package manager]
- [FILL IN: Build tools]
- [FILL IN: Testing framework]

## Architecture

[FILL IN: High-level architectural overview]

**Key Components:**
- [FILL IN: Component 1 and its purpose]
- [FILL IN: Component 2 and its purpose]

**Design Principles:**
- [FILL IN: Principle 1]
- [FILL IN: Principle 2]

## Working Style

**Session Structure:**
- [FILL IN: Typical session length]
- [FILL IN: How you track progress]

**Quality Standards:**
- [FILL IN: Testing requirements]
- [FILL IN: Code review process]
- [FILL IN: Documentation standards]

## Success Criteria

**Primary Goals:**
1. [FILL IN: Goal 1]
2. [FILL IN: Goal 2]
3. [FILL IN: Goal 3]

**Quality Measures:**
- [FILL IN: How you'll measure success]

## Project Constraints

**Scope:**
- In scope: [FILL IN]
- Out of scope: [FILL IN]

**Timeline:**
- [FILL IN: Timeline if applicable]

[FILL IN: Add any additional context specific to your project]
EOF

# Create INTERVIEW.md to capture initial Q&A
cat > "$TRAINSET_DIR/INTERVIEW.md" << 'EOF'
# Project Interview

This file captures the initial conversation about your project to inform workflow synthesis.

## Project Basics

**Q: What are you building?**
A: [FILL IN]

**Q: What's the main goal or outcome you want?**
A: [FILL IN]

**Q: Is this for learning, production, experimentation, or something else?**
A: [FILL IN]

## Technical Context

**Q: What technologies/languages are you using?**
A: [FILL IN]

**Q: What's your experience level with these technologies?**
A: [FILL IN]

**Q: Are there specific tools or frameworks you want to use?**
A: [FILL IN]

## Scope & Constraints

**Q: What's in scope for this project?**
A: [FILL IN]

**Q: What's explicitly out of scope?**
A: [FILL IN]

**Q: Any timeline or deadline constraints?**
A: [FILL IN]

## Working Style

**Q: How do you prefer to work? (focused sprints, incremental, experimental)**
A: [FILL IN]

**Q: How long are your typical work sessions?**
A: [FILL IN]

**Q: What's your approach to testing and quality?**
A: [FILL IN]

## Success Criteria

**Q: How will you know this project is complete?**
A: [FILL IN]

**Q: What would make this project a success?**
A: [FILL IN]

**Q: What are the must-haves vs nice-to-haves?**
A: [FILL IN]

[FILL IN: Add any additional Q&A relevant to your project]
EOF

echo '{"success": true, "files": ["workflow.yaml", "state.yaml", "WORKFLOW.md", "CONTEXT.md", "INTERVIEW.md"], "message": "Workflow scaffolds created in '"$TRAINSET_DIR"'. Fill in placeholders and run /setup to synthesize custom workflow."}'
