#!/usr/bin/env bash
set -euo pipefail

TRAINSET_DIR="${TRAINSET_DIR:-.trainset}"
OUTPUT_FILE="${1:-$TRAINSET_DIR/CONTEXT.md}"

if [[ -f "$OUTPUT_FILE" ]]; then
    echo "{\"success\": false, \"error\": \"CONTEXT.md already exists at $OUTPUT_FILE\"}" >&2
    exit 1
fi

cat > "$OUTPUT_FILE" << 'EOF'
# Project Context: [FILL IN: Project Name]

## Project Overview

**Name:** [FILL IN: Project name]
**Type:** [FILL IN: Development/Learning/Documentation/Research/etc.]
**Workflow:** [FILL IN: Workflow name/type]

[FILL IN: Brief project description - 2-3 sentences explaining what this project is and why it exists]

## Technical Details

**Primary Technologies:**
- [FILL IN: Language/framework 1]
- [FILL IN: Language/framework 2]
- [FILL IN: Key tool/library 1]
- [FILL IN: Key tool/library 2]

**Development Environment:**
- [FILL IN: Package manager/build tool]
- [FILL IN: Editor/IDE preferences]
- [FILL IN: Testing framework]
- [FILL IN: Other development tools]

**Key Commands:**
- **Test:** `[FILL IN: test command]`
- **Lint:** `[FILL IN: lint command]`
- **Type Check:** `[FILL IN: type check command]` (if applicable)
- **Build:** `[FILL IN: build command]`
- **Run:** `[FILL IN: run command]`

## Architecture

[FILL IN: High-level architectural overview]

**Key Components:**
- [FILL IN: Component 1 - brief description]
- [FILL IN: Component 2 - brief description]
- [FILL IN: Component 3 - brief description]

**Design Principles:**
- [FILL IN: Principle 1]
- [FILL IN: Principle 2]
- [FILL IN: Principle 3]

## Working Context

**Working Style:**
- [FILL IN: Solo/team/collaborative]
- [FILL IN: Session structure - e.g., 60-90 min focused blocks]
- [FILL IN: Development approach - e.g., TDD, iterative, etc.]

**Session Structure:**
- [FILL IN: Typical session length]
- [FILL IN: Break frequency]
- [FILL IN: Progress tracking approach]

**Quality Standards:**
- [FILL IN: Testing requirements]
- [FILL IN: Code review process]
- [FILL IN: Documentation standards]

**Collaboration:**
- [FILL IN: Team structure if applicable]
- [FILL IN: Communication patterns]
- [FILL IN: Handoff procedures]

## Project Constraints

**Timeline:**
- [FILL IN: Deadlines or timeline]
- [FILL IN: Pace preferences]

**Scope:**
- [FILL IN: What's in scope]
- [FILL IN: What's out of scope]
- [FILL IN: Key deliverables]

**Technical:**
- [FILL IN: Platform requirements]
- [FILL IN: Compatibility constraints]
- [FILL IN: Performance requirements]

## Success Criteria

**Primary Goals:**
1. [FILL IN: Goal 1]
2. [FILL IN: Goal 2]
3. [FILL IN: Goal 3]

**Quality Measures:**
- [FILL IN: Metric 1]
- [FILL IN: Metric 2]
- [FILL IN: Metric 3]

## Current Focus

**Active Phase:** [FILL IN: Current phase from PROGRESS.md]
**Phase Purpose:** [FILL IN: What current phase accomplishes]

**Key Deliverables:**
- [FILL IN: Deliverable 1]
- [FILL IN: Deliverable 2]

**Immediate Tasks:**
- [FILL IN: Task 1]
- [FILL IN: Task 2]

**Gate Criteria:**
- [FILL IN: What needs to be complete to advance]

[FILL IN: Add any additional sections specific to your project context]
EOF

echo "{\"success\": true, \"file\": \"$OUTPUT_FILE\", \"message\": \"CONTEXT.md scaffold created successfully\"}"
