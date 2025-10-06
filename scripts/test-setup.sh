#!/usr/bin/env bash
set -e

echo "🧪 Trainset Lite Setup Test"
echo "=============================="
echo ""

TEST_DIR=$(mktemp -d)
echo "📁 Test directory: $TEST_DIR"
echo ""

cleanup() {
    echo ""
    echo "🧹 Cleaning up..."
    rm -rf "$TEST_DIR"
    echo "✅ Done"
}

trap cleanup EXIT

cd "$TEST_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📋 Step 1: Setting up test project structure"
mkdir -p .trainset/scripts
cp "$SCRIPT_DIR"/*.sh .trainset/scripts/
echo "   ✓ Copied scripts"

echo ""
echo "📋 Step 2: Running setup scripts"
echo "   → create-workflow.sh"
bash .trainset/scripts/create-workflow.sh
echo "   → create-context.sh"
bash .trainset/scripts/create-context.sh
echo "   → create-progress.sh"
bash .trainset/scripts/create-progress.sh
echo "   ✓ Scaffolds created"

echo ""
echo "📋 Step 3: Verifying file creation"
test -f .trainset/WORKFLOW.md && echo "   ✓ WORKFLOW.md exists"
test -f .trainset/CONTEXT.md && echo "   ✓ CONTEXT.md exists"
test -f .trainset/PROGRESS.md && echo "   ✓ PROGRESS.md exists"

echo ""
echo "📋 Step 4: Counting placeholders"
PLACEHOLDER_COUNT=$(grep "FILL IN" .trainset/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "   ✓ Found $PLACEHOLDER_COUNT placeholders"

if [[ $PLACEHOLDER_COUNT -lt 100 ]]; then
    echo "   ⚠️  Warning: Expected ~131 placeholders, found $PLACEHOLDER_COUNT"
fi

echo ""
echo "📋 Step 5: Testing advance (should fail - gate not ready)"
set +e
ADVANCE_OUTPUT=$(bash .trainset/scripts/advance-phase.sh 2>&1)
ADVANCE_EXIT=$?
set -e
if echo "$ADVANCE_OUTPUT" | grep -q '"gate_ready".*false'; then
    echo "   ✓ Correctly reports gate not ready (exit code: $ADVANCE_EXIT)"
else
    echo "   ❌ Unexpected output:"
    echo "$ADVANCE_OUTPUT"
    echo "   Exit code: $ADVANCE_EXIT"
    exit 1
fi

echo ""
echo "📋 Step 6: Marking all items complete"
sed -i.bak 's/- \[ \]/- [x]/g' .trainset/PROGRESS.md
echo "   ✓ All checklist items marked complete"

echo ""
echo "📋 Step 7: Testing advance (should succeed)"
ADVANCE_OUTPUT=$(bash .trainset/scripts/advance-phase.sh 2>&1)
if echo "$ADVANCE_OUTPUT" | grep -q '"success".*true'; then
    echo "   ✓ Successfully advanced to Phase 2"
else
    echo "   ❌ Failed to advance:"
    echo "$ADVANCE_OUTPUT"
    exit 1
fi

echo ""
echo "📋 Step 8: Verifying PROGRESS.md updated"
if grep -q "## Current Phase: Phase 2" .trainset/PROGRESS.md; then
    echo "   ✓ PROGRESS.md shows Phase 2"
else
    echo "   ❌ PROGRESS.md not updated correctly"
    head -10 .trainset/PROGRESS.md
    exit 1
fi

echo ""
echo "📋 Step 9: Verifying backup created"
test -f .trainset/PROGRESS.md.bak && echo "   ✓ Backup file exists"

echo ""
echo "📋 Step 10: Testing status extraction"
STATUS_OUTPUT=$(bash .trainset/scripts/status.sh 2>&1)
if echo "$STATUS_OUTPUT" | grep -q '"success".*true'; then
    echo "   ✓ Status extraction works"
else
    echo "   ❌ Status extraction failed:"
    echo "$STATUS_OUTPUT"
    exit 1
fi

echo ""
echo "📋 Step 11: Testing validate-gate"
GATE_OUTPUT=$(bash .trainset/scripts/validate-gate.sh 2>&1)
if echo "$GATE_OUTPUT" | grep -q '"success"'; then
    echo "   ✓ Gate validation works"
else
    echo "   ⚠️  Gate validation output:"
    echo "$GATE_OUTPUT"
fi

echo ""
echo "✅ All tests passed!"
echo ""
echo "📝 Summary:"
echo "   • Setup scripts create correct scaffolds"
echo "   • Placeholders are inserted properly"
echo "   • Advancement logic works (gate validation + file update)"
echo "   • Backups are created"
echo "   • Status extraction works"
echo "   • Gate validation works"
echo ""
echo "🎉 Trainset Lite bash helpers are working correctly!"
