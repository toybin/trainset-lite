#!/bin/bash
# Validate if current phase gate criteria are met for active story
# Output: JSON with validation results
# Requires: yq (https://github.com/mikefarah/yq)

set -euo pipefail

TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
HIERARCHY_FILE="$TRAINSET_DIR/hierarchy.yaml"
ACTIVE_FILE="$TRAINSET_DIR/active.yaml"

# Check if files exist
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

# Get workflow file
workflow_id=$(yq '.workflow' "$STORY_FILE")
WORKFLOW_FILE="$TRAINSET_DIR/workflows/${workflow_id}.yaml"

if [ ! -f "$WORKFLOW_FILE" ]; then
  echo "{\"error\": \"Workflow not found: $WORKFLOW_FILE\", \"success\": false}" >&2
  exit 1
fi

# Extract current phase from story
current_phase_id=$(yq '.progress.current_phase' "$STORY_FILE")

# Get phase details
phase_number=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .order" "$WORKFLOW_FILE")
phase_name=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .name" "$WORKFLOW_FILE")

# Get gates for current phase
gates=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .gates[]" "$WORKFLOW_FILE")

# Count gates passed vs total
completed=0
total=0
failed_gates=()

while IFS= read -r gate; do
  if [ -n "$gate" ]; then
    total=$((total + 1))
    status=$(yq ".gate_status.$gate" "$STORY_FILE")
    if [ "$status" = "true" ]; then
      completed=$((completed + 1))
    else
      failed_gates+=("$gate")
    fi
  fi
done <<< "$gates"

remaining=$((total - completed))

# Determine if gate is ready
gate_ready="false"
message="Gate criteria not met"

if [ "$remaining" -eq 0 ] && [ "$total" -gt 0 ]; then
  gate_ready="true"
  message="All gate criteria met - ready to advance to next phase"
elif [ "$total" -eq 0 ]; then
  gate_ready="unknown"
  message="No gate criteria found for this phase"
else
  message="$remaining of $total gate(s) remaining"
fi

# Build failed gates array for JSON output
failed_gates_json="["
first=true
for gate in "${failed_gates[@]}"; do
  if [ "$first" = true ]; then
    first=false
  else
    failed_gates_json+=","
  fi
  gate_desc=$(yq ".gates.$gate.description" "$WORKFLOW_FILE")
  failed_gates_json+="\"$gate: $gate_desc\""
done
failed_gates_json+="]"

# Output JSON
cat <<EOF
{
  "success": true,
  "gate_ready": $gate_ready,
  "phase_id": "$current_phase_id",
  "phase_name": "$phase_name",
  "phase_number": $phase_number,
  "completed": $completed,
  "remaining": $remaining,
  "total": $total,
  "message": "$message",
  "failed_gates": $failed_gates_json
}
EOF

# Exit code reflects gate status
[ "$gate_ready" = "true" ] && exit 0 || exit 1
