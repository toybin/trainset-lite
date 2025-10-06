#!/usr/bin/env bash
set -euo pipefail

TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
PROGRESS_FILE="$TRAINSET_DIR/PROGRESS.md"
WORKFLOW_FILE="$TRAINSET_DIR/WORKFLOW.md"

if [[ ! -f "$PROGRESS_FILE" ]]; then
    echo "{\"success\": false, \"error\": \"PROGRESS.md not found. Run /setup first.\"}" >&2
    exit 1
fi

if [[ ! -f "$WORKFLOW_FILE" ]]; then
    echo "{\"success\": false, \"error\": \"WORKFLOW.md not found. Run /setup first.\"}" >&2
    exit 1
fi

CURRENT_PHASE=$(grep -m 1 "^## Current Phase:" "$PROGRESS_FILE" | sed 's/^## Current Phase: Phase \([0-9]*\).*/\1/' || echo "")

if [[ -z "$CURRENT_PHASE" ]]; then
    echo "{\"success\": false, \"error\": \"Could not determine current phase from PROGRESS.md\"}" >&2
    exit 1
fi

COMPLETED=$(grep -c "^- \[x\]" "$PROGRESS_FILE" 2>/dev/null || echo "0")
REMAINING=$(grep -c "^- \[ \]" "$PROGRESS_FILE" 2>/dev/null || echo "0")
COMPLETED=${COMPLETED//[^0-9]/}
REMAINING=${REMAINING//[^0-9]/}
TOTAL=$((COMPLETED + REMAINING))

if [[ $REMAINING -gt 0 ]]; then
    echo "{\"success\": false, \"gate_ready\": false, \"completed\": $COMPLETED, \"remaining\": $REMAINING, \"total\": $TOTAL, \"message\": \"Gate not ready: $REMAINING of $TOTAL items remaining\"}"
    exit 1
fi

NEXT_PHASE=$((CURRENT_PHASE + 1))

NEXT_PHASE_TITLE=$(grep "^### Phase $NEXT_PHASE:" "$WORKFLOW_FILE" | sed 's/^### Phase [0-9]*: //' || echo "")

if [[ -z "$NEXT_PHASE_TITLE" ]]; then
    echo "{\"success\": false, \"final_phase\": true, \"message\": \"Congratulations! You've completed the final phase. No more phases to advance to.\"}"
    exit 0
fi

NEXT_PHASE_PURPOSE=$(awk "/^### Phase $NEXT_PHASE:/,/^### Phase [0-9]*:/" "$WORKFLOW_FILE" | grep "^\*\*Purpose:\*\*" | sed 's/^\*\*Purpose:\*\* //' || echo "")

NEXT_PHASE_GATE=$(awk "/^### Phase $NEXT_PHASE:/,/^### Phase [0-9]*:/" "$WORKFLOW_FILE" | sed -n '/^\*\*Gate:\*\*/,/^\*\*Ready to advance/p' | grep "^- \[ \]" || echo "")

BACKUP_FILE="${PROGRESS_FILE}.bak"
cp "$PROGRESS_FILE" "$BACKUP_FILE"

CURRENT_DATE=$(date +%Y-%m-%d)

cat > "$PROGRESS_FILE" << EOF
# Progress: $(grep "^# Progress:" "$BACKUP_FILE" | sed 's/^# Progress: //')

## Current Phase: Phase $NEXT_PHASE - $NEXT_PHASE_TITLE

**Started:** $CURRENT_DATE
**Purpose:** $NEXT_PHASE_PURPOSE

---

## Phase $NEXT_PHASE Checklist

$NEXT_PHASE_GATE

---

## Progress Summary

**Completed:**
- Phase $CURRENT_PHASE completed on $CURRENT_DATE

**In Progress:**
- Phase $NEXT_PHASE started on $CURRENT_DATE

**Not Started:**
- Upcoming phases

---

## Gate Check: Not Ready ❌

**Status:** 0/$(echo "$NEXT_PHASE_GATE" | wc -l | tr -d ' ') items complete

**Needs:**
- All Phase $NEXT_PHASE checklist items

---

## Notes

### Recent Progress
- $CURRENT_DATE: Advanced to Phase $NEXT_PHASE

EOF

REMAINING_PHASES=$(grep "^### Phase [0-9]*:" "$WORKFLOW_FILE" | tail -n +$((NEXT_PHASE + 1)) || echo "")

if [[ -n "$REMAINING_PHASES" ]]; then
    echo "" >> "$PROGRESS_FILE"
    echo "## Upcoming" >> "$PROGRESS_FILE"
    echo "" >> "$PROGRESS_FILE"
    echo "$REMAINING_PHASES" | while read -r line; do
        echo "**$line**" >> "$PROGRESS_FILE"
    done
fi

echo "{\"success\": true, \"previous_phase\": $CURRENT_PHASE, \"current_phase\": $NEXT_PHASE, \"phase_title\": \"$NEXT_PHASE_TITLE\", \"phase_purpose\": \"$NEXT_PHASE_PURPOSE\", \"backup\": \"$BACKUP_FILE\", \"message\": \"Advanced to Phase $NEXT_PHASE: $NEXT_PHASE_TITLE\"}"
