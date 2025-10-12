#!/usr/bin/env bash
# test-story-system.sh - End-to-end test for multi-workflow story system
# Tests story creation, switching, independent progress, and completion

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
log_test() {
    echo -e "\n${BLUE}📋 Test $1${NC}"
}

log_pass() {
    echo -e "   ${GREEN}✅ PASS:${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    TESTS_RUN=$((TESTS_RUN + 1))
}

log_fail() {
    echo -e "   ${RED}❌ FAIL:${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    TESTS_RUN=$((TESTS_RUN + 1))
}

log_info() {
    echo -e "   ${YELLOW}ℹ️  INFO:${NC} $1"
}

# Setup
echo -e "${BLUE}🧪 Trainset Lite - Story System E2E Test${NC}"
echo "=========================================="
echo ""

TEST_DIR=$(mktemp -d)
echo -e "📁 Test directory: ${TEST_DIR}"
echo ""

cleanup() {
    echo ""
    echo "🧹 Cleaning up..."
    rm -rf "$TEST_DIR"
    echo ""
    echo "══════════════════════════════════════════════"
    echo -e "${BLUE}📊 Test Summary${NC}"
    echo "══════════════════════════════════════════════"
    echo "Tests run: $TESTS_RUN"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "${RED}Failed: $TESTS_FAILED${NC}"
        exit 1
    else
        echo ""
        echo -e "${GREEN}✅ All tests passed!${NC}"
        exit 0
    fi
}

# Compute paths before changing directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FIXTURE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../test-fixtures" && pwd)"

trap cleanup EXIT

cd "$TEST_DIR"

# =============================================================================
# TEST 1: Setup & Configuration
# =============================================================================
log_test "1: Setup & Configuration"

log_info "Setting up test environment..."
mkdir -p .trainset/{workflows,stories,scripts}

# Copy scripts
cp "$SCRIPT_DIR"/*.sh .trainset/scripts/ 2>/dev/null || true
chmod +x .trainset/scripts/*.sh

# Copy test fixtures
cp "$FIXTURE_DIR/hierarchy.yaml" .trainset/
cp "$FIXTURE_DIR/feature-workflow.yaml" .trainset/workflows/
cp "$FIXTURE_DIR/bugfix-workflow.yaml" .trainset/workflows/

# Verify hierarchy.yaml
if [ -f .trainset/hierarchy.yaml ]; then
    log_pass "hierarchy.yaml created"
else
    log_fail "hierarchy.yaml not found"
fi

# Verify workflow templates
if [ -f .trainset/workflows/feature-workflow.yaml ] && [ -f .trainset/workflows/bugfix-workflow.yaml ]; then
    log_pass "Workflow templates created"
else
    log_fail "Workflow templates missing"
fi

# Verify directory structure
if [ -d .trainset/stories ] && [ -d .trainset/workflows ] && [ -d .trainset/scripts ]; then
    log_pass "Directory structure valid"
else
    log_fail "Directory structure invalid"
fi

# =============================================================================
# TEST 2: Story Creation
# =============================================================================
log_test "2: Story Creation"

# Create Story 001 with default workflow
log_info "Creating Story 001 with default workflow..."
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/new-story.sh "User Authentication" 2>&1)

if echo "$OUTPUT" | grep -q '"success".*true'; then
    log_pass "Story 001 created successfully"
else
    log_fail "Story 001 creation failed: $OUTPUT"
fi

# Verify story files exist
if [ -f .trainset/stories/001-user-authentication/story.yaml ]; then
    log_pass "Story 001 story.yaml created"
else
    log_fail "Story 001 story.yaml not found"
fi

if [ -f .trainset/stories/001-user-authentication/STORY.md ]; then
    log_pass "Story 001 STORY.md created"
else
    log_fail "Story 001 STORY.md not found"
fi

# Verify active.yaml points to 001
if [ -f .trainset/active.yaml ]; then
    ACTIVE=$(yq '.active_story' .trainset/active.yaml)
    if [ "$ACTIVE" = "001-user-authentication" ]; then
        log_pass "active.yaml points to Story 001"
    else
        log_fail "active.yaml points to wrong story: $ACTIVE"
    fi
else
    log_fail "active.yaml not created"
fi

# Create Story 002 with bugfix workflow
log_info "Creating Story 002 with bugfix workflow..."
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/new-story.sh "Fix Login Timeout" --workflow bugfix-workflow 2>&1)

if echo "$OUTPUT" | grep -q '"success".*true'; then
    log_pass "Story 002 created with bugfix workflow"
else
    log_fail "Story 002 creation failed: $OUTPUT"
fi

# Verify Story 002 uses bugfix workflow
STORY_002_WORKFLOW=$(yq '.workflow' .trainset/stories/002-fix-login-timeout/story.yaml)
if [ "$STORY_002_WORKFLOW" = "bugfix-workflow" ]; then
    log_pass "Story 002 uses bugfix workflow"
else
    log_fail "Story 002 uses wrong workflow: $STORY_002_WORKFLOW"
fi

# =============================================================================
# TEST 3: Story Listing
# =============================================================================
log_test "3: Story Listing"

OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/list-stories.sh 2>&1)

if echo "$OUTPUT" | grep -q '"success".*true'; then
    log_pass "list-stories.sh runs successfully"
else
    log_fail "list-stories.sh failed: $OUTPUT"
fi

# Verify shows 2 stories
STORY_COUNT=$(echo "$OUTPUT" | grep -o '"count"[[:space:]]*:[[:space:]]*[0-9]*' | grep -o '[0-9]*')
if [ "$STORY_COUNT" = "2" ]; then
    log_pass "list-stories.sh shows 2 stories"
else
    log_fail "list-stories.sh shows $STORY_COUNT stories (expected 2)"
fi

# Verify active story marked
if echo "$OUTPUT" | grep -q '"is_active".*true'; then
    log_pass "Active story marked in list"
else
    log_fail "Active story not marked"
fi

# =============================================================================
# TEST 4: Story Switching
# =============================================================================
log_test "4: Story Switching"

# Switch to Story 001
log_info "Switching to Story 001..."
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/switch-story.sh 001 2>&1)

if echo "$OUTPUT" | grep -q '"success".*true'; then
    log_pass "Switched to Story 001"
else
    log_fail "Switch to Story 001 failed: $OUTPUT"
fi

# Verify active.yaml updated
ACTIVE=$(yq '.active_story' .trainset/active.yaml)
if [ "$ACTIVE" = "001-user-authentication" ]; then
    log_pass "active.yaml updated to Story 001"
else
    log_fail "active.yaml shows: $ACTIVE"
fi

# Run status, confirm shows Story 001
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/status.sh 2>&1)
if echo "$OUTPUT" | grep -q '"slug".*"001-user-authentication"'; then
    log_pass "status.sh shows Story 001"
else
    log_fail "status.sh doesn't show correct story"
fi

# Switch to Story 002
log_info "Switching to Story 002..."
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/switch-story.sh 002 2>&1)

if echo "$OUTPUT" | grep -q '"success".*true'; then
    log_pass "Switched to Story 002"
else
    log_fail "Switch to Story 002 failed"
fi

# =============================================================================
# TEST 5: Gate Operations (Story 001)
# =============================================================================
log_test "5: Gate Operations (Story 001)"

# Switch back to Story 001
TRAINSET_DIR=.trainset bash .trainset/scripts/switch-story.sh 001 >/dev/null 2>&1

# Mark first gate complete
log_info "Marking gates complete for Story 001..."
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/update-gate.sh design_complete true 2>&1)

if echo "$OUTPUT" | grep -q '"success".*true'; then
    log_pass "Gate design_complete marked true"
else
    log_fail "update-gate.sh failed: $OUTPUT"
fi

# Verify gate status in story.yaml
GATE_STATUS=$(yq '.gate_status.design_complete' .trainset/stories/001-user-authentication/story.yaml)
if [ "$GATE_STATUS" = "true" ]; then
    log_pass "Gate status updated in story.yaml"
else
    log_fail "Gate status not updated: $GATE_STATUS"
fi

# Mark second gate complete
TRAINSET_DIR=.trainset bash .trainset/scripts/update-gate.sh requirements_clear true >/dev/null 2>&1

# Run validate-gate (should be ready)
set +e
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/validate-gate.sh 2>&1)
GATE_EXIT=$?
set -e

if [ $GATE_EXIT -eq 0 ] && echo "$OUTPUT" | grep -q '"gate_ready".*true'; then
    log_pass "validate-gate.sh reports gate ready"
else
    log_fail "validate-gate.sh reports gate not ready"
fi

# Verify stats recalculated
GATES_PASSED=$(yq '.stats.gates_passed' .trainset/stories/001-user-authentication/story.yaml)
if [ "$GATES_PASSED" = "2" ]; then
    log_pass "Stats recalculated (2 gates passed)"
else
    log_fail "Stats incorrect: $GATES_PASSED gates passed"
fi

# =============================================================================
# TEST 6: Phase Advancement (Story 001)
# =============================================================================
log_test "6: Phase Advancement (Story 001)"

log_info "Advancing Story 001 to Phase 2..."
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/advance-phase.sh 2>&1)

if echo "$OUTPUT" | grep -q '"success".*true'; then
    log_pass "Story 001 advanced to Phase 2"
else
    log_fail "Advancement failed: $OUTPUT"
fi

# Verify current phase updated
CURRENT_PHASE=$(yq '.progress.current_phase' .trainset/stories/001-user-authentication/story.yaml)
if [ "$CURRENT_PHASE" = "implement" ]; then
    log_pass "Story 001 current_phase is 'implement'"
else
    log_fail "Story 001 current_phase is '$CURRENT_PHASE'"
fi

# Verify backup created
if [ -f .trainset/stories/001-user-authentication/story.yaml.bak ]; then
    log_pass "Backup created before advancement"
else
    log_fail "No backup file created"
fi

# Verify phases_completed updated
PHASES_COMPLETED=$(yq '.stats.phases_completed' .trainset/stories/001-user-authentication/story.yaml)
if [ "$PHASES_COMPLETED" = "1" ]; then
    log_pass "phases_completed stat updated"
else
    log_fail "phases_completed is $PHASES_COMPLETED (expected 1)"
fi

# Run status, confirm Phase 2
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/status.sh 2>&1)
if echo "$OUTPUT" | grep -q '"phase_number".*2'; then
    log_pass "status.sh shows Phase 2"
else
    log_fail "status.sh doesn't show Phase 2"
fi

# =============================================================================
# TEST 7: Independent Progress (Story 002)
# =============================================================================
log_test "7: Independent Progress (Story 002)"

# Switch to Story 002
log_info "Switching to Story 002..."
TRAINSET_DIR=.trainset bash .trainset/scripts/switch-story.sh 002 >/dev/null 2>&1

# Verify Story 002 still in Phase 1
CURRENT_PHASE=$(yq '.progress.current_phase' .trainset/stories/002-fix-login-timeout/story.yaml)
if [ "$CURRENT_PHASE" = "reproduce" ]; then
    log_pass "Story 002 still in Phase 1 (independent from Story 001)"
else
    log_fail "Story 002 phase is '$CURRENT_PHASE' (expected 'reproduce')"
fi

# Mark Story 002 gates complete
log_info "Marking gates complete for Story 002..."
TRAINSET_DIR=.trainset bash .trainset/scripts/update-gate.sh bug_reproduced true >/dev/null 2>&1
TRAINSET_DIR=.trainset bash .trainset/scripts/update-gate.sh test_written true >/dev/null 2>&1

# Advance Story 002
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/advance-phase.sh 2>&1)
if echo "$OUTPUT" | grep -q '"success".*true'; then
    log_pass "Story 002 advanced to Phase 2"
else
    log_fail "Story 002 advancement failed"
fi

# Verify Story 001 unchanged
STORY_001_PHASE=$(yq '.progress.current_phase' .trainset/stories/001-user-authentication/story.yaml)
if [ "$STORY_001_PHASE" = "implement" ]; then
    log_pass "Story 001 unchanged (still in Phase 2)"
else
    log_fail "Story 001 changed unexpectedly: $STORY_001_PHASE"
fi

# =============================================================================
# TEST 8: Story Completion
# =============================================================================
log_test "8: Story Completion"

# Switch to Story 001
TRAINSET_DIR=.trainset bash .trainset/scripts/switch-story.sh 001 >/dev/null 2>&1

# Complete remaining gates for Story 001 Phase 2
log_info "Completing Story 001..."
TRAINSET_DIR=.trainset bash .trainset/scripts/update-gate.sh code_complete true >/dev/null 2>&1
TRAINSET_DIR=.trainset bash .trainset/scripts/update-gate.sh tests_passing true >/dev/null 2>&1

# Advance to completion
set +e
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/advance-phase.sh 2>&1)
ADVANCE_EXIT=$?
set -e

if [ $ADVANCE_EXIT -eq 0 ] && echo "$OUTPUT" | grep -q '"story_completed".*true'; then
    log_pass "Story 001 marked as completed"
else
    log_fail "Story completion failed: $OUTPUT"
fi

# Verify status is "completed"
STORY_STATUS=$(yq '.metadata.status' .trainset/stories/001-user-authentication/story.yaml)
if [ "$STORY_STATUS" = "completed" ]; then
    log_pass "Story 001 status is 'completed'"
else
    log_fail "Story 001 status is '$STORY_STATUS'"
fi

# Try to advance again (should fail gracefully)
set +e
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/advance-phase.sh 2>&1)
ADVANCE_EXIT=$?
set -e

if [ $ADVANCE_EXIT -eq 0 ] && echo "$OUTPUT" | grep -q '"final_phase".*true'; then
    log_pass "Cannot advance beyond final phase (correct)"
else
    log_fail "Should prevent advancement beyond final phase"
fi

# =============================================================================
# TEST 9: Error Handling
# =============================================================================
log_test "9: Error Handling"

# Test invalid story ID
set +e
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/switch-story.sh 999 2>&1)
EXIT_CODE=$?
set -e

if [ $EXIT_CODE -eq 1 ] && echo "$OUTPUT" | grep -q '"success".*false'; then
    log_pass "Invalid story ID handled gracefully"
else
    log_fail "Invalid story ID should fail"
fi

# Test missing workflow file
rm .trainset/workflows/feature-workflow.yaml
set +e
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/status.sh 2>&1)
EXIT_CODE=$?
set -e

if [ $EXIT_CODE -eq 1 ] && echo "$OUTPUT" | grep -q "Workflow not found"; then
    log_pass "Missing workflow file handled gracefully"
else
    log_fail "Missing workflow should error gracefully"
fi

# Restore workflow file for cleanup
cp "$FIXTURE_DIR/feature-workflow.yaml" .trainset/workflows/

# Test missing active.yaml
rm .trainset/active.yaml
set +e
OUTPUT=$(TRAINSET_DIR=.trainset bash .trainset/scripts/status.sh 2>&1)
EXIT_CODE=$?
set -e

if [ $EXIT_CODE -eq 1 ] && echo "$OUTPUT" | grep -q "No active story"; then
    log_pass "Missing active.yaml handled gracefully"
else
    log_fail "Missing active.yaml should error"
fi

# Cleanup will run via trap
