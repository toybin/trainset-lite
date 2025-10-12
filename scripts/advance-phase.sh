#!/usr/bin/env bash
# Advance to the next phase after validating current phase gates
# Updates active story's story.yaml with new phase information
# Requires: yq (https://github.com/mikefarah/yq)

set -euo pipefail

TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
HIERARCHY_FILE="$TRAINSET_DIR/hierarchy.yaml"
ACTIVE_FILE="$TRAINSET_DIR/active.yaml"

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

# Get current phase
current_phase_id=$(yq '.progress.current_phase' "$STORY_FILE")
current_phase_order=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .order" "$WORKFLOW_FILE")
current_phase_name=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .name" "$WORKFLOW_FILE")

# Validate gates are passed
gates=$(yq ".phase[] | select(.id == \"$current_phase_id\") | .gates[]" "$WORKFLOW_FILE")

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

# Check if ready to advance
if [[ $remaining -gt 0 ]]; then
    echo "{\"success\": false, \"gate_ready\": false, \"completed\": $completed, \"remaining\": $remaining, \"total\": $total, \"message\": \"Gate not ready: $remaining of $total gate(s) remaining\"}"
    exit 1
fi

# Find next phase
next_phase_order=$((current_phase_order + 1))
next_phase_id=$(yq ".phase[] | select(.order == $next_phase_order) | .id" "$WORKFLOW_FILE")

# Check if there is a next phase
if [[ -z "$next_phase_id" ]] || [[ "$next_phase_id" == "null" ]]; then
    # Mark story as completed
    yq -i ".metadata.status = \"completed\"" "$STORY_FILE"
    yq -i ".metadata.updated = \"$(date +%Y-%m-%d)\"" "$STORY_FILE"

    echo "{\"success\": true, \"final_phase\": true, \"story_completed\": true, \"message\": \"Congratulations! Story '$ACTIVE_STORY' is complete. All phases finished.\"}"
    exit 0
fi

# Get next phase details
next_phase_name=$(yq ".phase[] | select(.id == \"$next_phase_id\") | .name" "$WORKFLOW_FILE")
next_phase_purpose=$(yq ".phase[] | select(.id == \"$next_phase_id\") | .purpose" "$WORKFLOW_FILE")

# Backup story file
BACKUP_FILE="${STORY_FILE}.bak"
cp "$STORY_FILE" "$BACKUP_FILE"

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Update story file with new phase
yq -i ".progress.current_phase = \"$next_phase_id\"" "$STORY_FILE"
yq -i ".progress.phase_started = \"$CURRENT_DATE\"" "$STORY_FILE"
yq -i ".progress.phases_complete += [\"$current_phase_id\"]" "$STORY_FILE"
yq -i ".metadata.updated = \"$CURRENT_DATE\"" "$STORY_FILE"

# Update status to in_progress if not already
current_status=$(yq '.metadata.status' "$STORY_FILE")
if [[ "$current_status" == "not_started" ]]; then
    yq -i ".metadata.status = \"in_progress\"" "$STORY_FILE"
fi

# Update stats
phases_completed=$(yq '.progress.phases_complete | length' "$STORY_FILE")
gates_passed=$(yq '[.gate_status[] | select(. == true)] | length' "$STORY_FILE")
total_gates=$(yq '.stats.total_gates' "$STORY_FILE")
total_phases=$(yq '.stats.total_phases' "$STORY_FILE")

yq -i ".stats.phases_completed = $phases_completed" "$STORY_FILE"
yq -i ".stats.gates_passed = $gates_passed" "$STORY_FILE"

# Calculate completion percentage
completion_percentage=0
if [[ $total_phases -gt 0 ]]; then
    completion_percentage=$(echo "scale=1; ($phases_completed / $total_phases) * 100" | bc)
fi
yq -i ".stats.completion_percentage = $completion_percentage" "$STORY_FILE"

# Add session entry
yq -i ".sessions += [{\"date\": \"$CURRENT_DATE\", \"phase\": \"$next_phase_id\", \"work_summary\": \"Advanced from $current_phase_name to $next_phase_name\", \"gates_completed\": [], \"notes\": \"Phase $current_phase_order complete\"}]" "$STORY_FILE"

echo "{\"success\": true, \"previous_phase\": \"$current_phase_id\", \"previous_phase_order\": $current_phase_order, \"current_phase\": \"$next_phase_id\", \"current_phase_order\": $next_phase_order, \"phase_name\": \"$next_phase_name\", \"phase_purpose\": \"$next_phase_purpose\", \"backup\": \"$BACKUP_FILE\", \"message\": \"Advanced to Phase $next_phase_order: $next_phase_name\"}"
