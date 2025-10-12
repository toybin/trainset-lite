#!/bin/bash
# Extract current phase and progress from active story
# Output: JSON with status information
# Requires: yq (https://github.com/mikefarah/yq)

set -euo pipefail

TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
HIERARCHY_FILE="$TRAINSET_DIR/hierarchy.yaml"
ACTIVE_FILE="$TRAINSET_DIR/active.yaml"

# Check if required files exist
if [ ! -f "$HIERARCHY_FILE" ]; then
  echo '{"error": "hierarchy.yaml not found - run /setup first", "success": false}' >&2
  exit 1
fi

if [ ! -f "$ACTIVE_FILE" ]; then
  echo '{"error": "No active story. Create one with /new-story", "success": false}' >&2
  exit 1
fi

# Check if yq is installed
if ! command -v yq &> /dev/null; then
  echo '{"error": "yq not found - install from https://github.com/mikefarah/yq", "success": false}' >&2
  exit 1
fi

# Get active story
ACTIVE_STORY=$(yq '.active_story' "$ACTIVE_FILE")
TERMINOLOGY_DIRECTORY=$(yq '.terminology.directory' "$HIERARCHY_FILE")
STORY_DIR="$TRAINSET_DIR/$TERMINOLOGY_DIRECTORY"
STORY_FILE="$STORY_DIR/$ACTIVE_STORY/story.yaml"

# Check if story exists
if [ ! -f "$STORY_FILE" ]; then
  echo "{\"error\": \"Active story not found: $STORY_FILE\", \"success\": false}" >&2
  exit 1
fi

# Read story metadata
story_id=$(yq '.metadata.id' "$STORY_FILE")
story_title=$(yq '.metadata.title' "$STORY_FILE")
story_status=$(yq '.metadata.status' "$STORY_FILE")
workflow_id=$(yq '.workflow' "$STORY_FILE")

# Get workflow file
WORKFLOW_FILE="$TRAINSET_DIR/workflows/${workflow_id}.yaml"
if [ ! -f "$WORKFLOW_FILE" ]; then
  echo "{\"error\": \"Workflow not found: $WORKFLOW_FILE\", \"success\": false}" >&2
  exit 1
fi

# Extract current phase from story
current_phase_id=$(yq '.progress.current_phase' "$STORY_FILE")
current_phase_started=$(yq '.progress.phase_started' "$STORY_FILE")

# Get phase details from workflow
phase_name=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .name" "$WORKFLOW_FILE")
phase_order=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .order" "$WORKFLOW_FILE")
phase_purpose=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .purpose" "$WORKFLOW_FILE")

# Get gates for current phase
gates=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .gates[]" "$WORKFLOW_FILE")

# Count gates passed vs total
completed=0
total=0

while IFS= read -r gate; do
  if [ -n "$gate" ]; then
    total=$((total + 1))
    status=$(yq ".gate_status.$gate" "$STORY_FILE")
    if [ "$status" = "true" ]; then
      completed=$((completed + 1))
    fi
  fi
done <<< "$gates"

remaining=$((total - completed))

# Determine gate readiness
gate_ready="false"
if [ "$remaining" -eq 0 ] && [ "$total" -gt 0 ]; then
  gate_ready="true"
fi

# Calculate progress percentage
progress_percent=0
if [ "$total" -gt 0 ]; then
  progress_percent=$(echo "scale=2; ($completed / $total) * 100" | bc)
fi

# Get overall stats
total_phases=$(yq '.stats.total_phases' "$STORY_FILE")
phases_completed=$(yq '.stats.phases_completed' "$STORY_FILE")
total_gates=$(yq '.stats.total_gates' "$STORY_FILE")
gates_passed=$(yq '.stats.gates_passed' "$STORY_FILE")
completion_percentage=$(yq '.stats.completion_percentage' "$STORY_FILE")

# Output JSON
cat <<EOF
{
  "success": true,
  "story": {
    "id": "$story_id",
    "slug": "$ACTIVE_STORY",
    "title": "$story_title",
    "status": "$story_status",
    "workflow": "$workflow_id"
  },
  "current_phase_id": "$current_phase_id",
  "current_phase_name": "$phase_name",
  "phase_number": $phase_order,
  "phase_started": "$current_phase_started",
  "purpose": "$phase_purpose",
  "completed": $completed,
  "remaining": $remaining,
  "total": $total,
  "gate_ready": $gate_ready,
  "progress_percent": $progress_percent,
  "overall": {
    "total_phases": $total_phases,
    "phases_completed": $phases_completed,
    "total_gates": $total_gates,
    "gates_passed": $gates_passed,
    "completion_percentage": $completion_percentage
  }
}
EOF
