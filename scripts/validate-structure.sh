#!/bin/bash
# Validate that workflow files have required structure
# Output: JSON with validation results

set -euo pipefail

WORKFLOW_FILE="${TRAINSET_DIR:-.trainset}/WORKFLOW.md"
PROGRESS_FILE="${TRAINSET_DIR:-.trainset}/PROGRESS.md"
CONTEXT_FILE="${TRAINSET_DIR:-.trainset}/CONTEXT.md"

# Required sections per file
declare -A required_sections=(
  ["WORKFLOW"]="## Principles|## Phases|## Commands"
  ["PROGRESS"]="## Current Phase|## Phase [0-9]+ Checklist"
  ["CONTEXT"]="## Project Overview|## Technical Details|## Working Context"
)

errors=()
warnings=()

# Check WORKFLOW.md
if [ -f "$WORKFLOW_FILE" ]; then
  IFS='|' read -ra sections <<< "${required_sections[WORKFLOW]}"
  for section in "${sections[@]}"; do
    if ! grep -qE "^$section" "$WORKFLOW_FILE"; then
      errors+=("WORKFLOW.md missing: $section")
    fi
  done
else
  errors+=("WORKFLOW.md not found")
fi

# Check PROGRESS.md
if [ -f "$PROGRESS_FILE" ]; then
  IFS='|' read -ra sections <<< "${required_sections[PROGRESS]}"
  for section in "${sections[@]}"; do
    if ! grep -qE "^$section" "$PROGRESS_FILE"; then
      errors+=("PROGRESS.md missing: $section")
    fi
  done
else
  errors+=("PROGRESS.md not found")
fi

# Check CONTEXT.md (optional but recommended)
if [ -f "$CONTEXT_FILE" ]; then
  IFS='|' read -ra sections <<< "${required_sections[CONTEXT]}"
  for section in "${sections[@]}"; do
    if ! grep -qE "^$section" "$CONTEXT_FILE"; then
      warnings+=("CONTEXT.md missing recommended section: $section")
    fi
  done
else
  warnings+=("CONTEXT.md not found (recommended)")
fi

# Build JSON output
valid="true"
if [ ${#errors[@]} -gt 0 ]; then
  valid="false"
fi

# Convert arrays to JSON arrays
if [ ${#errors[@]} -gt 0 ]; then
  errors_json=$(printf '%s\n' "${errors[@]}" | jq -R . | jq -s . 2>/dev/null || echo '[]')
else
  errors_json='[]'
fi

if [ ${#warnings[@]} -gt 0 ]; then
  warnings_json=$(printf '%s\n' "${warnings[@]}" | jq -R . | jq -s . 2>/dev/null || echo '[]')
else
  warnings_json='[]'
fi

cat <<EOF
{
  "success": true,
  "valid": $valid,
  "errors": $errors_json,
  "warnings": $warnings_json,
  "message": "$([ "$valid" = "true" ] && echo "Structure validation passed" || echo "Structure validation failed")"
}
EOF

# Exit code reflects validation status
[ "$valid" = "true" ] && exit 0 || exit 1
