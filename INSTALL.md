# Trainset Lite Installation Guide

Trainset Lite is a lightweight workflow system for AI-assisted development. This guide covers installation across different AI platforms.

## Quick Install

### One-Line Installation

```bash
# From GitHub (once published)
curl -fsSL https://raw.githubusercontent.com/toybin/trainset-lite/main/install.sh | bash

# Or clone and install
git clone https://github.com/toybin/trainset-lite.git
cd trainset-lite
bash install.sh
```

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
- `/status` - Show progress
- `/advance` - Next phase
- `/gate-check` - Check readiness
- `/context` - Project info
- `/setup` - Initialize

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

### Force Platform

```bash
# Set environment variable
PLATFORM=claude bash install.sh
PLATFORM=opencode bash install.sh
PLATFORM=other bash install.sh
```

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
# Check bash version
bash --version  # Need 4.0+

# Test individual script
bash -x .trainset/scripts/status.sh
# -x shows debug output
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
- `.trainset/WORKFLOW.md` (your custom workflow)
- `.trainset/CONTEXT.md` (your project details)
- `.trainset/PROGRESS.md` (your progress)

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

- **Documentation:** `.trainset/README.md`
- **Bash helpers:** `.trainset/scripts/README.md`
- **Design docs:** `.trainset/BASH_HELPERS.md`
- **Template library:** `.trainset/template-library.md`

---

## Next Steps

After installation:

1. ✅ Run `/setup` (or bash equivalent)
2. ✅ Answer interview questions
3. ✅ Review generated workflow
4. ✅ Start working with `/status`
5. ✅ Advance through phases with `/advance`

Happy structured coding! 🚀
