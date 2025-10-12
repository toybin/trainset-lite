---
description: Switch to a different story to make it active
---

# Switch Story Command

!`bash .trainset/scripts/switch-story.sh "$@" 2>&1 || echo '{\"success\": false, \"error\": \"switch-story.sh not found or invalid story ID\"}'`

Parse the JSON output above and format it for the user:

## If successful:

**Switched to: [story_slug]**

- **Title:** [story_title]
- **Status:** [status]
- **Workflow:** [workflow]
- **Current Phase:** [current_phase.name] (Phase [current_phase.order]/[progress.total_phases])
- **Purpose:** [current_phase.purpose]
- **Progress:** [progress.phases_completed]/[progress.total_phases] phases ([progress.completion_percentage]%)

### Next Steps
- Run `/status` to see detailed phase and gate info
- Continue working on current phase
- Run `/gate-check` to see what's remaining
- Run `/advance` when phase is complete

---

## Usage

### Switch by ID
```
/switch 001
/switch 002
/switch 003
```

### Switch by slug
```
/switch 001-user-authentication
/switch 002-api-endpoints
```

---

## What Switching Does

1. **Updates active.yaml** - Points to the new story
2. **All commands operate on new story** - `/status`, `/advance`, `/gate-check`, etc.
3. **Previous story preserved** - No changes to the story you're switching away from
4. **Independent progress** - Each story maintains its own phase and gates

---

## Common Switching Scenarios

### Work on urgent bug, then return
```
You: /switch 002-urgent-bug
[Fix the bug, test, advance phases]
You: /switch 001-main-feature
```

### Alternate between code and docs
```
You: /switch 001-implementation
[Write code]
You: /switch 002-documentation
[Write docs]
You: /switch 001-implementation
```

### Check status of different stories
```
You: /switch 001
You: /status
You: /switch 002
You: /status
```

---

## Finding Story IDs

Use `/list-stories` to see all available stories with their IDs and current status.

---

## Error Handling

If the story doesn't exist:
- Check spelling of ID/slug
- Run `/list-stories` to see available options
- Story IDs are padded (001, not 1)

---

## After Switching

The new story is now active. All workflow commands operate on it:
- `/status` - Shows THIS story's progress
- `/gate-check` - Checks THIS story's gates
- `/advance` - Advances THIS story to next phase
- `/update-gate` - Updates THIS story's gates (if using manual mode)

Your previous story remains unchanged at whatever phase it was in.

---

## Multi-Story Workflow

Trainset Lite supports working on multiple stories simultaneously:

1. **Create stories** - `/new-story` for each work item
2. **List them** - `/list-stories` to see all
3. **Switch between** - `/switch` to change active story
4. **Independent progress** - Each advances through its workflow independently

This allows:
- Context switching (feature ↔ bug ↔ docs)
- Parallel work items
- Different workflows for different work types
- Flexible work management

---

## Terminology

The command adapts to your project's terminology:
- Development: "stories" or "tasks"
- Learning: "lessons" or "exercises"
- Documentation: "sections" or "articles"
- Research: "experiments" or "investigations"
