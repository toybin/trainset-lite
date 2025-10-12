# Trainset Lite

**Lightweight workflow management system for AI-assisted development**

Trainset Lite provides structured, phased workflows to prevent "vibe-coding" and keep complex projects on track. It uses YAML for workflow definitions, Markdown for human context, yq + bash for automation, and integrates seamlessly with AI coding assistants.

---

## Features

✅ **Phased workflows** - Break projects into clear phases with defined gates
✅ **Multi-workflow support** - Different workflows for features, bugs, docs
✅ **Story-level tracking** - Manage multiple discrete work items independently
✅ **Adaptable terminology** - Use "stories", "tasks", "lessons", or custom terms
✅ **YAML + Markdown hybrid** - Structure for machines, narrative for humans
✅ **Bash + yq automation** - Reliable state queries without grep parsing hell
✅ **AI integration** - Slash commands for Claude Code, OpenCode, and others
✅ **Minimal dependencies** - Just yq, bash, and your AI assistant

---

## Quick Start

### Installation

```bash
# Navigate to your project directory
cd your-project

# Install from local copy
bash /path/to/trainset-lite/install.sh

# Or from GitHub (once published)
curl -fsSL https://raw.githubusercontent.com/toybin/trainset-lite/main/install.sh | bash
```

The installer detects your AI platform (Claude Code, OpenCode) and sets up:
- `.trainset/` - Workflow system with templates and scripts
- `.claude/` or `.opencode/` - Platform-specific commands and context

### First Use

1. **Restart your AI CLI** to load the new slash commands

2. **Run setup:**
   ```
   /setup
   ```
   Answer the interview questions to generate your custom workflow

3. **Create your first work item:**
   ```
   /new-story "User Authentication"
   ```
   Creates a new story (or task/lesson depending on your project type)

4. **Start working:**
   ```
   /status         # See current story and progress
   /advance        # Move to next phase (when gate passes)
   /gate-check     # Assess readiness to advance
   /list-stories   # View all stories and their status
   /switch "002"   # Switch to a different story
   ```

---

## How It Works

### Stories + Workflows

Trainset Lite separates **workflows** (reusable templates) from **stories** (discrete work items):

**Workflows** define the process:
```
Phase 1: Design → Phase 2: Implement → Phase 3: Test → Phase 4: Review
├─ Gates validate each phase
├─ Reusable across multiple stories
└─ Different workflows for different work types
```

**Stories** track individual work:
```
stories/
├── 001-user-auth/       (using: feature-workflow, phase: implement)
├── 002-fix-login-bug/   (using: bugfix-workflow, phase: test)
└── 003-api-docs/        (using: docs-workflow, phase: write)
```

### The Workflow Structure

Each workflow organizes work into **phases** with **gates**:

```
Phase 1: Design
├─ Purpose: Plan architecture and approach
├─ Outputs: Design document, API contracts
└─ Gates: ✓ Design complete, ✓ Reviewed

Phase 2: Implement
├─ Purpose: Build the feature
├─ Outputs: Working code, passing tests
└─ Gates: ✓ Tests pass, ✓ Code quality

... and so on
```

### Key Files

**Project Configuration:**
- **`.trainset/hierarchy.yaml`** - Project type and terminology (story/task/lesson)
- **`.trainset/active.yaml`** - Points to currently active story
- **`.trainset/CONTEXT.md`** - Project background, architecture, constraints

**Workflow Templates** (in `.trainset/workflows/`):
- **`feature-workflow.yaml`** - Default feature development workflow
- **`bugfix-workflow.yaml`** - Bug fix workflow (optional)
- **`docs-workflow.yaml`** - Documentation workflow (optional)
- **`WORKFLOW.md`** - Narrative explanations of workflow patterns

**Story Tracking** (in `.trainset/stories/`):
- **`001-user-auth/story.yaml`** - Machine-readable state tracking
- **`001-user-auth/STORY.md`** - Human-readable context and notes
- Each story references which workflow it follows

### The Setup Process

1. **Interview** - AI asks about your project (type, tech stack, goals, terminology)
2. **Synthesis** - AI uses `template-library.md` to generate custom workflow
3. **Configuration** - Creates hierarchy.yaml with your chosen terminology
4. **Workflow Creation** - Generates default workflow in workflows/ directory
5. **First Story** - Creates example story to get you started
6. **Context Docs** - Writes WORKFLOW.md and CONTEXT.md with explanations

### Working with Stories

**Create new work:**
```bash
/new-story "Feature Name"              # Use default workflow
/new-story "Bug Fix" --workflow bugfix # Use specific workflow
/new-story "Documentation" --new       # Generate new workflow type
```

**Switch between work:**
```bash
/list-stories      # See all stories and their status
/switch "002"      # Switch to story 002
/status            # See current story's progress
```

**Progress tracking:**
- Each story has its own phase and gate progress
- Switch between stories as needed
- Multiple stories can be in progress simultaneously
- Bash scripts always operate on the active story

---

## Usage Examples

### Managing Multiple Stories

```
You: /list-stories

AI:
### All Stories

✅ **001-user-auth** (Complete)
   User Authentication System
   Workflow: feature-workflow

⏳ **002-api-endpoints** (In Progress - Phase 2/4)
   REST API Endpoints
   Workflow: feature-workflow
   Current: Implementation

📝 **003-api-docs** (Not Started)
   API Documentation
   Workflow: docs-workflow
```

### Checking Status

```
You: /status

AI:
### Current Story: 002-api-endpoints
REST API Endpoints

**Workflow:** feature-workflow
**Phase:** 2/4 - Implementation
**Purpose:** Build core API logic and endpoints

### Progress (3/5 gates completed)
✅ Design document complete
✅ Tests written and failing
✅ Core logic implemented
⏳ Integration tests passing
⏳ Code quality standards met

**Gate Status:** ❌ Not ready (2 gates remaining)

### Next Steps
- Fix failing integration tests
- Run lint and type checks
```

### Creating Different Work Types

```
You: /new-story "Fix Login Timeout" --workflow bugfix

AI:
Created story: 003-fix-login-timeout
Workflow: bugfix-workflow (3 phases: Reproduce → Fix → Verify)
Status: Phase 1 - Reproduce Bug

You can now /switch to this story or continue with current work.
```

### Switching Between Stories

```
You: /switch "003"

AI:
Switched to story: 003-fix-login-timeout
Fix Login Timeout

**Workflow:** bugfix-workflow
**Phase:** 1/3 - Reproduce Bug
**Status:** Just started

Ready to reproduce the issue with a minimal test case.
```

---

## Supported Platforms

| Platform | Slash Commands | Auto-Install | Agent Context |
|----------|----------------|--------------|---------------|
| **Claude Code** | ✅ | ✅ | `.claude/CLAUDE.md` |
| **OpenCode** | ✅ | ✅ | `.opencode/rules.md` |
| **Gemini / Cursor / Other** | ❌ | Manual | `TRAINSET.md` |

For platforms without slash commands, use bash scripts directly:
```bash
bash .trainset/scripts/new-story.sh "Story Name"      # Create new story
bash .trainset/scripts/list-stories.sh                # List all stories
bash .trainset/scripts/switch-story.sh 002            # Switch active story
bash .trainset/scripts/status.sh                      # Show current story progress
bash .trainset/scripts/validate-gate.sh               # Check if ready to advance
bash .trainset/scripts/advance-phase.sh               # Move to next phase
bash .trainset/scripts/update-gate.sh gate_id true    # Mark gate complete
```

**Note:** All scripts require `yq` to be installed. Scripts operate on the currently active story.

---

## Project Types & Terminology

Trainset Lite adapts to your domain with appropriate terminology:

### Development Projects
- **Work items called:** Stories or Tasks
- **Workflows:** Feature development, bug fixes, refactoring
- **Example:** Building REST API with separate stories for auth, endpoints, docs

### Learning Projects
- **Work items called:** Lessons or Exercises
- **Workflows:** Study, practice, reflection
- **Example:** Learning React with separate lessons for components, hooks, state

### Documentation Projects
- **Work items called:** Sections or Articles
- **Workflows:** Outline, write, review, publish
- **Example:** API documentation with sections for each endpoint group

### Research Projects
- **Work items called:** Experiments or Investigations
- **Workflows:** Hypothesis, research, experiment, analyze
- **Example:** Data analysis with separate experiments for each approach

Each template includes:
- Domain-specific phase patterns
- Appropriate gate criteria
- Relevant command examples
- Terminology that fits your domain

See `template-library.md` for the complete pattern library.

---

## Architecture

### Multi-Workflow Story Architecture

Trainset Lite uses a **workflow-as-template** model:

**Workflows** (reusable templates):
- Stored in `.trainset/workflows/`
- Define phases, gates, and commands
- Can have multiple workflows per project
- Examples: feature-workflow, bugfix-workflow, docs-workflow

**Stories** (discrete work items):
- Stored in `.trainset/stories/` (or tasks/, lessons/, etc.)
- Each story references a workflow
- Tracks individual progress through workflow phases
- Multiple stories can use the same workflow

**Hybrid YAML + Markdown:**

**YAML files** (machine-readable, yq-queryable):
- `workflow.yaml` - Workflow template definitions
- `story.yaml` - Individual story state tracking
- `hierarchy.yaml` - Project configuration and terminology

**Markdown files** (human-readable, git-friendly):
- `WORKFLOW.md` - Explain workflow patterns and philosophy
- `STORY.md` - Context, decisions, notes for each story
- `CONTEXT.md` - Overall project background

**Benefits:**
- ✅ Reusable workflows across multiple work items
- ✅ Different workflow types for different work (features vs bugs vs docs)
- ✅ Adaptable terminology for your domain
- ✅ Bash scripts query YAML reliably with yq
- ✅ Humans read Markdown for understanding
- ✅ Both files diff cleanly in git
- ✅ Natural upgrade path to Trainset Full (same structure!)

### Repository Structure

**Trainset Lite repository:**
```
trainset-lite/
├── install.sh                  # Installation script
├── README.md                   # This file
├── QUICKSTART.md               # Step-by-step guide
├── .trainset/
│   └── template-library.md     # Workflow patterns for synthesis
├── schema/                     # YAML schema examples
│   ├── hierarchy.yaml          # Project config schema
│   ├── workflow.yaml           # Workflow template schema
│   └── story.yaml              # Story state schema
├── scripts/                    # Bash + yq automation
│   ├── init-workflow.sh        # Initial setup
│   ├── new-story.sh            # Create new story
│   ├── list-stories.sh         # List all stories
│   ├── switch-story.sh         # Change active story
│   ├── status.sh               # Query active story status
│   ├── validate-gate.sh        # Check gate readiness
│   ├── advance-phase.sh        # Move to next phase
│   └── update-gate.sh          # Mark gates complete
├── commands/                   # Slash command templates
│   └── system/                 # Workflow commands
└── agents/                     # Platform-specific context
    ├── claude.md               # Claude Code
    └── opencode.md             # OpenCode
```

**Your project after setup:**
```
your-project/
├── .trainset/
│   ├── hierarchy.yaml          # Project type and terminology
│   ├── active.yaml             # Currently active story
│   ├── CONTEXT.md              # Project background
│   ├── workflows/              # Workflow templates
│   │   ├── feature-workflow.yaml
│   │   ├── bugfix-workflow.yaml
│   │   └── WORKFLOW.md
│   └── stories/                # Individual work items
│       ├── 001-user-auth/
│       │   ├── story.yaml
│       │   └── STORY.md
│       └── 002-api-endpoints/
│           ├── story.yaml
│           └── STORY.md
└── .claude/ or .opencode/      # Platform integration
```

---

## Why Trainset Lite?

### The Problem

When building complex projects with AI assistance, it's easy to:
- Make architectural decisions incrementally without planning ("vibe-coding")
- Lose track of what's done and what's left
- Skip important steps like testing or documentation
- Lack clear criteria for when a phase is "complete"

### The Solution

Trainset Lite provides:
- **Structure** - Clear phases prevent skipping important work
- **Gates** - Explicit criteria for advancement prevent technical debt
- **Story-level tracking** - Add work items as you go, don't get locked into initial workflow
- **Multiple workflows** - Different processes for features, bugs, docs, experiments
- **Flexibility** - Workflows are guidance, not rigid enforcement
- **AI-native** - Designed for AI-assisted development workflows

### Design Philosophy

- **YAML + Markdown hybrid** - Structure for automation, prose for understanding
- **Workflow-as-template** - Reusable processes, not one-off definitions
- **Story-level granularity** - Manage discrete work items independently
- **Adaptable terminology** - Use words that fit your domain, not imposed jargon
- **yq + bash over Python** - Ubiquitous tools, minimal dependencies
- **Guidance over enforcement** - Help, don't constrain
- **Domain-specific** - Adapt to project needs, not generic process
- **Upgrade path** - Same YAML structure as Trainset Full

---

## Documentation

- **Quick Start:** `QUICKSTART.md` - Step-by-step first project guide
- **Template Library:** `.trainset/template-library.md` - Workflow patterns for synthesis
- **YAML Schemas:** `schema/` - hierarchy.yaml, workflow.yaml, and story.yaml examples
- **Bash Scripts:** `scripts/README.md` - Script documentation and yq usage
- **Installation:** `INSTALL.md` - Detailed installation for all platforms

---

## Contributing

Contributions welcome! Areas of interest:

- Additional workflow templates (data science, mobile dev, etc.)
- Interview questions for new domains
- Platform integrations (new AI assistants)
- Bash script improvements
- Documentation and examples

---

## License

MIT License - see `LICENSE` file

---

## Roadmap

**Trainset Lite** (this project):
- ✅ Core workflow system
- ✅ Multi-workflow support
- ✅ Story-level tracking
- ✅ Adaptable terminology
- ✅ Bash automation scripts
- ✅ Claude Code / OpenCode integration
- 🚧 Additional templates and patterns
- 🚧 Community workflows repository

**Trainset Full** (separate project):
- Python CLI with full automation
- Same YAML structure as Lite (easy migration!)
- Multi-level hierarchy (Initiative > Epic > Story)
- Automated gate execution
- State machine management
- DFS bubble-up behavior

---

## Getting Help

- **Issues:** [GitHub Issues](https://github.com/toybin/trainset-lite/issues)
- **Discussions:** [GitHub Discussions](https://github.com/toybin/trainset-lite/discussions)
- **Documentation:** All docs in this repository

---

**Start building structured projects today:**

```bash
bash /path/to/trainset-lite/install.sh
```
