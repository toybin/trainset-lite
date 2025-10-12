#!/usr/bin/env bash
# switch-story.sh - Switch active story
# Usage: bash .trainset/scripts/switch-story.sh <story-id-or-slug>

set -euo pipefail

# Configuration
TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
HIERARCHY_FILE="$TRAINSET_DIR/hierarchy.yaml"
ACTIVE_FILE="$TRAINSET_DIR/active.yaml"

# Helper function for JSON output
json_error() {
  echo "{\"success\": false, \"error\": \"$1\"}" >&2
  exit 1
}

# Check dependencies
command -v yq >/dev/null 2>&1 || json_error "yq is required but not installed"

# Check if hierarchy.yaml exists
[[ -f "$HIERARCHY_FILE" ]] || json_error "hierarchy.yaml not found. Run /setup first."

# Parse arguments
STORY_IDENTIFIER="${1:-}"

if [[ -z "$STORY_IDENTIFIER" ]]; then
  json_error "Story ID or slug required. Usage: bash switch-story.sh <story-id-or-slug>"
fi

# Read configuration
TERMINOLOGY_SINGULAR=$(yq '.terminology.singular' "$HIERARCHY_FILE")
TERMINOLOGY_DIRECTORY=$(yq '.terminology.directory' "$HIERARCHY_FILE")
STORY_DIR="$TRAINSET_DIR/$TERMINOLOGY_DIRECTORY"

# Find story by ID or slug
STORY_PATH=""
STORY_SLUG=""

# Check if stories directory exists
[[ -d "$STORY_DIR" ]] || json_error "No $TERMINOLOGY_DIRECTORY directory found. Create a $TERMINOLOGY_SINGULAR first."

# Try to find by exact slug match first
if [[ -d "$STORY_DIR/$STORY_IDENTIFIER" ]]; then
  STORY_PATH="$STORY_DIR/$STORY_IDENTIFIER"
  STORY_SLUG="$STORY_IDENTIFIER"
else
  # Try to find by ID prefix (e.g., "001" matches "001-user-auth")
  MATCHING_DIRS=$(find "$STORY_DIR" -maxdepth 1 -type d -name "${STORY_IDENTIFIER}*" | head -1)

  if [[ -n "$MATCHING_DIRS" ]]; then
    STORY_PATH="$MATCHING_DIRS"
    STORY_SLUG=$(basename "$STORY_PATH")
  else
    json_error "$TERMINOLOGY_SINGULAR not found: '$STORY_IDENTIFIER'. Use /list-${TERMINOLOGY_DIRECTORY} to see available options."
  fi
fi

# Verify story.yaml exists
STORY_FILE="$STORY_PATH/story.yaml"
[[ -f "$STORY_FILE" ]] || json_error "Story file not found at $STORY_FILE"

# Read story metadata
STORY_ID=$(yq '.metadata.id' "$STORY_FILE")
STORY_TITLE=$(yq '.metadata.title' "$STORY_FILE")
STORY_STATUS=$(yq '.metadata.status' "$STORY_FILE")
WORKFLOW_ID=$(yq '.workflow' "$STORY_FILE")
CURRENT_PHASE=$(yq '.progress.current_phase' "$STORY_FILE")
PHASES_COMPLETED=$(yq '.stats.phases_completed' "$STORY_FILE")
TOTAL_PHASES=$(yq '.stats.total_phases' "$STORY_FILE")
COMPLETION_PCT=$(yq '.stats.completion_percentage' "$STORY_FILE")

# Get phase details from workflow
WORKFLOW_FILE="$TRAINSET_DIR/workflows/${WORKFLOW_ID}.yaml"
PHASE_NAME=""
PHASE_PURPOSE=""
PHASE_ORDER=""

if [[ -f "$WORKFLOW_FILE" ]]; then
  PHASE_NAME=$(yq ".phase[] | select(.id == \"$CURRENT_PHASE\") | .name" "$WORKFLOW_FILE" 2>/dev/null || echo "Unknown Phase")
  PHASE_PURPOSE=$(yq ".phase[] | select(.id == \"$CURRENT_PHASE\") | .purpose" "$WORKFLOW_FILE" 2>/dev/null || echo "")
  PHASE_ORDER=$(yq ".phase[] | select(.id == \"$CURRENT_PHASE\") | .order" "$WORKFLOW_FILE" 2>/dev/null || echo "")
fi

# Update active.yaml
cat > "$ACTIVE_FILE" <<EOF
# Active Story Pointer
active_story: "$STORY_SLUG"
updated: "$(date +%Y-%m-%d)"
EOF

# Output success JSON
cat <<EOF
{
  "success": true,
  "story_id": "$STORY_ID",
  "story_slug": "$STORY_SLUG",
  "story_title": "$STORY_TITLE",
  "status": "$STORY_STATUS",
  "workflow": "$WORKFLOW_ID",
  "current_phase": {
    "id": "$CURRENT_PHASE",
    "name": "$PHASE_NAME",
    "purpose": "$PHASE_PURPOSE",
    "order": $PHASE_ORDER
  },
  "progress": {
    "phases_completed": $PHASES_COMPLETED,
    "total_phases": $TOTAL_PHASES,
    "completion_percentage": $COMPLETION_PCT
  },
  "message": "Switched to $TERMINOLOGY_SINGULAR '$STORY_SLUG'"
}
EOF
