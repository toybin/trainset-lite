---
description: List all stories with their status and progress
---

# List Stories Command

!`bash .trainset/scripts/list-stories.sh 2>&1 || echo '{\"success\": false, \"error\": \"list-stories.sh not found - run /setup first\"}'`

Parse the JSON output above and format it for the user:

## Format as:

### All [Terminology Plural] ([count] total)

For each story in the stories array:

**[status_icon] [id] - [title]** [⭐ ACTIVE if is_active=true]
- Workflow: [workflow]
- Progress: [phases_completed]/[total_phases] phases ([completion_percentage]%)
- Current: [phase_name] (if status=in_progress)
- Status: [status]

---

### Status Icons
- ✅ completed
- ⏳ in_progress
- 📝 not_started
- 📦 archived

---

## Example Output

```
### All Stories (3 total)

✅ 001 - User Authentication System ⭐ ACTIVE
- Workflow: feature-workflow
- Progress: 4/4 phases (100%)
- Status: completed

⏳ 002 - REST API Endpoints
- Workflow: feature-workflow
- Progress: 2/4 phases (50%)
- Current: Implementation
- Status: in_progress

📝 003 - API Documentation
- Workflow: docs-workflow
- Progress: 0/3 phases (0%)
- Status: not_started
```

---

## Actions

After viewing the list:
- Switch to a story: `/switch 002`
- Create new story: `/new-story "Title"`
- Check status of active: `/status`

---

## Filtering & Sorting

Currently shows all stories sorted by ID. Future enhancements:
- Filter by status (in_progress, completed)
- Filter by workflow type
- Sort by completion percentage
- Search by title

---

## Story States

- **not_started** - Created but no work done
- **in_progress** - Currently being worked on
- **completed** - All phases finished
- **archived** - Completed and archived (future feature)

---

## Multiple Workflows

Stories can use different workflows:
- feature-workflow - Standard feature development
- bugfix-workflow - Bug investigation and fixing
- docs-workflow - Documentation writing
- custom workflows - Project-specific processes

Each workflow defines its own phases and gates.

---

## Working with Multiple Stories

Common patterns:
1. **Feature + Bug** - Work on feature, switch to fix urgent bug, switch back
2. **Code + Docs** - Alternate between implementation and documentation
3. **Experimentation** - Try different approaches as separate stories
4. **Team Coordination** - Each team member works on different story

All stories maintain independent progress - switching doesn't affect other stories.
