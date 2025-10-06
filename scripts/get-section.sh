#!/bin/bash
# Extract a specific section from a markdown file
# Usage: get-section.sh <file> <section-heading>
# Output: Section content (or error JSON)

set -euo pipefail

FILE="${1:-.trainset/WORKFLOW.md}"
SECTION="${2:-}"

# Validate inputs
if [ -z "$SECTION" ]; then
  echo '{"error": "Section heading required", "success": false}' >&2
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "{\"error\": \"File not found: $FILE\", \"success\": false}" >&2
  exit 1
fi

# Try different heading levels
for level in "###" "##" "#"; do
  # Extract section between headings (stop at next same-level heading)
  content=$(awk "/$level $SECTION/,/$level [^$SECTION]/" "$FILE" 2>/dev/null | sed '$d')
  
  if [ -n "$content" ]; then
    echo "$content"
    exit 0
  fi
done

# Section not found
echo "{\"error\": \"Section '$SECTION' not found in $FILE\", \"success\": false}" >&2
exit 1
