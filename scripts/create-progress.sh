#!/usr/bin/env bash
set -euo pipefail

TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
OUTPUT_FILE="${1:-$TRAINSET_DIR/PROGRESS.md}"

if [[ -f "$OUTPUT_FILE" ]]; then
    echo "{\"success\": false, \"error\": \"PROGRESS.md already exists at $OUTPUT_FILE\"}" >&2
    exit 1
fi

CURRENT_DATE=$(date +%Y-%m-%d)

cat > "$OUTPUT_FILE" << EOF
# Progress: [FILL IN: Project Name]

## Current Phase: Phase 1 - [FILL IN: Phase 1 Name]

**Started:** $CURRENT_DATE
**Purpose:** [FILL IN: Phase 1 purpose from WORKFLOW.md]

---

## Phase 1 Checklist

[FILL IN: Copy gate checklist items from Phase 1 in WORKFLOW.md]

**Example structure:**
- [ ] [FILL IN: Gate criterion 1]
- [ ] [FILL IN: Gate criterion 2]
- [ ] [FILL IN: Gate criterion 3]
- [ ] [FILL IN: Gate criterion 4]

---

## Progress Summary

**Completed:**
- [FILL IN: List completed items or milestones]

**In Progress:**
- [FILL IN: Currently active work items]

**Not Started:**
- [FILL IN: Planned but not yet started items]

---

## Gate Check: Not Ready ❌

**Status:** 0/[FILL IN: total] items complete

**Needs:**
1. [FILL IN: What's needed to pass gate]
2. [FILL IN: What's needed to pass gate]
3. [FILL IN: What's needed to pass gate]

**Estimated:** [FILL IN: Time estimate to complete phase]

---

## Notes

[FILL IN: Add session notes, decisions, blockers, or other relevant information]

### Recent Progress
- $CURRENT_DATE: Phase 1 started

### Decisions
- [FILL IN: Key decisions made during this phase]

### Blockers
- [FILL IN: Current blockers or challenges]

---

## Upcoming

**Phase 2:** [FILL IN: Phase 2 name and brief description]
**Phase 3:** [FILL IN: Phase 3 name and brief description]

[FILL IN: List remaining phases]
EOF

echo "{\"success\": true, \"file\": \"$OUTPUT_FILE\", \"message\": \"PROGRESS.md scaffold created successfully\"}"
