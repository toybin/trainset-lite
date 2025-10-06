#!/bin/bash
# Update checklist item status in PROGRESS.md
# Usage: update-progress.sh <item-text> <status>
#   status: "complete" or "incomplete"
# Output: JSON with update results

set -euo pipefail

PROGRESS_FILE="${TRAINSET_DIR:-.trainset}/PROGRESS.md"
ITEM_TEXT="${1:-}"
STATUS="${2:-complete}"

# Validate inputs
if [ -z "$ITEM_TEXT" ]; then
  echo '{"error": "Item text required", "success": false}' >&2
  exit 1
fi

if [ ! -f "$PROGRESS_FILE" ]; then
  echo '{"error": "PROGRESS.md not found", "success": false}' >&2
  exit 1
fi

# Create backup
cp "$PROGRESS_FILE" "${PROGRESS_FILE}.bak"

# Determine marker based on status
if [ "$STATUS" = "complete" ]; then
  old_marker="- \[ \]"
  new_marker="- [x]"
  status_msg="marked complete"
elif [ "$STATUS" = "incomplete" ]; then
  old_marker="- \[x\]"
  new_marker="- [ ]"
  status_msg="marked incomplete"
else
  echo "{\"error\": \"Invalid status: $STATUS (use 'complete' or 'incomplete')\", \"success\": false}" >&2
  exit 1
fi

# Escape special characters for sed
escaped_text=$(echo "$ITEM_TEXT" | sed 's/[\/&]/\\&/g')

# Build the search pattern
if [ "$STATUS" = "complete" ]; then
  search_pattern="^- \[ \] $ITEM_TEXT\$"
else
  search_pattern="^- \[x\] $ITEM_TEXT\$"
fi

# Try to find and update the item using basic regex
if grep -q "^- \[ \] $ITEM_TEXT\$" "$PROGRESS_FILE" 2>/dev/null || grep -q "^- \[x\] $ITEM_TEXT\$" "$PROGRESS_FILE" 2>/dev/null; then
  # Check if it's in the expected state
  if grep -q "$search_pattern" "$PROGRESS_FILE" 2>/dev/null; then
    # Item found in expected state, update it
    sed -i.tmp "s/$old_marker $escaped_text/$new_marker $ITEM_TEXT/" "$PROGRESS_FILE"
    rm "${PROGRESS_FILE}.tmp"
    
    echo "{\"success\": true, \"message\": \"Item '$ITEM_TEXT' $status_msg\", \"backup\": \"${PROGRESS_FILE}.bak\"}"
    exit 0
  else
    # Item exists but in wrong state
    echo "{\"success\": false, \"error\": \"Item already has different status\", \"message\": \"Item '$ITEM_TEXT' found but not in expected state\"}" >&2
    mv "${PROGRESS_FILE}.bak" "$PROGRESS_FILE"
    exit 1
  fi
else
  # Item not found at all
  echo "{\"success\": false, \"error\": \"Item not found\", \"message\": \"Could not find item: $ITEM_TEXT\"}" >&2
  mv "${PROGRESS_FILE}.bak" "$PROGRESS_FILE"
  exit 1
fi
