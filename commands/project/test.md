---
description: Run project tests
---

# Test Command

**Command:** `[TEST_COMMAND]`

**Purpose:** Execute the project's test suite to validate functionality.

## When to Use

- **During Implementation:** Validate code as you write it
- **Before Advancing Phases:** Ensure current work doesn't break existing functionality  
- **Gate Validation:** Many phases require tests to pass before advancement
- **Debugging:** Isolate issues and verify fixes

## Interpreting Output

### ✅ All Tests Pass
- **Meaning:** Current code meets defined requirements
- **Next Steps:** Continue with current work or consider advancing phase
- **Gate Status:** Testing gates likely satisfied

### ❌ Tests Fail
- **Meaning:** Code doesn't meet requirements or new bugs introduced
- **Next Steps:** 
  1. Review failure details
  2. Fix failing code
  3. Re-run tests
  4. Consider if new tests needed
- **Gate Status:** Cannot advance until resolved

### ⚠️ Mixed Results
- **Meaning:** Some functionality works, some doesn't
- **Next Steps:** Prioritize critical failures, fix systematically
- **Gate Status:** Depends on phase requirements

## Common Test Commands by Technology

**JavaScript/Node.js:**
- `npm test` - Run test suite
- `npm run test:watch` - Run tests in watch mode
- `npm run test:coverage` - Run with coverage report

**Python:**
- `pytest` - Run all tests
- `pytest tests/` - Run specific directory
- `pytest --cov=.` - Run with coverage
- `python -m pytest -v` - Verbose output

**Go:**
- `go test ./...` - Run all tests
- `go test -v ./...` - Verbose output
- `go test -cover ./...` - With coverage

**Rust:**
- `cargo test` - Run all tests
- `cargo test --verbose` - Detailed output

## Integration with Workflow

**Phase-Specific Usage:**
- **Design Phase:** Run existing tests to ensure no regressions
- **Implementation Phase:** Run frequently during development
- **Validation Phase:** Comprehensive test run before completion
- **Polish Phase:** Final test pass before considering work done

**Gate Integration:**
- Many workflow gates require "all tests passing"
- Use `/gate-check` to validate test requirements
- Consider test coverage requirements for quality gates

## Troubleshooting

**Tests won't run:**
- Check if test dependencies installed
- Verify test command syntax
- Ensure test files exist and are properly named

**Tests suddenly failing:**
- Recent code changes may have introduced bugs
- Dependencies might have changed
- Environment setup issues

**Slow tests:**
- Consider running subset of tests during development
- Use watch mode for immediate feedback
- Optimize test performance if needed