#!/bin/bash
# List all phases from WORKFLOW.md with their status
# Output: JSON array of phases

set -euo pipefail

WORKFLOW_FILE="${TRAINSET_DIR:-.trainset}/WORKFLOW.md"
PROGRESS_FILE="${TRAINSET_DIR:-.trainset}/PROGRESS.md"

if [ ! -f "$WORKFLOW_FILE" ]; then
  echo '{"error": "WORKFLOW.md not found", "success": false}' >&2
  exit 1
fi

# Extract current phase number from PROGRESS.md
current_phase=0
if [ -f "$PROGRESS_FILE" ]; then
  current_phase=$(grep "^## Current Phase:" "$PROGRESS_FILE" 2>/dev/null | head -1 | grep -o "Phase [0-9]\+" | grep -o "[0-9]\+" || echo "0")
fi

# Extract phase headings (### Phase N: Title)
phases=()
while IFS= read -r line; do
  # Extract phase number and title
  if [[ "$line" =~ ^###[[:space:]]Phase[[:space:]]([0-9]+):[[:space:]](.+)$ ]]; then
    phase_num="${BASH_REMATCH[1]}"
    phase_title="${BASH_REMATCH[2]}"
    
    # Determine status
    status="pending"
    if [ "$phase_num" -lt "$current_phase" ]; then
      status="completed"
    elif [ "$phase_num" -eq "$current_phase" ]; then
      status="active"
    fi
    
    phases+=("{\"number\": $phase_num, \"title\": \"$phase_title\", \"status\": \"$status\"}")
  fi
done < "$WORKFLOW_FILE"

# Build JSON array
if [ ${#phases[@]} -gt 0 ]; then
  phases_json=$(IFS=,; echo "${phases[*]}")
  echo "{\"success\": true, \"phases\": [$phases_json], \"current_phase\": $current_phase}"
else
  echo '{"success": true, "phases": [], "current_phase": 0, "message": "No phases found"}'
fi
