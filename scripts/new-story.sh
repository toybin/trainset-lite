#!/usr/bin/env bash
# new-story.sh - Create a new story/task/lesson/work item
# Usage: bash .trainset/scripts/new-story.sh "Story Title" [--workflow workflow-id]

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
command -v yq >/dev/null 2>&1 || json_error "yq is required but not installed. Install from https://github.com/mikefarah/yq"

# Check if hierarchy.yaml exists
[[ -f "$HIERARCHY_FILE" ]] || json_error "hierarchy.yaml not found. Run /setup first."

# Parse arguments
STORY_TITLE="${1:-}"
WORKFLOW_ID=""
GENERATE_NEW_WORKFLOW=false

if [[ -z "$STORY_TITLE" ]]; then
  json_error "Story title required. Usage: bash new-story.sh \"Story Title\" [--workflow workflow-id]"
fi

# Parse optional arguments
shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --workflow)
      WORKFLOW_ID="${2:-}"
      [[ -z "$WORKFLOW_ID" ]] && json_error "--workflow requires a workflow ID"
      shift 2
      ;;
    --new-workflow)
      GENERATE_NEW_WORKFLOW=true
      shift
      ;;
    *)
      json_error "Unknown option: $1"
      ;;
  esac
done

# Read hierarchy configuration
TERMINOLOGY_SINGULAR=$(yq '.terminology.singular' "$HIERARCHY_FILE")
TERMINOLOGY_DIRECTORY=$(yq '.terminology.directory' "$HIERARCHY_FILE")
DEFAULT_WORKFLOW=$(yq '.default_workflow' "$HIERARCHY_FILE")

# Use default workflow if not specified
if [[ -z "$WORKFLOW_ID" ]] && [[ "$GENERATE_NEW_WORKFLOW" == false ]]; then
  WORKFLOW_ID="$DEFAULT_WORKFLOW"
fi

# Validate workflow exists (unless generating new one)
if [[ "$GENERATE_NEW_WORKFLOW" == false ]]; then
  WORKFLOW_FILE="$TRAINSET_DIR/workflows/${WORKFLOW_ID}.yaml"
  [[ -f "$WORKFLOW_FILE" ]] || json_error "Workflow '$WORKFLOW_ID' not found at $WORKFLOW_FILE"
fi

# Generate story ID (next sequential number)
STORY_DIR="$TRAINSET_DIR/$TERMINOLOGY_DIRECTORY"
mkdir -p "$STORY_DIR"

# Find next ID
NEXT_ID=1
if [[ -d "$STORY_DIR" ]] && [[ -n "$(ls -A "$STORY_DIR" 2>/dev/null)" ]]; then
  # Get highest existing ID
  HIGHEST_ID=$(find "$STORY_DIR" -maxdepth 1 -type d -name "[0-9]*" |
               sed 's/.*\///' |
               sed 's/-.*$//' |
               sort -n |
               tail -1)
  if [[ -n "$HIGHEST_ID" ]]; then
    NEXT_ID=$((HIGHEST_ID + 1))
  fi
fi

# Format ID with leading zeros (001, 002, etc.)
STORY_ID=$(printf "%03d" "$NEXT_ID")

# Create slug from title
STORY_SLUG="${STORY_ID}-$(echo "$STORY_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')"

# Create story directory
STORY_PATH="$STORY_DIR/$STORY_SLUG"
mkdir -p "$STORY_PATH"

# If generating new workflow, prompt user (this will be handled by AI in slash command)
if [[ "$GENERATE_NEW_WORKFLOW" == true ]]; then
  echo "{\"success\": true, \"action\": \"generate_workflow\", \"story_id\": \"$STORY_ID\", \"story_slug\": \"$STORY_SLUG\", \"story_path\": \"$STORY_PATH\", \"message\": \"Story directory created. AI should now generate custom workflow.\"}"
  exit 0
fi

# Read workflow metadata
WORKFLOW_NAME=$(yq '.metadata.name' "$WORKFLOW_FILE")
WORKFLOW_PHASES=$(yq '.phase | length' "$WORKFLOW_FILE")
FIRST_PHASE_ID=$(yq '.phase[0].id' "$WORKFLOW_FILE")

# Count total gates
TOTAL_GATES=$(yq '.gates | keys | length' "$WORKFLOW_FILE")

# Create story.yaml with initial state
cat > "$STORY_PATH/story.yaml" <<EOF
# Story State - $STORY_TITLE
metadata:
  id: "$STORY_ID"
  slug: "$STORY_SLUG"
  title: "$STORY_TITLE"
  description: "Brief description of this $TERMINOLOGY_SINGULAR"
  created: "$(date +%Y-%m-%d)"
  updated: "$(date +%Y-%m-%d)"
  status: "not_started"

workflow: "$WORKFLOW_ID"

progress:
  current_phase: "$FIRST_PHASE_ID"
  phase_started: "$(date +%Y-%m-%d)"
  phases_complete: []

gate_status:
EOF

# Add all gates from workflow initialized to false
yq '.gates | keys | .[]' "$WORKFLOW_FILE" | while read -r gate_id; do
  echo "  $gate_id: false" >> "$STORY_PATH/story.yaml"
done

# Add stats
cat >> "$STORY_PATH/story.yaml" <<EOF

stats:
  total_phases: $WORKFLOW_PHASES
  phases_completed: 0
  total_gates: $TOTAL_GATES
  gates_passed: 0
  completion_percentage: 0

sessions: []
tags: []
related:
  blocks: []
  blocked_by: []
  related_to: []
EOF

# Create STORY.md with initial template
FIRST_PHASE_NAME=$(yq '.phase[0].name' "$WORKFLOW_FILE")
FIRST_PHASE_PURPOSE=$(yq '.phase[0].purpose' "$WORKFLOW_FILE")

cat > "$STORY_PATH/STORY.md" <<EOF
# $STORY_TITLE

**ID:** $STORY_ID
**Status:** Not Started
**Workflow:** $WORKFLOW_NAME
**Created:** $(date +%Y-%m-%d)

## Overview

Brief description of what this $TERMINOLOGY_SINGULAR aims to accomplish and why it's important.

## Context

- **Background:** Why this work is needed
- **Scope:** What's included and what's not
- **Success Criteria:** What "done" looks like

## Technical Notes

### Architecture

[Key architectural decisions and design patterns]

### Dependencies

- Depends on: [other stories/systems]
- Blocks: [stories that depend on this]

### Key Files

- \`path/to/file.ext\` - Description
- \`path/to/other.ext\` - Description

## Progress Log

### $(date +%Y-%m-%d) - Started

Beginning Phase 1: $FIRST_PHASE_NAME

**Goal:** $FIRST_PHASE_PURPOSE

**Tasks:**
- [ ] [Specific tasks for this phase]

## Decisions & Rationale

Record key decisions made during this work:

1. **Decision:** [What was decided]
   - **Rationale:** [Why this approach was chosen]
   - **Alternatives considered:** [What else was evaluated]
   - **Trade-offs:** [What we gained/lost]

## Challenges & Solutions

Document problems encountered and how they were resolved:

- **Challenge:** [Description]
  - **Solution:** [How it was resolved]
  - **Lessons learned:** [Key takeaways]

## Related Work

- Related to: [Link to related stories/docs]
- References: [External docs, RFCs, tickets]

---

*This file tracks the narrative context for this $TERMINOLOGY_SINGULAR. The machine-readable state is in story.yaml.*
EOF

# Update active.yaml to point to new story
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
  "story_path": "$STORY_PATH",
  "workflow": "$WORKFLOW_ID",
  "workflow_name": "$WORKFLOW_NAME",
  "initial_phase": "$FIRST_PHASE_NAME",
  "total_phases": $WORKFLOW_PHASES,
  "total_gates": $TOTAL_GATES,
  "message": "Created $TERMINOLOGY_SINGULAR '$STORY_SLUG' using workflow '$WORKFLOW_ID'. Now active."
}
EOF
