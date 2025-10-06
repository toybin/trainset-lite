---
description: Check code quality and style
---

# Lint Command

**Command:** `[LINT_COMMAND]`

**Purpose:** Analyze code for style, quality, and potential issues.

## When to Use

- **During Implementation:** Catch issues early in development
- **Before Code Review:** Ensure code meets project standards
- **Gate Validation:** Quality gates often require clean lint results
- **Refactoring:** Verify improvements don't introduce new issues

## Interpreting Output

### ✅ No Issues Found
- **Meaning:** Code meets project style and quality standards
- **Next Steps:** Continue development or consider advancing phase
- **Gate Status:** Quality gates likely satisfied

### ⚠️ Warnings Found
- **Meaning:** Code works but could be improved
- **Next Steps:** 
  1. Review warnings for legitimacy
  2. Fix important issues
  3. Consider suppressing false positives
- **Gate Status:** Depends on project standards

### ❌ Errors Found
- **Meaning:** Code has style violations or potential bugs
- **Next Steps:**
  1. Fix errors systematically
  2. Re-run linter
  3. Consider auto-fix options if available
- **Gate Status:** Must resolve before advancing

## Common Lint Commands by Technology

**JavaScript/TypeScript:**
- `eslint .` - Lint all files
- `eslint --fix .` - Auto-fix issues where possible
- `prettier --check .` - Check formatting
- `prettier --write .` - Auto-format files

**Python:**
- `ruff check .` - Fast linting (modern)
- `flake8` - Traditional linting
- `black --check .` - Check formatting
- `black .` - Auto-format
- `mypy .` - Type checking

**Go:**
- `golangci-lint run` - Comprehensive linting
- `go fmt ./...` - Format code
- `go vet ./...` - Basic static analysis

**Rust:**
- `cargo clippy` - Lint and suggestions
- `cargo fmt --check` - Check formatting
- `cargo fmt` - Auto-format

## Integration with Workflow

**Phase-Specific Usage:**
- **Implementation Phase:** Run frequently to maintain quality
- **Review Phase:** Comprehensive check before completion
- **Polish Phase:** Final cleanup pass

**Quality Gates:**
- Code style standards maintained
- No critical warnings or errors
- Consistent formatting applied

## Auto-Fix Strategy

**When to auto-fix:**
- Formatting issues (spacing, indentation)
- Import organization
- Simple style violations

**When to fix manually:**
- Logic or design suggestions
- Complex refactoring recommendations
- Issues that might change behavior

## Troubleshooting

**Linter not found:**
- Install linting tools (`npm install`, `pip install`, etc.)
- Check PATH configuration
- Verify project dependencies

**Too many false positives:**
- Configure linter rules in config file
- Add suppression comments for legitimate exceptions
- Adjust rules to match project standards

**Conflicting tools:**
- Ensure formatters and linters are compatible
- Use integrated tools when possible (e.g., ruff for Python)
- Configure tools to work together