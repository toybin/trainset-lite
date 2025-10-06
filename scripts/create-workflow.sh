#!/usr/bin/env bash
set -euo pipefail

TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
OUTPUT_FILE="${1:-$TRAINSET_DIR/WORKFLOW.md}"

if [[ -f "$OUTPUT_FILE" ]]; then
    echo "{\"success\": false, \"error\": \"WORKFLOW.md already exists at $OUTPUT_FILE\"}" >&2
    exit 1
fi

cat > "$OUTPUT_FILE" << 'EOF'
# Workflow: [FILL IN: Workflow Name]

## Principles

[FILL IN: Brief description of what this workflow is for and what it optimizes for]

**What it optimizes for:**
- [FILL IN: Key optimization 1]
- [FILL IN: Key optimization 2]
- [FILL IN: Key optimization 3]

**When to use:**
- [FILL IN: Scenario 1]
- [FILL IN: Scenario 2]
- [FILL IN: Scenario 3]

**Trade-offs:**
- [FILL IN: Trade-off 1]
- [FILL IN: Trade-off 2]
- [FILL IN: Trade-off 3]

---

## Phases

### Phase 1: [FILL IN: Phase Name]

**Purpose:** [FILL IN: What this phase accomplishes]

**Inputs:**
- [FILL IN: Input 1]
- [FILL IN: Input 2]

**Outputs:**
- [FILL IN: Output 1]
- [FILL IN: Output 2]

**Process:**
1. [FILL IN: Step 1]
2. [FILL IN: Step 2]
3. [FILL IN: Step 3]

**Gate:**
- [ ] [FILL IN: Gate criterion 1]
- [ ] [FILL IN: Gate criterion 2]
- [ ] [FILL IN: Gate criterion 3]

**Ready to advance when:** [FILL IN: Clear completion signal]

---

### Phase 2: [FILL IN: Phase Name]

**Purpose:** [FILL IN: What this phase accomplishes]

**Inputs:**
- [FILL IN: Input 1]
- [FILL IN: Input 2]

**Outputs:**
- [FILL IN: Output 1]
- [FILL IN: Output 2]

**Process:**
1. [FILL IN: Step 1]
2. [FILL IN: Step 2]
3. [FILL IN: Step 3]

**Gate:**
- [ ] [FILL IN: Gate criterion 1]
- [ ] [FILL IN: Gate criterion 2]
- [ ] [FILL IN: Gate criterion 3]

**Ready to advance when:** [FILL IN: Clear completion signal]

---

[FILL IN: Add additional phases as needed - typically 4-6 phases total]

---

## Commands

[FILL IN: Project-specific commands for testing, building, running, etc.]

**Example:**
- **Test:** `[FILL IN: test command]`
- **Lint:** `[FILL IN: lint command]`
- **Build:** `[FILL IN: build command]`
- **Run:** `[FILL IN: run command]`

---

## Adaptation Notes

[FILL IN: Guidance on how to adapt this workflow for different scenarios]

**Key characteristics:**
- [FILL IN: Characteristic 1]
- [FILL IN: Characteristic 2]

**Critical rules:**
- [FILL IN: Rule 1]
- [FILL IN: Rule 2]

**Success criteria:**
- [FILL IN: Success criterion 1]
- [FILL IN: Success criterion 2]
EOF

echo "{\"success\": true, \"file\": \"$OUTPUT_FILE\", \"message\": \"WORKFLOW.md scaffold created successfully\"}"
