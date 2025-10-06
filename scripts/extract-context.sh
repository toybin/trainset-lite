#!/usr/bin/env bash
set -euo pipefail

TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
CONTEXT_FILE="$TRAINSET_DIR/CONTEXT.md"

if [[ ! -f "$CONTEXT_FILE" ]]; then
    echo "{\"success\": false, \"error\": \"CONTEXT.md not found\"}" >&2
    exit 1
fi

PROJECT_NAME=$(grep "^\*\*Name:\*\*" "$CONTEXT_FILE" | sed "s/^\*\*Name:\*\* //" || echo "")
PROJECT_TYPE=$(grep "^\*\*Type:\*\*" "$CONTEXT_FILE" | sed "s/^\*\*Type:\*\* //" || echo "")
WORKFLOW=$(grep "^\*\*Workflow:\*\*" "$CONTEXT_FILE" | sed "s/^\*\*Workflow:\*\* //" || echo "")
ACTIVE_PHASE=$(grep "^\*\*Active Phase:\*\*" "$CONTEXT_FILE" | sed "s/^\*\*Active Phase:\*\* //" || echo "")

TECH_STACK=$(grep "^- " "$CONTEXT_FILE" | head -10 | sed 's/^- //' | tr '\n' '|' | sed 's/|$//' || echo "")
COMMANDS=$(grep "^\*\*Test:\*\*\|^\*\*Lint:\*\*\|^\*\*Build:\*\*\|^\*\*Run:\*\*" "$CONTEXT_FILE" | tr '\n' '|' | sed 's/|$//' || echo "")

cat << EOF
{
  "success": true,
  "project": {
    "name": "$PROJECT_NAME",
    "type": "$PROJECT_TYPE",
    "workflow": "$WORKFLOW"
  },
  "tech_stack": "$TECH_STACK",
  "commands": "$COMMANDS",
  "active_phase": "$ACTIVE_PHASE"
}
EOF
