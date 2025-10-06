#!/bin/bash
# Validate if current phase gate criteria are met
# Output: JSON with validation results

set -euo pipefail

PROGRESS_FILE="${TRAINSET_DIR:-.trainset}/PROGRESS.md"
WORKFLOW_FILE="${TRAINSET_DIR:-.trainset}/WORKFLOW.md"

# Check if files exist
if [ ! -f "$PROGRESS_FILE" ]; then
  echo '{"error": "PROGRESS.md not found", "success": false}' >&2
  exit 1
fi

if [ ! -f "$WORKFLOW_FILE" ]; then
  echo '{"error": "WORKFLOW.md not found", "success": false}' >&2
  exit 1
fi

# Extract current phase number from PROGRESS.md
current_phase=$(grep "^## Current Phase:" "$PROGRESS_FILE" 2>/dev/null | head -1 | grep -o "Phase [0-9]\+" | grep -o "[0-9]\+" || echo "0")

if [ "$current_phase" = "0" ]; then
  echo '{"error": "Could not determine current phase", "success": false}' >&2
  exit 1
fi

# Count checklist items in PROGRESS.md
completed=$(grep -c "- \[x\]" "$PROGRESS_FILE" 2>/dev/null || echo "0")
remaining=$(grep -c "- \[ \]" "$PROGRESS_FILE" 2>/dev/null || echo "0")
total=$((completed + remaining))

# Determine if gate is ready
gate_ready="false"
message="Gate criteria not met"

if [ "$remaining" -eq 0 ] && [ "$total" -gt 0 ]; then
  gate_ready="true"
  message="All gate criteria met - ready to advance"
elif [ "$total" -eq 0 ]; then
  gate_ready="\"unknown\""
  message="No checklist items found"
else
  message="$remaining of $total items remaining"
fi

# Output JSON
cat <<EOF
{
  "success": true,
  "gate_ready": $gate_ready,
  "phase_number": $current_phase,
  "completed": $completed,
  "remaining": $remaining,
  "total": $total,
  "message": "$message"
}
EOF

# Exit code reflects gate status
[ "$gate_ready" = "true" ] && exit 0 || exit 1
