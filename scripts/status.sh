#!/bin/bash
# Extract current phase and progress from PROGRESS.md
# Output: JSON with status information

set -euo pipefail

PROGRESS_FILE="${TRAINSET_DIR:-.trainset}/PROGRESS.md"

# Check if PROGRESS.md exists
if [ ! -f "$PROGRESS_FILE" ]; then
  echo '{"error": "PROGRESS.md not found", "success": false}' >&2
  exit 1
fi

# Extract current phase (line starting with "## Current Phase:")
current_phase=$(grep "^## Current Phase:" "$PROGRESS_FILE" 2>/dev/null | head -1 | sed 's/## Current Phase: //' || echo "Unknown")

# Extract phase number if present
phase_number=$(echo "$current_phase" | grep -o "Phase [0-9]\+" | grep -o "[0-9]\+" || echo "0")

# Count completed items (lines with [x] or ✅)
completed=$(grep -c "- \[x\]" "$PROGRESS_FILE" 2>/dev/null || echo "0")

# Count remaining items (lines with [ ] or ⏳ or ❌)
remaining=$(grep -c "- \[ \]" "$PROGRESS_FILE" 2>/dev/null || echo "0")

# Calculate total
total=$((completed + remaining))

# Determine gate readiness
gate_ready="false"
if [ "$remaining" -eq 0 ] && [ "$total" -gt 0 ]; then
  gate_ready="true"
fi

# Extract purpose if present
purpose=$(grep "^\*\*Purpose:\*\*" "$PROGRESS_FILE" 2>/dev/null | head -1 | sed 's/\*\*Purpose:\*\* //' || echo "")

# Output JSON
cat <<EOF
{
  "success": true,
  "current_phase": "$current_phase",
  "phase_number": $phase_number,
  "purpose": "$purpose",
  "completed": $completed,
  "remaining": $remaining,
  "total": $total,
  "gate_ready": $gate_ready,
  "progress_percent": $([ "$total" -gt 0 ] && echo "scale=2; ($completed / $total) * 100" | bc || echo "0")
}
EOF
