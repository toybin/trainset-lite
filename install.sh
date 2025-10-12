#!/usr/bin/env bash
set -e

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --platform)
      TRAINSET_PLATFORM="$2"
      shift 2
      ;;
    --help)
      echo "Trainset Lite Installer"
      echo ""
      echo "Usage: bash install.sh [--platform claude|opencode|other]"
      echo ""
      echo "Options:"
      echo "  --platform PLATFORM    Set platform (claude, opencode, or other)"
      echo "  --help                 Show this help message"
      echo ""
      echo "Environment Variables:"
      echo "  TRAINSET_PLATFORM      Alternative to --platform flag"
      echo ""
      echo "Examples:"
      echo "  bash install.sh --platform claude"
      echo "  TRAINSET_PLATFORM=claude bash install.sh"
      echo "  curl -fsSL https://raw.githubusercontent.com/.../install.sh | TRAINSET_PLATFORM=claude bash"
      echo ""
      exit 0
      ;;
    *)
      echo "❌ Unknown option: $1"
      echo "   Run 'bash install.sh --help' for usage"
      exit 1
      ;;
  esac
done

echo "🚀 Installing Trainset Lite..."
echo ""

# Validate TRAINSET_PLATFORM if provided
if [[ -n "$TRAINSET_PLATFORM" ]]; then
  case "$TRAINSET_PLATFORM" in
    claude|opencode|other)
      # Valid platform
      ;;
    *)
      echo "❌ Invalid TRAINSET_PLATFORM: $TRAINSET_PLATFORM"
      echo "   Must be: claude, opencode, or other"
      echo ""
      exit 1
      ;;
  esac
fi

# Detect AI platform or use provided value
PLATFORM="${TRAINSET_PLATFORM:-}"
COMMAND_DIR=""
AGENT_FILE=""

if [[ -z "$PLATFORM" ]]; then
  # Try auto-detection
  if [[ -d ".opencode" ]]; then
      PLATFORM="opencode"
  elif [[ -d ".claude" ]]; then
      PLATFORM="claude"
  fi
fi

# If still no platform, check if we can prompt
if [[ -z "$PLATFORM" ]]; then
  # Check if we have a TTY (interactive terminal)
  if [[ ! -t 0 ]]; then
    echo "❌ Non-interactive mode requires --platform or TRAINSET_PLATFORM"
    echo ""
    echo "Usage:"
    echo "  bash install.sh --platform claude"
    echo "  TRAINSET_PLATFORM=claude bash install.sh"
    echo ""
    echo "For curl | bash installation:"
    echo "  curl -fsSL https://raw.githubusercontent.com/.../install.sh | TRAINSET_PLATFORM=claude bash"
    echo ""
    exit 1
  fi

  # Interactive mode - prompt user
  echo "⚠️  No AI platform detected"
  echo ""
  echo "Which platform are you using?"
  echo "  1) OpenCode (.opencode/)"
  echo "  2) Claude Code (.claude/)"
  echo "  3) Other (Gemini, Cursor, etc.)"
  echo "  4) Skip installation"
  echo ""
  read -p "Enter choice (1-4): " choice

  case $choice in
      1)
          PLATFORM="opencode"
          ;;
      2)
          PLATFORM="claude"
          ;;
      3)
          PLATFORM="other"
          ;;
      4)
          PLATFORM="manual"
          echo "⏭️  Skipping installation"
          echo ""
          echo "📋 Manual installation:"
          echo "   Copy this directory to your project:"
          echo "   cp -r trainset-lite/.trainset your-project/.trainset"
          echo ""
          exit 0
          ;;
      *)
          echo "❌ Invalid choice"
          exit 1
          ;;
  esac
fi

# Set platform-specific paths
case $PLATFORM in
  opencode)
    COMMAND_DIR=".opencode/command"
    AGENT_FILE=".opencode/rules.md"
    mkdir -p ".opencode"
    ;;
  claude)
    COMMAND_DIR=".claude/commands"
    AGENT_FILE=".claude/CLAUDE.md"
    mkdir -p ".claude"
    ;;
  other)
    AGENT_FILE="TRAINSET.md"
    ;;
esac

echo "✓ Platform: $PLATFORM"
echo ""

# Create .trainset directory if it doesn't exist
if [[ ! -d ".trainset" ]]; then
    mkdir -p .trainset
    echo "✓ Created .trainset/ directory"
else
    echo "✓ .trainset/ directory exists"
fi

# Get script directory (where trainset-lite is installed)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy trainset-lite contents to .trainset/
echo "✓ Copying template system..."
cp -r "$SCRIPT_DIR/scripts" .trainset/ 2>/dev/null || true
cp -r "$SCRIPT_DIR/commands" .trainset/ 2>/dev/null || true
cp -r "$SCRIPT_DIR/interviews" .trainset/ 2>/dev/null || true
cp -r "$SCRIPT_DIR/templates" .trainset/ 2>/dev/null || true
cp -r "$SCRIPT_DIR/agents" .trainset/ 2>/dev/null || true
cp -r "$SCRIPT_DIR/schema" .trainset/ 2>/dev/null || true
cp "$SCRIPT_DIR/template-library.md" .trainset/ 2>/dev/null || true
cp "$SCRIPT_DIR/README.md" .trainset/ 2>/dev/null || true

echo "  • scripts/ (bash helpers)"
echo "  • commands/ (command templates)"
echo "  • interviews/ (setup questions)"
echo "  • templates/ (workflow examples)"
echo "  • schema/ (YAML schemas)"
echo "  • agents/ (platform context)"
echo "  • documentation files"

# Install platform-specific agent file
echo ""
echo "✓ Installing agent context file..."
case $PLATFORM in
    opencode)
        mkdir -p "$(dirname "$AGENT_FILE")"
        cp .trainset/agents/opencode.md "$AGENT_FILE"
        echo "  • $AGENT_FILE"
        ;;
    claude)
        mkdir -p "$(dirname "$AGENT_FILE")"
        cp .trainset/agents/claude.md "$AGENT_FILE"
        echo "  • $AGENT_FILE"
        ;;
    other)
        cp .trainset/agents/gemini.md "$AGENT_FILE"
        echo "  • $AGENT_FILE (root directory)"
        ;;
esac

# Install commands if platform supports them
if [[ "$PLATFORM" == "opencode" ]] || [[ "$PLATFORM" == "claude" ]]; then
    echo ""
    echo "✓ Installing commands to $COMMAND_DIR..."
    mkdir -p "$COMMAND_DIR"
    cp .trainset/commands/system/*.md "$COMMAND_DIR/"
    echo "  • status.md → /status"
    echo "  • advance.md → /advance"
    echo "  • gate-check.md → /gate-check"
    echo "  • context.md → /context"
    echo "  • setup.md → /setup"
    echo "  • new-story.md → /new-story"
    echo "  • list-stories.md → /list-stories"
    echo "  • switch.md → /switch"
fi

# Make scripts executable
chmod +x .trainset/scripts/*.sh

echo ""
echo "✅ Trainset Lite installed successfully!"
echo ""
echo "📦 Installed files:"
echo "   • .trainset/ - Workflow system"
echo "   • $AGENT_FILE - Agent context"
if [[ "$PLATFORM" == "opencode" ]] || [[ "$PLATFORM" == "claude" ]]; then
    echo "   • $COMMAND_DIR/ - Slash commands"
fi

echo ""
if [[ "$PLATFORM" == "opencode" ]] || [[ "$PLATFORM" == "claude" ]]; then
    echo "📋 Next steps:"
    echo "   1. Restart your AI CLI to load new commands"
    echo "   2. Run: /setup"
    echo "   3. Answer the interview questions"
    echo "   4. Start working with your custom workflow!"
    echo ""
    echo "💬 Available commands:"
    echo "   /status        - Show current story and progress"
    echo "   /advance       - Move to next phase (validates gates)"
    echo "   /gate-check    - Assess readiness to advance"
    echo "   /context       - Show project context"
    echo "   /setup         - Initialize new workflow"
    echo "   /new-story     - Create new story/task/lesson"
    echo "   /list-stories  - List all stories"
    echo "   /switch        - Switch active story"
elif [[ "$PLATFORM" == "other" ]]; then
    echo "📋 Next steps:"
    echo "   1. Read $AGENT_FILE for workflow instructions"
    echo "   2. Run: bash .trainset/scripts/init-workflow.sh"
    echo "   3. Answer interview questions"
    echo "   4. AI will synthesize custom workflow"
    echo "   5. Start working!"
    echo ""
    echo "🔧 Available scripts:"
    echo "   bash .trainset/scripts/new-story.sh \"Story Name\""
    echo "   bash .trainset/scripts/list-stories.sh"
    echo "   bash .trainset/scripts/switch-story.sh 001"
    echo "   bash .trainset/scripts/status.sh"
    echo "   bash .trainset/scripts/validate-gate.sh"
    echo "   bash .trainset/scripts/advance-phase.sh"
    echo "   bash .trainset/scripts/update-gate.sh gate_id true"
fi

echo ""
echo "📖 Documentation: .trainset/README.md"
echo "🔧 Scripts: .trainset/scripts/"
echo "🎯 Template library: .trainset/template-library.md"
echo ""
