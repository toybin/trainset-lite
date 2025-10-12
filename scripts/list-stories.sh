#!/usr/bin/env bash
# list-stories.sh - List all stories with their status
# Usage: bash .trainset/scripts/list-stories.sh [--format json|text]

set -euo pipefail

# Configuration
TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
HIERARCHY_FILE="$TRAINSET_DIR/hierarchy.yaml"
ACTIVE_FILE="$TRAINSET_DIR/active.yaml"

# Default format
FORMAT="json"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --format)
      FORMAT="${2:-json}"
      shift 2
      ;;
    *)
      echo "{\"success\": false, \"error\": \"Unknown option: $1\"}" >&2
      exit 1
      ;;
  esac
done

# Helper function for JSON output
json_error() {
  echo "{\"success\": false, \"error\": \"$1\"}" >&2
  exit 1
}

# Check dependencies
command -v yq >/dev/null 2>&1 || json_error "yq is required but not installed"

# Check if hierarchy.yaml exists
[[ -f "$HIERARCHY_FILE" ]] || json_error "hierarchy.yaml not found. Run /setup first."

# Read configuration
TERMINOLOGY_SINGULAR=$(yq '.terminology.singular' "$HIERARCHY_FILE")
TERMINOLOGY_PLURAL=$(yq '.terminology.plural' "$HIERARCHY_FILE")
TERMINOLOGY_DIRECTORY=$(yq '.terminology.directory' "$HIERARCHY_FILE")
STORY_DIR="$TRAINSET_DIR/$TERMINOLOGY_DIRECTORY"

# Get active story
ACTIVE_STORY=""
if [[ -f "$ACTIVE_FILE" ]]; then
  ACTIVE_STORY=$(yq '.active_story' "$ACTIVE_FILE")
fi

# Check if stories directory exists
if [[ ! -d "$STORY_DIR" ]]; then
  echo "{\"success\": true, \"stories\": [], \"count\": 0, \"message\": \"No $TERMINOLOGY_PLURAL found. Create one with /new-$TERMINOLOGY_SINGULAR\"}"
  exit 0
fi

# Find all story directories
STORY_DIRS=$(find "$STORY_DIR" -maxdepth 1 -type d -name "[0-9]*" | sort)

if [[ -z "$STORY_DIRS" ]]; then
  echo "{\"success\": true, \"stories\": [], \"count\": 0, \"message\": \"No $TERMINOLOGY_PLURAL found. Create one with /new-$TERMINOLOGY_SINGULAR\"}"
  exit 0
fi

# Build stories array
STORIES_JSON="["
STORY_COUNT=0
FIRST=true

while IFS= read -r story_path; do
  STORY_FILE="$story_path/story.yaml"

  if [[ ! -f "$STORY_FILE" ]]; then
    continue
  fi

  # Extract story metadata
  STORY_SLUG=$(basename "$story_path")
  STORY_ID=$(yq '.metadata.id' "$STORY_FILE")
  STORY_TITLE=$(yq '.metadata.title' "$STORY_FILE")
  STORY_STATUS=$(yq '.metadata.status' "$STORY_FILE")
  WORKFLOW_ID=$(yq '.workflow' "$STORY_FILE")
  CURRENT_PHASE=$(yq '.progress.current_phase' "$STORY_FILE")
  PHASES_COMPLETED=$(yq '.stats.phases_completed' "$STORY_FILE")
  TOTAL_PHASES=$(yq '.stats.total_phases' "$STORY_FILE")
  GATES_PASSED=$(yq '.stats.gates_passed' "$STORY_FILE")
  TOTAL_GATES=$(yq '.stats.total_gates' "$STORY_FILE")
  COMPLETION_PCT=$(yq '.stats.completion_percentage' "$STORY_FILE")

  # Get phase name from workflow
  WORKFLOW_FILE="$TRAINSET_DIR/workflows/${WORKFLOW_ID}.yaml"
  PHASE_NAME=""
  if [[ -f "$WORKFLOW_FILE" ]]; then
    PHASE_NAME=$(yq ".phase[] | select(.id == \"$CURRENT_PHASE\") | .name" "$WORKFLOW_FILE" 2>/dev/null || echo "Unknown Phase")
  fi

  # Determine if active
  IS_ACTIVE=false
  [[ "$STORY_SLUG" == "$ACTIVE_STORY" ]] && IS_ACTIVE=true

  # Add comma if not first
  if [[ "$FIRST" == false ]]; then
    STORIES_JSON+=","
  fi
  FIRST=false

  # Build story JSON object
  STORIES_JSON+="
  {
    \"id\": \"$STORY_ID\",
    \"slug\": \"$STORY_SLUG\",
    \"title\": \"$STORY_TITLE\",
    \"status\": \"$STORY_STATUS\",
    \"workflow\": \"$WORKFLOW_ID\",
    \"current_phase\": \"$CURRENT_PHASE\",
    \"phase_name\": \"$PHASE_NAME\",
    \"phases_completed\": $PHASES_COMPLETED,
    \"total_phases\": $TOTAL_PHASES,
    \"gates_passed\": $GATES_PASSED,
    \"total_gates\": $TOTAL_GATES,
    \"completion_percentage\": $COMPLETION_PCT,
    \"is_active\": $IS_ACTIVE,
    \"path\": \"$story_path\"
  }"

  STORY_COUNT=$((STORY_COUNT + 1))
done <<< "$STORY_DIRS"

STORIES_JSON+="
]"

# Output based on format
if [[ "$FORMAT" == "json" ]]; then
  cat <<EOF
{
  "success": true,
  "stories": $STORIES_JSON,
  "count": $STORY_COUNT,
  "active_story": "$ACTIVE_STORY",
  "terminology": {
    "singular": "$TERMINOLOGY_SINGULAR",
    "plural": "$TERMINOLOGY_PLURAL"
  }
}
EOF
else
  # Text format (for human reading)
  echo "=== All $TERMINOLOGY_PLURAL ==="
  echo ""

  while IFS= read -r story_path; do
    STORY_FILE="$story_path/story.yaml"
    [[ ! -f "$STORY_FILE" ]] && continue

    STORY_SLUG=$(basename "$story_path")
    STORY_ID=$(yq '.metadata.id' "$STORY_FILE")
    STORY_TITLE=$(yq '.metadata.title' "$STORY_FILE")
    STORY_STATUS=$(yq '.metadata.status' "$STORY_FILE")
    WORKFLOW_ID=$(yq '.workflow' "$STORY_FILE")
    PHASES_COMPLETED=$(yq '.stats.phases_completed' "$STORY_FILE")
    TOTAL_PHASES=$(yq '.stats.total_phases' "$STORY_FILE")
    COMPLETION_PCT=$(yq '.stats.completion_percentage' "$STORY_FILE")

    # Status icon
    STATUS_ICON="📝"
    case "$STORY_STATUS" in
      completed) STATUS_ICON="✅" ;;
      in_progress) STATUS_ICON="⏳" ;;
      not_started) STATUS_ICON="📝" ;;
      archived) STATUS_ICON="📦" ;;
    esac

    # Active marker
    ACTIVE_MARKER=""
    [[ "$STORY_SLUG" == "$ACTIVE_STORY" ]] && ACTIVE_MARKER=" ⭐ ACTIVE"

    # Print story info
    echo "$STATUS_ICON $STORY_ID - $STORY_TITLE$ACTIVE_MARKER"
    echo "   Workflow: $WORKFLOW_ID | Progress: $PHASES_COMPLETED/$TOTAL_PHASES phases ($COMPLETION_PCT%)"
    echo ""
  done <<< "$STORY_DIRS"
fi
