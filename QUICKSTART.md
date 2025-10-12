# Trainset Lite Quick Start Guide

**Get started with structured AI-assisted development in 10 minutes**

This guide walks you through installing Trainset Lite and setting up your first workflow.

---

## Prerequisites

- A project directory (new or existing)
- An AI coding assistant (Claude Code, OpenCode, or similar)
- Bash 4.0+ (standard on macOS and Linux)

---

## Step 1: Install Trainset Lite

### Option A: From Local Copy

```bash
# Navigate to your project
cd ~/my-project

# Run installer
bash /path/to/trainset-lite/install.sh
```

### Option B: From GitHub (once published)

```bash
cd ~/my-project
curl -fsSL https://raw.githubusercontent.com/toybin/trainset-lite/main/install.sh | bash
```

### What Gets Installed

```
your-project/
├── .trainset/              # Workflow system
│   ├── scripts/           # Bash automation
│   ├── interviews/        # Setup templates
│   ├── templates/         # Workflow examples
│   └── template-library.md
└── .claude/               # Or .opencode/ depending on platform
    ├── commands/          # Slash commands
    └── CLAUDE.md          # Agent context
```

---

## Step 2: Restart Your AI CLI

**Important:** Restart your AI assistant so it loads the new commands.

```bash
# For Claude Code or OpenCode, restart the CLI
# Commands won't appear until you restart
```

---

## Step 3: Run Setup

In your AI assistant, run:

```
/setup
```

The AI will:
1. Ask about your project (type, tech stack, goals)
2. Generate custom workflow files
3. Create initial progress tracker

### Interview Questions

Expect questions like:

- **What are you building?**
- **What does "done" look like?**
- **What's your tech stack?**
- **How much structure do you want?**
- **What are your key constraints?**

Answer honestly - the workflow adapts to your needs.

---

## Step 4: Review Generated Files

After setup, you'll have:

### `.trainset/WORKFLOW.md`
Your project's phase structure:

```markdown
## Phases

### Phase 1: Project Definition
**Purpose:** Clearly understand what you're building
**Gate:**
- [ ] Problem statement is clear
- [ ] Success criteria defined
- [ ] Scope boundaries set
...

### Phase 2: Architecture Design
...
```

### `.trainset/CONTEXT.md`
Project details and commands:

```markdown
## Technical Details
**Primary Technologies:**
- Python 3.11
- FastAPI
- PostgreSQL

**Key Commands:**
- Test: `pytest`
- Lint: `ruff check`
- Run: `uvicorn app.main:app --reload`
```

### `.trainset/PROGRESS.md`
Current phase tracking:

```markdown
## Current Phase: Phase 1 - Project Definition

## Phase 1 Checklist
- [ ] Problem statement is clear
- [ ] Success criteria defined
- [ ] Scope boundaries set
- [ ] Technical approach feasible
- [ ] Key risks identified
```

---

## Step 5: Start Working

### Check Your Status

```
/status
```

You'll see:
- Current phase and purpose
- Progress on checklist items
- Gate readiness
- Suggested next steps

### Work Through Your Phase

As you complete items, mark them in `.trainset/PROGRESS.md`:

```markdown
- [x] Problem statement is clear  ✅ Done!
- [ ] Success criteria defined    ⏳ Working on this
```

Or use the bash script:
```bash
bash .trainset/scripts/update-progress.sh "Problem statement is clear" complete
```

### Check Gate Readiness

```
/gate-check
```

This assesses whether you're ready to advance:
- What's complete
- What's remaining
- Specific recommendations

### Advance to Next Phase

When all gate items are checked:

```
/advance
```

The system will:
- Validate all checklist items are complete
- Update PROGRESS.md to next phase
- Show you the new phase goals

---

## Step 6: Ongoing Usage

### Daily Workflow

1. **Start session:** `/status` - See where you are
2. **Work on items:** Complete checklist tasks
3. **Check progress:** `/gate-check` - Assess readiness
4. **Advance:** `/advance` - Move to next phase when ready

### Key Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/status` | Show current state | Start of session, check progress |
| `/advance` | Move to next phase | All gate items complete |
| `/gate-check` | Assess readiness | Before attempting to advance |
| `/context` | View project details | After time away, for AI context |

---

## Example Session

```
You: /status

AI:
### Current State
- Phase 1 - Project Definition
- 2/5 items complete

### Progress
✅ Problem statement clear
✅ Success criteria defined
⏳ Scope boundaries
⏳ Technical approach
⏳ Key risks

**Gate:** Not ready (3 items remaining)

---

You: Let me define the scope. [works on it]

You: /gate-check

AI:
### Assessment: Nearly Ready ⚠️

✅ Problem statement
✅ Success criteria
✅ Scope boundaries (just completed!)
⏳ Technical approach (needs: choose framework)
⏳ Key risks (needs: identify top 3)

Estimated: 30 minutes to gate

---

You: [completes remaining items]

You: /advance

AI:
🎉 Advanced to Phase 2 - Architecture Design

Purpose: Plan high-level structure and technical decisions

You've completed Phase 1! Next steps:
- Identify major system components
- Define how components interact
- Make key technical decisions
```

---

## Tips for Success

### Do This ✅

- **Be specific in interviews** - Better input = better workflow
- **Update progress regularly** - Keep PROGRESS.md current
- **Review gate criteria** - Understand what "done" means for each phase
- **Adapt the workflow** - Edit WORKFLOW.md to fit your needs
- **Use /status often** - Stay oriented, especially after breaks

### Avoid This ❌

- **Skipping phases** - Each builds on the previous
- **Ignoring gates** - They prevent technical debt
- **Being too rigid** - Workflow is guidance, not law
- **Forgetting to restart** - AI won't see commands without restart
- **Not customizing** - Generic workflows don't help as much

---

## Platform-Specific Notes

### Claude Code

Commands in: `~/.claude/commands/` (user-level) or `.claude/commands/` (project-level)

```
/status
/advance
/gate-check
/context
/setup
```

### OpenCode

Commands in: `.opencode/command/`

Same commands as Claude Code.

### Other Platforms (Gemini, Cursor, etc.)

No slash commands, use bash directly:

```bash
bash .trainset/scripts/status.sh
bash .trainset/scripts/validate-gate.sh
bash .trainset/scripts/advance-phase.sh
bash .trainset/scripts/extract-context.sh
```

---

## Troubleshooting

### Commands not appearing

**Solution:** Restart your AI CLI completely

### Wrong paths in commands

**Solution:** Verify `.trainset/` exists in project root

### Scripts not executable

```bash
chmod +x .trainset/scripts/*.sh
```

### Workflow doesn't fit project

**Solution:** Edit `.trainset/WORKFLOW.md` directly - it's just markdown!

### Lost context after time away

```
/context     # Remind AI of project details
/status      # See where you left off
```

---

## Next Steps

After your first workflow:

1. **Read the template library** - `.trainset/template-library.md` for patterns
2. **Explore bash scripts** - `.trainset/scripts/README.md` for automation
3. **Customize workflows** - Edit WORKFLOW.md for future projects
4. **Try different project types** - Learning, documentation, research

---

## Getting Help

- **Documentation:** All docs in `.trainset/` and repo root
- **Issues:** [GitHub Issues](https://github.com/toybin/trainset-lite/issues)
- **Discussions:** [GitHub Discussions](https://github.com/toybin/trainset-lite/discussions)

---

## What's Next?

You're ready to build structured projects with AI assistance!

**Remember the workflow:**
1. Run `/status` to check progress
2. Work on checklist items
3. Use `/gate-check` to assess readiness
4. Run `/advance` when gate passes
5. Repeat for next phase

Happy structured coding! 🚀
