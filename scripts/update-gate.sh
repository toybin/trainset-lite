#!/usr/bin/env bash
# Update gate status in active story's story.yaml
# Usage: update-gate.sh <gate_id> <true|false>
# Requires: yq (https://github.com/mikefarah/yq)

set -euo pipefail

TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
HIERARCHY_FILE="$TRAINSET_DIR/hierarchy.yaml"
ACTIVE_FILE="$TRAINSET_DIR/active.yaml"

# Check arguments
if [[ $# -lt 2 ]]; then
    echo '{"success": false, "error": "Usage: update-gate.sh <gate_id> <true|false>"}' >&2
    exit 1
fi

GATE_ID="$1"
GATE_STATUS="$2"

# Validate gate status value
if [[ "$GATE_STATUS" != "true" && "$GATE_STATUS" != "false" ]]; then
    echo "{\"success\": false, \"error\": \"Gate status must be 'true' or 'false', got: $GATE_STATUS\"}" >&2
    exit 1
fi

# Check if files exist
if [[ ! -f "$HIERARCHY_FILE" ]]; then
    echo '{"success": false, "error": "hierarchy.yaml not found - run /setup first"}' >&2
    exit 1
fi

if [[ ! -f "$ACTIVE_FILE" ]]; then
    echo '{"success": false, "error": "No active story. Create one with /new-story"}' >&2
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
if [[ ! -f "$STORY_FILE" ]]; then
    echo "{\"success\": false, \"error\": \"Active story not found: $STORY_FILE\"}" >&2
    exit 1
fi

# Get workflow file
workflow_id=$(yq '.workflow' "$STORY_FILE")
WORKFLOW_FILE="$TRAINSET_DIR/workflows/${workflow_id}.yaml"

if [[ ! -f "$WORKFLOW_FILE" ]]; then
    echo "{\"success\": false, \"error\": \"Workflow not found: $WORKFLOW_FILE\"}" >&2
    exit 1
fi

# Verify gate exists in workflow
gate_exists=$(yq ".gates.$GATE_ID" "$WORKFLOW_FILE")
if [[ "$gate_exists" == "null" ]]; then
    echo "{\"success\": false, \"error\": \"Gate '$GATE_ID' not found in workflow\"}" >&2
    exit 1
fi

# Get gate description
gate_description=$(yq ".gates.$GATE_ID.description" "$WORKFLOW_FILE")
gate_phase=$(yq ".gates.$GATE_ID.phase" "$WORKFLOW_FILE")

# Get previous status
previous_status=$(yq ".gate_status.$GATE_ID" "$STORY_FILE")

# Update gate status
yq -i ".gate_status.$GATE_ID = $GATE_STATUS" "$STORY_FILE"

# Update timestamp
CURRENT_DATE=$(date +%Y-%m-%d)
yq -i ".metadata.updated = \"$CURRENT_DATE\"" "$STORY_FILE"

# Recalculate stats
gates_passed=$(yq '[.gate_status[] | select(. == true)] | length' "$STORY_FILE")
total_gates=$(yq '.stats.total_gates' "$STORY_FILE")

yq -i ".stats.gates_passed = $gates_passed" "$STORY_FILE"

# Update current phase progress if this gate belongs to current phase
current_phase_id=$(yq '.progress.current_phase' "$STORY_FILE")
if [[ "$gate_phase" == "$current_phase_id" ]]; then
    # Count gates for current phase
    phase_gates=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .gates[]" "$WORKFLOW_FILE")

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
    done <<< "$phase_gates"
fi

# Update completion percentage
phases_completed=$(yq '.stats.phases_completed' "$STORY_FILE")
total_phases=$(yq '.stats.total_phases' "$STORY_FILE")
if [[ $total_phases -gt 0 ]]; then
    completion_percentage=$(echo "scale=1; ($phases_completed / $total_phases) * 100" | bc)
    yq -i ".stats.completion_percentage = $completion_percentage" "$STORY_FILE"
fi

# Output result
cat <<EOF
{
  "success": true,
  "gate_id": "$GATE_ID",
  "description": "$gate_description",
  "phase": "$gate_phase",
  "previous_status": $previous_status,
  "new_status": $GATE_STATUS,
  "total_gates_passed": $gates_passed,
  "total_gates": $total_gates,
  "message": "Gate '$GATE_ID' updated to $GATE_STATUS"
}
EOF
