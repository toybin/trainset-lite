---
description: Create a new story/task/lesson with workflow selection
---

# New Story Command

!`bash .trainset/scripts/new-story.sh "$@" 2>&1 || echo '{\"success\": false, \"error\": \"new-story.sh not found - run /setup first\"}'`

Parse the JSON output above and format it for the user:

## If successful:

**Created: [story_slug]**

- **Title:** [story_title]
- **Workflow:** [workflow_name]
- **Phases:** [total_phases] phases
- **Gates:** [total_gates] gates total
- **Status:** Now active (automatically switched)

### Next Steps
- Run `/status` to see current phase and gates
- Start working on Phase 1
- Mark gates complete with automated tools or manual updates
- Run `/advance` when ready to move to next phase

---

## Usage Examples

### Create with default workflow
```
/new-story "User Authentication System"
```

### Create with specific workflow
```
/new-story "Fix Login Bug" --workflow bugfix-workflow
```

### Create with new workflow (AI generates)
```
/new-story "API Documentation" --new-workflow
```

---

## Workflow Selection

The system supports multiple workflow types:

- **feature-workflow** - Default for new features
- **bugfix-workflow** - For bug fixes (if exists)
- **docs-workflow** - For documentation work (if exists)
- **--new-workflow** - Generate custom workflow for this story

When using `--new-workflow`, the AI will:
1. Ask what type of work this is
2. Generate appropriate phases and gates
3. Save the new workflow for reuse
4. Create the story using that workflow

---

## Terminology

The command adapts to your project's terminology:
- Development projects: "stories" or "tasks"
- Learning projects: "lessons" or "exercises"
- Documentation projects: "sections" or "articles"
- Research projects: "experiments" or "investigations"

Your project uses: **[read from hierarchy.yaml]**

---

## Multiple Stories

You can have many stories in progress:
- Each tracks its own phase and gate progress
- Switch between them with `/switch`
- View all with `/list-stories`
- Work is independent - advancing one doesn't affect others

---

## After Creation

The new story becomes active automatically. All commands like `/status`, `/advance`, and `/gate-check` will operate on this story until you `/switch` to another.

Story files created:
- `.trainset/stories/[slug]/story.yaml` - Machine-readable state
- `.trainset/stories/[slug]/STORY.md` - Human-readable context and notes
- `.trainset/active.yaml` - Updated to point to new story
