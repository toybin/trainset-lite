#!/usr/bin/env bash
set -e

echo "🚀 Installing Trainset Lite..."
echo ""

# Detect AI platform
PLATFORM=""
COMMAND_DIR=""
AGENT_FILE=""

if [[ -d ".opencode" ]]; then
    PLATFORM="opencode"
    COMMAND_DIR=".opencode/command"
    AGENT_FILE=".opencode/rules.md"
elif [[ -d ".claude" ]]; then
    PLATFORM="claude"
    COMMAND_DIR=".claude/commands"
    AGENT_FILE=".claude/CLAUDE.md"
else
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
            COMMAND_DIR=".opencode/command"
            AGENT_FILE=".opencode/rules.md"
            mkdir -p ".opencode"
            ;;
        2)
            PLATFORM="claude"
            COMMAND_DIR=".claude/commands"
            AGENT_FILE=".claude/CLAUDE.md"
            mkdir -p ".claude"
            ;;
        3)
            PLATFORM="other"
            AGENT_FILE="TRAINSET.md"
            echo "✓ Will create TRAINSET.md in project root"
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
cp "$SCRIPT_DIR/template-library.md" .trainset/ 2>/dev/null || true
cp "$SCRIPT_DIR/README.md" .trainset/ 2>/dev/null || true
cp "$SCRIPT_DIR/BASH_HELPERS.md" .trainset/ 2>/dev/null || true

echo "  • scripts/ (bash helpers)"
echo "  • commands/ (command templates)"
echo "  • interviews/ (setup questions)"
echo "  • templates/ (workflow examples)"
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
    echo "   /status      - Show current phase and progress"
    echo "   /advance     - Move to next phase (validates gates)"
    echo "   /gate-check  - Assess readiness to advance"
    echo "   /context     - Show project context"
    echo "   /setup       - Initialize new workflow"
elif [[ "$PLATFORM" == "other" ]]; then
    echo "📋 Next steps:"
    echo "   1. Read $AGENT_FILE for workflow instructions"
    echo "   2. Run: bash .trainset/scripts/create-workflow.sh"
    echo "   3. Run: bash .trainset/scripts/create-context.sh"
    echo "   4. Run: bash .trainset/scripts/create-progress.sh"
    echo "   5. Fill in [FILL IN] placeholders in generated files"
    echo "   6. Start working!"
    echo ""
    echo "🔧 Available scripts:"
    echo "   bash .trainset/scripts/status.sh"
    echo "   bash .trainset/scripts/validate-gate.sh"
    echo "   bash .trainset/scripts/advance-phase.sh"
fi

echo ""
echo "📖 Documentation: .trainset/README.md"
echo "🔧 Scripts: .trainset/scripts/"
echo "🎯 Template library: .trainset/template-library.md"
echo ""
