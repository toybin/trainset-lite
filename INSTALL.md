# Trainset Lite Installation Guide

Trainset Lite is a lightweight workflow system for AI-assisted development. This guide covers installation across different AI platforms.

## Prerequisites

**Required:**
- **yq** - YAML/TOML query tool for parsing workflow files
  - macOS: `brew install yq`
  - Linux: `wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq && chmod +x /usr/local/bin/yq`
  - Or see: https://github.com/mikefarah/yq#install

**Optional:**
- bash 4.0+ (usually pre-installed)
- git (for version control of workflow files)

## Quick Install

### One-Line Installation

```bash
# From GitHub (interactive mode - will prompt for platform)
curl -fsSL https://raw.githubusercontent.com/toybin/trainset-lite/main/install.sh | bash

# Non-interactive with platform specified
curl -fsSL https://raw.githubusercontent.com/toybin/trainset-lite/main/install.sh | TRAINSET_PLATFORM=claude bash
curl -fsSL https://raw.githubusercontent.com/toybin/trainset-lite/main/install.sh | TRAINSET_PLATFORM=opencode bash
curl -fsSL https://raw.githubusercontent.com/toybin/trainset-lite/main/install.sh | TRAINSET_PLATFORM=other bash

# Or clone and install
git clone https://github.com/toybin/trainset-lite.git
cd trainset-lite
bash install.sh --platform claude
```

**Note:** The installer will check for `yq` and warn if not found.

### What Gets Installed

```
your-project/
├── .trainset/              # Workflow system
│   ├── scripts/           # Bash helpers
│   ├── commands/          # Command templates
│   ├── interviews/        # Setup questions
│   ├── templates/         # Examples
│   └── agents/            # Platform configs
├── .opencode/             # OpenCode (if detected)
│   ├── command/          # Slash commands
│   └── rules.md          # Agent context
├── .claude/               # Claude Code (if detected)
│   ├── commands/         # Slash commands
│   └── CLAUDE.md         # Agent memory
└── TRAINSET.md            # Other platforms
```

---

## Platform-Specific Installation

### OpenCode

**Auto-detection:** Script detects `.opencode/` directory

**What gets installed:**
- Commands → `.opencode/command/`
- Agent context → `.opencode/rules.md`
- Workflow system → `.trainset/`

**Usage:**
```bash
# After installation, restart OpenCode
# Then run:
/setup
```

**Available commands:**
- `/status` - Show current story progress
- `/advance` - Move to next phase
- `/gate-check` - Check readiness to advance
- `/context` - Show project context
- `/setup` - Initialize new workflow
- `/new-story` - Create new story/task/lesson
- `/list-stories` - List all stories
- `/switch` - Switch active story

---

### Claude Code

**Auto-detection:** Script detects `.claude/` directory

**What gets installed:**
- Commands → `.claude/commands/`
- Agent memory → `.claude/CLAUDE.md`
- Workflow system → `.trainset/`

**User-level commands (optional):**
```bash
# Install to ~/.claude/commands/ for all projects
mkdir -p ~/.claude/commands
cp .trainset/commands/system/* ~/.claude/commands/
```

**Usage:**
```bash
# After installation, restart Claude Code
# Then run:
/setup
```

**Available commands:**
Same as OpenCode (supports subdirectories too)

---

### Gemini / Cursor / Other Platforms

**Manual selection:** Choose option 3 during installation

**What gets installed:**
- Workflow system → `.trainset/`
- Instructions → `TRAINSET.md` (root)

**Usage:**
```bash
# Create workflow files
bash .trainset/scripts/create-workflow.sh
bash .trainset/scripts/create-context.sh
bash .trainset/scripts/create-progress.sh

# Fill in [FILL IN] placeholders
# Then use bash helpers directly:
bash .trainset/scripts/status.sh
bash .trainset/scripts/advance-phase.sh
```

**Note:** No slash commands, but all bash helpers work the same.

---

### GitHub Copilot CLI

**Not directly supported** - Copilot CLI doesn't support custom commands

**Workaround:**
- Install for "Other platforms"
- Use bash helpers directly
- Consider creating shell aliases:
  ```bash
  alias ts-status='bash .trainset/scripts/status.sh'
  alias ts-advance='bash .trainset/scripts/advance-phase.sh'
  alias ts-gate='bash .trainset/scripts/validate-gate.sh'
  ```

---

## Installation Options

### Interactive Mode

```bash
bash install.sh
# Follow prompts to select platform
```

### Specify Platform

Three methods to specify platform:

**Method 1: Command-line flag**
```bash
bash install.sh --platform claude
bash install.sh --platform opencode
bash install.sh --platform other
```

**Method 2: Environment variable**
```bash
TRAINSET_PLATFORM=claude bash install.sh
TRAINSET_PLATFORM=opencode bash install.sh
TRAINSET_PLATFORM=other bash install.sh
```

**Method 3: For curl | bash (non-interactive)**
```bash
curl -fsSL https://raw.githubusercontent.com/.../install.sh | TRAINSET_PLATFORM=claude bash
```

All methods are equivalent - use whichever is most convenient.

### Skip Installation

```bash
# Option 4 during interactive mode
# Shows manual instructions
```

---

## Post-Installation

### 1. Restart AI CLI

**OpenCode / Claude Code:**
```bash
# Restart to load new commands
# Commands appear in autocomplete
```

### 2. Run Setup

**With slash commands:**
```
/setup
```

**Without slash commands:**
```bash
bash .trainset/scripts/create-workflow.sh
bash .trainset/scripts/create-context.sh
bash .trainset/scripts/create-progress.sh
# Then fill in [FILL IN] placeholders
```

### 3. Verify Installation

**Check files exist:**
```bash
ls -la .trainset/
ls -la .trainset/scripts/
```

**Test bash helpers:**
```bash
bash .trainset/scripts/status.sh
# Should return JSON or error if workflow not setup
```

---

## Troubleshooting

### Commands Not Appearing

**OpenCode:**
- Restart the CLI completely
- Check `.opencode/command/` has .md files
- Verify frontmatter syntax

**Claude Code:**
- Restart Claude Code
- Check `.claude/commands/` has .md files
- Try user-level install: `~/.claude/commands/`

### Permission Errors

```bash
# Make scripts executable
chmod +x .trainset/scripts/*.sh
```

### Wrong Platform Detected

```bash
# Remove wrong directory
rm -rf .opencode  # or .claude

# Re-run install
bash install.sh
# Select correct platform
```

### Scripts Not Working

```bash
# Check yq is installed
yq --version
# Should show: yq (https://github.com/mikefarah/yq/) version X.X.X

# Install yq if missing
brew install yq  # macOS
# or see https://github.com/mikefarah/yq#install

# Check bash version
bash --version  # Need 4.0+

# Test individual script
bash -x .trainset/scripts/status.sh
# -x shows debug output
```

### yq Not Found Error

If you see `yq not found` errors:

```bash
# Install yq
brew install yq  # macOS with Homebrew

# Or download binary (Linux)
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo mv yq_linux_amd64 /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq

# Verify installation
yq --version
```

---

## Updating Trainset Lite

### Pull Latest Changes

```bash
cd /path/to/trainset-lite
git pull origin main

# Re-run install
bash install.sh
```

### Preserve Your Workflow

Your workflow files are safe:
- `.trainset/workflow.yaml` (your workflow definition)
- `.trainset/state.yaml` (your progress state)
- `.trainset/WORKFLOW.md` (narrative explanations)
- `.trainset/CONTEXT.md` (project details)
- `.trainset/INTERVIEW.md` (interview responses)

Scripts/commands are updated, but your data remains.

---

## Uninstalling

```bash
# Remove workflow system
rm -rf .trainset/

# Remove platform files
rm -rf .opencode/command/  # OpenCode
rm -rf .claude/commands/   # Claude Code
rm .opencode/rules.md      # OpenCode context
rm .claude/CLAUDE.md       # Claude memory
rm TRAINSET.md             # Other platforms
```

---

## Platform Comparison

| Feature | OpenCode | Claude Code | GitHub Copilot | Other |
|---------|----------|-------------|----------------|-------|
| Slash commands | ✅ | ✅ | ❌ | ❌ |
| Agent context | ✅ rules.md | ✅ CLAUDE.md | ❌ | ✅ TRAINSET.md |
| Bash helpers | ✅ | ✅ | ✅ | ✅ |
| Auto-detect | ✅ | ✅ | N/A | Manual |
| User-level | ❌ | ✅ ~/.claude | N/A | N/A |

---

## Getting Help

- **Documentation:** `README.md` (root of repo)
- **Quick Start:** `QUICKSTART.md`
- **Bash scripts:** `.trainset/scripts/README.md`
- **Template library:** `.trainset/template-library.md`
- **YAML schemas:** `schema/workflow.yaml` and `schema/state.yaml`

---

## Next Steps

After installation:

1. ✅ Run `/setup` (or bash equivalent)
2. ✅ Answer interview questions
3. ✅ Review generated workflow
4. ✅ Start working with `/status`
5. ✅ Advance through phases with `/advance`

Happy structured coding! 🚀
