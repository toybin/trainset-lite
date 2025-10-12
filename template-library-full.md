# Trainset Full Template Library

**Purpose:** Scannable patterns for synthesizing workflow.toml and hierarchy.toml. Read this to understand structure, then generate TOML. CLI will create placeholders, then read targeted examples for content.

---

## Table of Contents

1. [Overview](#overview)
2. [TOML Structure Reference](#toml-structure-reference)
3. [Hierarchy Patterns](#hierarchy-patterns)
4. [Phase Patterns](#phase-patterns)
5. [Gate Patterns](#gate-patterns)
6. [Command Patterns](#command-patterns)
7. [Composition Rules](#composition-rules)
8. [Naming Examples](#naming-examples)
9. [Complete Examples](#complete-examples)

---

## 1. Overview

### What This Library Is For

This template library teaches you how to generate **workflow.toml** and **hierarchy.toml** files for Trainset Full. Unlike Trainset Lite (which uses markdown workflows), Trainset Full uses a **two-pass generation system**:

**Pass 1: Structure (You are here)**
1. Read this template library to learn TOML patterns
2. Generate workflow.toml (phases, gates, commands) and hierarchy.toml (work structure)
3. CLI validates TOML structure

**Pass 2: Content (Happens next)**
1. CLI reads your TOML files
2. CLI generates placeholder files following document schemas (phase.md, gate.sh, principles.md)
3. You read targeted examples (only the specific phase/gate types you used)
4. You fill in placeholder content

### Two-Pass Generation Flow

```
Interview → project-context.md
    ↓
Read template library (this document)
    ↓
Generate workflow.toml + hierarchy.toml (structure only)
    ↓
CLI validates TOML
    ↓
CLI generates placeholders with schemas
    ↓
Read targeted examples (specific to your phases/gates)
    ↓
Fill in content
    ↓
Done!
```

### Why This Approach?

**Progressive disclosure:** You make structural decisions (what phases? what gates?) without drowning in implementation details. Then you focus on content when you have clear scaffolding.

**Targeted learning:** You only read examples for the specific phase/gate types you're using, not every possible pattern.

**Enforced consistency:** CLI ensures every phase in TOML has a corresponding .md file, every gate has a .sh file.

### How to Use This Document

**Step 1:** Read section 2 (TOML Structure Reference) to understand the file formats

**Step 2:** Skim sections 3-8 to see available patterns

**Step 3:** Look at section 9 (Complete Examples) to see how patterns combine

**Step 4:** Generate your workflow.toml and hierarchy.toml based on the project interview

**Remember:** You're creating TOML structure now, not writing phase instructions or gate scripts. That comes after CLI validation.

---

## 2. TOML Structure Reference

### workflow.toml Anatomy

A workflow.toml file defines the phases, gates, and commands for completing work. Here's the complete structure:

```toml
# ============================================================================
# METADATA SECTION
# ============================================================================
[metadata]
name = "workflow-name-slug"           # Slug for directory name
title = "Human Readable Workflow Name"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

# ============================================================================
# COMMANDS SECTION - User-facing commands (NOT gates)
# ============================================================================
[commands]
# These map to CLI commands like `trainset test --json`
# Adapt to your tech stack
test = "pytest --tb=short --cov=."           # Python
# test = "go test ./... -v -cover"           # Go
# test = "npm test"                          # JavaScript

lint = "ruff check ."                        # Python
# lint = "golangci-lint run"                 # Go
# lint = "eslint src/"                       # JavaScript

build = "python -m build"                    # Python
# build = "go build -o bin/app ./cmd/app"    # Go
# build = "npm run build"                    # JavaScript

# Add domain-specific commands as needed
run = "python main.py"
deploy = "bash scripts/deploy.sh"

# ============================================================================
# PHASES SECTION - Sequential workflow steps
# ============================================================================
# Each phase is an array element using [[phase]]
# Phases execute in the order defined here

[[phase]]
id = "phase_id_20_to_45_chars_required"      # MUST be 20-45 chars, domain-specific
name = "Short Name"                           # Display name
description = "One-line purpose"              # What this phase accomplishes
gates = ["gate_id_1", "gate_id_2"]           # List of gate IDs (can be empty [])

[[phase]]
id = "another_phase_with_descriptive_name"
name = "Another Phase"
description = "What this phase does"
gates = ["gate_id_3"]

# Typically 4-6 phases per workflow
# Use descriptive names that indicate WHAT you're doing in THIS domain

# ============================================================================
# GATES SECTION - Validation requirements
# ============================================================================
# Each gate is a TOML table: [gates.gate_id]
# Gates block phase advancement until they pass (exit code 0)

[gates.gate_id_1]
type = "automated"                            # "automated" or "interactive"
description = "What this gate validates"
script = "check-something.sh"                 # Relative to .trainset/workflows/workflow-name/gates/

[gates.gate_id_2]
type = "automated"
description = "Another validation"
script = "check-another-thing.sh"

[gates.gate_id_3]
type = "interactive"                          # Prompts user for confirmation
description = "Human approval required"
script = "prompt-approval.sh"

# Gates are bash scripts that exit 0 (pass) or 1 (fail)
# Self-contained, no external dependencies beyond project commands
```

### hierarchy.toml Anatomy

A hierarchy.toml file defines how work is organized. Choose depth based on project complexity:

**Single-level (simple projects):**
```toml
type = "work"              # "work", "learning", or "documentation"
levels = ["story"]         # Just one level

[level.story]
singular = "story"
plural = "stories"
workflow_required = true   # Must have a workflow to track progress
```

**Two-level (medium projects):**
```toml
type = "work"
levels = ["epic", "story"]  # Epic contains Stories

[level.epic]
singular = "epic"
plural = "epics"
workflow_required = false   # Optional - can add coordination workflow if needed

[level.story]
singular = "story"
plural = "stories"
workflow_required = true    # Stories do the actual work
parent_level = "epic"       # Stories belong to Epics
```

**Three-level (large projects):**
```toml
type = "work"
levels = ["initiative", "epic", "story"]

[level.initiative]
singular = "initiative"
plural = "initiatives"
workflow_required = false   # Optional - can add planning workflow if needed

[level.epic]
singular = "epic"
plural = "epics"
workflow_required = false   # Optional - can add coordination workflow if needed
parent_level = "initiative"

[level.story]
singular = "story"
plural = "stories"
workflow_required = true    # Required at leaf level
parent_level = "epic"
```

### Hierarchy Types

**Work hierarchies:**
- Levels: `["initiative", "epic", "story"]`
- Use case: Software development, features, projects
- Workflows: Stories always have workflows; Epics/Initiatives optionally have coordination/planning workflows

**Learning hierarchies:**
- Levels: `["course", "module", "lesson"]`
- Use case: Educational content, skill acquisition
- Workflows: Lessons have learning workflows; Modules/Courses optionally have meta-learning workflows

**Documentation hierarchies:**
- Levels: `["series", "guide", "section"]`
- Use case: Technical documentation, tutorials
- Workflows: Sections have writing workflows; Guides/Series optionally have editorial workflows

### Workflows at Different Hierarchy Levels

**Leaf level (Story/Lesson/Section):** Workflow required
- Phases like: design → implement → test → review
- Gates validate actual work completion

**Parent level (Epic/Module/Guide):** Workflow optional
- If used, phases like: scope → coordinate → review
- Gates validate child completion, dependencies, retrospectives
- Advances via DFS bubble-up when all children complete

**Top level (Initiative/Course/Series):** Workflow optional
- If used, phases like: vision → plan → execute → assess
- Gates validate strategic goals, roadmap alignment
- Advances when all child Epics/Modules/Guides complete

---

### Built-In Minimal Coordination Workflow

**Key principle:** Every hierarchy level requires a workflow. There is no "no workflow" option.

For parent levels (Epic/Initiative/Module/Guide) that don't need custom coordination logic, Trainset provides a built-in minimal workflow that automatically advances when all children complete.

**`minimal-coordination-workflow`** (shipped with Trainset):

```toml
[metadata]
name = "minimal-coordination-workflow"
title = "Minimal Coordination (DFS Completion)"
version = "1.0.0"

[commands]
# No commands needed

[[phase]]
id = "coordinate_children_until_complete"
name = "Coordinate"
description = "Track child item completion and dependencies"
gates = ["all_children_complete"]

[gates.all_children_complete]
type = "automated"
description = "All child items have completed their workflows"
script = "check-children-complete.sh"  # Built-in CLI validation
```

**When to use:**
- Parent level needs no custom phases (just DFS completion)
- No explicit coordination work required
- Simple "bubble up when children finish" behavior

**hierarchy.toml configuration:**
```toml
[level.epic]
singular = "epic"
plural = "epics"
workflow_required = true  # Always true - every level needs a workflow
default_workflow = "minimal-coordination-workflow"  # Use built-in by default
```

**When creating an epic:**
```bash
trainset new epic auth-system
# Uses minimal-coordination-workflow automatically
```

**epic.toml will contain:**
```toml
# Metadata
id = "001-auth-system"
title = "Authentication System"
workflow = "minimal-coordination-workflow"
parent_initiative = "..."
created_at = "2025-10-05T10:00:00Z"

# State
current_phase = "coordinate_children_until_complete"
phases_complete = []
completed = false

# Gate status
[gates.coordinate_children_until_complete]
all_children_complete = false
```

**Upgrade to custom workflow:**
If you need custom coordination phases (scope → coordinate → retrospective), specify a custom workflow:
```bash
trainset new epic auth-system --workflow epic-coordination-workflow
```

**Benefits:**
- **Consistent architecture:** All items have workflows/phases/gates structure
- **Clean DFS logic:** No special-casing for "no workflow"
- **Flexible:** Can upgrade to custom workflow when needed
- **Simple default:** Most parent items don't need custom workflows

---

### Item State File Structure

Every item (story, epic, initiative, lesson, module, etc.) has a single TOML file containing both metadata and state:

**Location:** `.trainset/stories/003-login-flow/story.toml`

**Contents:**
```toml
# Metadata (set at creation, rarely changes)
id = "003-login-flow"
title = "User Login Flow"
workflow = "tdd-workflow"                    # Which workflow blueprint to use
parent_epic = "002-authentication"           # Bottom-up reference to parent
created_at = "2025-10-05T10:00:00Z"

# State (changes as work progresses)
current_phase = "implement_code_to_pass_test_suite"
phases_complete = ["design_data_models_and_api_contracts", "write_failing_tests_for_api_behavior"]
completed = false

# Gate status per phase
[gates.write_failing_tests_for_api_behavior]
tests_exist_and_fail_appropriately = true

[gates.implement_code_to_pass_test_suite]
all_tests_passing_with_coverage = false
```

**Key points:**
- **Single file per item** (not separate metadata + state files)
- **Workflow reference** tells CLI which blueprint to follow
- **Gate status** tracked per phase as boolean values
- **Bottom-up parent references** (child knows parent, not vice versa)
- **Phases complete** array tracks progress through workflow

**Same structure for all hierarchy levels:**
- `.trainset/stories/{id}/story.toml`
- `.trainset/epics/{id}/epic.toml`
- `.trainset/initiatives/{id}/initiative.toml`
- `.trainset/lessons/{id}/lesson.toml`
- etc.

---

### active.toml as Tree Path

active.toml maintains the current path from leaf to root, making it easy to understand full context and traverse the hierarchy:

**For three-level hierarchy:**
```toml
[active]
initiative = "001-user-management"      # Root
epic = "002-authentication"              # Branch
story = "003-login-flow"                 # Leaf (current work)
```

**For two-level hierarchy:**
```toml
[active]
epic = "002-authentication"
story = "003-login-flow"
```

**For single-level hierarchy:**
```toml
[active]
story = "003-login-flow"
```

**Benefits:**
- **Full context** available at a glance
- **DFS traversal** simplified (already have path)
- **Breadcrumb display** for CLI/UI
- **Parent lookup** immediate (no searching)

---

### active.toml Anatomy

Created automatically by CLI during setup. Tracks currently active work items:

```toml
[active]
story = "001-feature-name"        # Currently active story ID
workflow = "workflow-name"         # Workflow being used

[state]
initialized = true
setup_complete = true
```

### Naming Rules

**Critical constraint:** Phase IDs and gate IDs MUST be 20-45 characters long.

**Why?** Forces domain specificity. Prevents generic names like "design" or "test".

**Examples:**

✓ Good (20-45 chars, specific):
- `create_rest_api_endpoint_specifications` (38 chars)
- `implement_user_authentication_logic` (35 chars)
- `write_comprehensive_failing_tests` (35 chars)

✗ Bad (too short, too generic):
- `design` (6 chars)
- `implement` (9 chars)
- `test_phase` (10 chars)

✗ Bad (too long):
- `implement_the_complete_user_authentication_system_with_oauth_and_session_management` (83 chars)

**Validation:** CLI will reject phase/gate IDs outside the 20-45 character range.

**Exception:** Commands in `[commands]` section can be short (`test`, `lint`, `build`) because they're user-facing and brevity matters for CLI ergonomics.

---

## 3. Hierarchy Patterns

### When to Use Single-Level

**Use case:** Simple projects with straightforward scope

**Characteristics:**
- All work items are equivalent (just "stories" or "lessons")
- No need for grouping or coordination
- Fast iteration, minimal overhead

**Example scenarios:**
- Personal side project (building a small tool)
- Learning a new technology (work through tutorials)
- Documentation for a single feature

**hierarchy.toml:**
```toml
type = "work"
levels = ["story"]

[level.story]
singular = "story"
plural = "stories"
workflow_required = true
```

**Workflow approach:**
- Single workflow for all stories
- Focus on execution: design → implement → validate → done
- No coordination overhead

---

### When to Use Two-Level

**Use case:** Medium complexity with natural groupings

**Characteristics:**
- Work clusters into logical groups (epics, modules, guides)
- Parent level for coordination, child level for execution
- Balance structure with agility

**Example scenarios:**
- Feature development with multiple related stories
- Course with distinct modules
- Documentation series with multiple guides

**hierarchy.toml:**
```toml
type = "work"
levels = ["epic", "story"]

[level.epic]
singular = "epic"
plural = "epics"
workflow_required = false    # Optional coordination workflow

[level.story]
singular = "story"
plural = "stories"
workflow_required = true
parent_level = "epic"
```

**Workflow approaches:**

**Option A: Stories only**
- Stories have execution workflow (design → implement → test → review)
- Epic completes when all stories complete (DFS bubble-up)
- No explicit Epic workflow

**Option B: Stories + Epic coordination**
- Stories have execution workflow
- Epic has coordination workflow:
  - `define_epic_scope_and_story_breakdown`
  - `track_story_dependencies_and_blockers`
  - `conduct_epic_retrospective_review`
- Epic gates validate coordination, dependencies, outcomes

---

### When to Use Three-Level

**Use case:** Large initiatives requiring strategic planning

**Characteristics:**
- Multiple layers of coordination
- Strategic (Initiative) → Tactical (Epic) → Execution (Story)
- Suitable for long-running projects with multiple teams or quarters

**Example scenarios:**
- Major product initiative spanning months
- Complete curriculum design (course → modules → lessons)
- Multi-guide documentation series

**hierarchy.toml:**
```toml
type = "work"
levels = ["initiative", "epic", "story"]

[level.initiative]
singular = "initiative"
plural = "initiatives"
workflow_required = false    # Optional strategic planning workflow

[level.epic]
singular = "epic"
plural = "epics"
workflow_required = false    # Optional coordination workflow
parent_level = "initiative"

[level.story]
singular = "story"
plural = "stories"
workflow_required = true
parent_level = "epic"
```

**Workflow approaches:**

**Option A: Stories only**
- Only Stories have workflows
- Epics and Initiatives complete via DFS bubble-up
- Minimal overhead, maximum execution focus

**Option B: Full hierarchy workflows**
- **Stories:** Execution workflow (design → implement → test → review)
- **Epics:** Coordination workflow (scope → coordinate → retrospective)
- **Initiatives:** Strategic workflow (vision → plan → monitor → assess)
- Gates at each level validate appropriate concerns

---

### Work Hierarchy Patterns

**Standard work hierarchy:**
```toml
type = "work"
levels = ["initiative", "epic", "story"]

[level.initiative]
singular = "initiative"
plural = "initiatives"
workflow_required = false

[level.epic]
singular = "epic"
plural = "epics"
workflow_required = false
parent_level = "initiative"

[level.story]
singular = "story"
plural = "stories"
workflow_required = true
parent_level = "epic"
```

**Typical workflows by level:**
- **Story:** `design_feature_architecture` → `implement_core_functionality` → `write_integration_tests` → `conduct_code_review`
- **Epic (optional):** `define_epic_scope_and_acceptance` → `coordinate_story_dependencies` → `validate_epic_completion_criteria`
- **Initiative (optional):** `establish_initiative_vision_goals` → `plan_epic_breakdown_and_roadmap` → `assess_initiative_success_metrics`

---

### Learning Hierarchy Patterns

**Standard learning hierarchy:**
```toml
type = "learning"
levels = ["course", "module", "lesson"]

[level.course]
singular = "course"
plural = "courses"
workflow_required = false

[level.module]
singular = "module"
plural = "modules"
workflow_required = false
parent_level = "course"

[level.lesson]
singular = "lesson"
plural = "lessons"
workflow_required = true
parent_level = "module"
```

**Typical workflows by level:**
- **Lesson:** `review_learning_objectives_materials` → `complete_practice_exercises_examples` → `reflect_on_understanding_and_gaps`
- **Module (optional):** `set_module_learning_goals_context` → `track_lesson_completion_progress` → `synthesize_module_key_takeaways`
- **Course (optional):** `define_course_outcomes_prerequisites` → `sequence_module_learning_path` → `evaluate_course_mastery_confidence`

---

### Documentation Hierarchy Patterns

**Standard documentation hierarchy:**
```toml
type = "documentation"
levels = ["series", "guide", "section"]

[level.series]
singular = "series"
plural = "series"
workflow_required = false

[level.guide]
singular = "guide"
plural = "guides"
workflow_required = false
parent_level = "series"

[level.section]
singular = "section"
plural = "sections"
workflow_required = true
parent_level = "guide"
```

**Typical workflows by level:**
- **Section:** `outline_section_content_structure` → `write_draft_with_code_examples` → `review_accuracy_and_clarity` → `publish_and_link_references`
- **Guide (optional):** `plan_guide_scope_and_audience` → `coordinate_section_dependencies` → `conduct_technical_review_feedback`
- **Series (optional):** `define_series_purpose_and_coverage` → `sequence_guide_learning_progression` → `validate_series_completeness_quality`

---

### DFS Bubble-Up Behavior

**How phases advance in hierarchies:**

1. **Leaf completes (Story/Lesson/Section):**
   - User/LLM works through workflow phases
   - Gates pass, final phase completes
   - Story/Lesson/Section marked complete

2. **Check siblings:**
   - If all siblings at same level are complete → parent can advance
   - If any sibling incomplete → parent stays in current phase

3. **Parent advances (Epic/Module/Guide):**
   - If parent has workflow: advance to next phase
   - If parent has no workflow: mark complete
   - Recurse: check parent's siblings

4. **Top-level completes (Initiative/Course/Series):**
   - When all children complete, top-level completes
   - Project/learning/documentation goal achieved

**Example:**
```
Initiative: "User Management System"
├── Epic: "Authentication" (Phase: coordinate)
│   ├── Story: "Login flow" ✓ complete
│   ├── Story: "Password reset" ✓ complete
│   └── Story: "Session management" ← working (phase: implement)
└── Epic: "Authorization" (Phase: scope)
    ├── Story: "Role-based access" ← not started
    └── Story: "Permission system" ← not started

When "Session management" completes:
→ All stories in "Authentication" epic complete
→ "Authentication" epic advances to next phase
→ Initiative stays in current phase (not all epics complete)
```

---

## 4. Phase Patterns

This section shows common phase patterns with TOML structure. Use these as starting points and adapt to your domain.

**Important:** Phase IDs should be **workflow-specific**, not task-specific. They must be reusable across multiple stories/lessons/sections that use the same workflow.

**Example of reusability:**
- ✓ `implement_core_business_logic_and_validation` - Works for any backend story (auth, payments, notifications)
- ✗ `implement_user_authentication_system` - Too specific to one story
- ✓ `write_failing_tests_for_feature_behavior` - Works for any TDD story
- ✗ `write_tests_for_login_endpoint` - Too specific to one story

Think: "Can I use this phase name for multiple different stories in this workflow?"

### Pattern: Discovery/Requirements Phase

**When to use:** Project start, need to understand problem space

**Purpose variations:**
- **Development:** Understand requirements, identify constraints
- **Learning:** Identify learning goals, assess current knowledge
- **Documentation:** Understand audience, define scope

**Example TOML (Backend API Workflow):**
```toml
[[phase]]
id = "analyze_feature_requirements_and_constraints"
name = "Analyze Requirements"
description = "Understand feature needs, data models, and integration points"
gates = ["requirements_documented_and_validated"]
```

**Example TOML (CLI Tool Workflow):**
```toml
[[phase]]
id = "define_command_interface_and_flags"
name = "Define Interface"
description = "Plan command structure, flags, and user interactions"
gates = ["interface_specification_complete"]
```

**Example TOML (Learning Workflow):**
```toml
[[phase]]
id = "identify_learning_objectives_and_gaps"
name = "Set Learning Goals"
description = "Define what to learn and assess current knowledge"
gates = ["learning_goals_clearly_defined"]
```

**Common gates:**
- Requirements/goals documented
- Constraints identified
- Scope boundaries defined
- Stakeholder alignment achieved

---

### Pattern: Architecture/Planning Phase

**When to use:** Need high-level design before detailed work

**Purpose variations:**
- **Development:** Plan system architecture, component interactions
- **Learning:** Structure learning path, identify milestones
- **Documentation:** Organize content hierarchy, define flow

**Example TOML (Backend API Workflow):**
```toml
[[phase]]
id = "design_data_models_and_api_contracts"
name = "Design Architecture"
description = "Plan data structures and API interfaces for feature"
gates = ["architecture_design_approved"]
```

**Example TOML (React Frontend Workflow):**
```toml
[[phase]]
id = "design_component_hierarchy_and_state"
name = "Design Components"
description = "Plan component structure and state management approach"
gates = ["component_architecture_validated"]
```

**Example TOML (Course Learning Workflow):**
```toml
[[phase]]
id = "structure_learning_path_and_milestones"
name = "Plan Learning Path"
description = "Sequence concepts from fundamentals to advanced"
gates = ["learning_path_logically_structured"]
```

**Common gates:**
- Architecture diagrams exist
- Major components identified
- Dependencies mapped
- Technical approach decided

---

### Pattern: Detailed Design/Specification Phase

**When to use:** Need concrete plans before implementation

**Purpose variations:**
- **Development:** Define APIs, data structures, interfaces
- **Learning:** Plan exercises, assessment methods
- **Documentation:** Create outlines, example code

**Example TOML (REST API Workflow):**
```toml
[[phase]]
id = "specify_request_response_and_validation"
name = "Specify API Details"
description = "Define schemas, validation rules, and error handling"
gates = ["api_specification_complete"]
```

**Example TOML (CLI Tool Workflow):**
```toml
[[phase]]
id = "specify_flag_parsing_and_validation"
name = "Specify Configuration"
description = "Detail flag syntax, config files, and validation rules"
gates = ["configuration_specification_complete"]
```

**Example TOML (Tutorial Creation Workflow):**
```toml
[[phase]]
id = "design_practice_exercises_and_assessments"
name = "Design Exercises"
description = "Create practice problems that reinforce concepts"
gates = ["exercises_designed_and_validated"]
```

**Common gates:**
- Interfaces/APIs defined
- Data structures specified
- Edge cases identified
- Implementation approach clear

---

### Pattern: Test-First Implementation Phase

**When to use:** TDD workflows, test-driven learning

**Purpose variations:**
- **Development:** Write failing tests that define acceptance criteria
- **Learning:** Create assessment tests before studying content
- **Documentation:** Define validation criteria for examples

**Example TOML (TDD Workflow - Any Language):**
```toml
[[phase]]
id = "write_failing_tests_for_feature_behavior"
name = "Write Failing Tests"
description = "Create test suite defining acceptance criteria"
gates = ["tests_exist_and_fail_appropriately"]
```

**Example TOML (Test-First Learning Workflow):**
```toml
[[phase]]
id = "attempt_exercises_before_studying_material"
name = "Attempt Exercises"
description = "Try problems first to identify knowledge gaps"
gates = ["exercise_attempts_reveal_gaps"]
```

**Common gates:**
- Test files exist
- Tests execute and fail (red phase)
- Coverage targets set
- Edge cases identified

---

### Pattern: Core Implementation Phase

**When to use:** Building the actual solution

**Purpose variations:**
- **Development:** Write code to implement features
- **Learning:** Study materials, complete exercises
- **Documentation:** Write content, create examples

**Example TOML (Backend API Workflow):**
```toml
[[phase]]
id = "implement_core_business_logic_layer"
name = "Implement Core Logic"
description = "Build service layer, data operations, and validation"
gates = ["core_functionality_implemented"]
```

**Example TOML (React Frontend Workflow):**
```toml
[[phase]]
id = "implement_components_with_state_management"
name = "Build Components"
description = "Create UI components with props, state, and hooks"
gates = ["components_functional_and_rendering"]
```

**Example TOML (Self-Paced Learning Workflow):**
```toml
[[phase]]
id = "study_material_and_complete_exercises"
name = "Study and Practice"
description = "Work through content and practice problems"
gates = ["exercises_completed_successfully"]
```

**Common gates:**
- Core functionality complete
- Basic requirements satisfied
- Tests passing (if TDD)
- Ready for integration/review

---

### Pattern: Integration/Composition Phase

**When to use:** Combining components, integration testing

**Purpose variations:**
- **Development:** Connect components, test interactions
- **Learning:** Apply multiple concepts together
- **Documentation:** Link sections, validate flow

**Example TOML (Full-Stack Workflow):**
```toml
[[phase]]
id = "integrate_frontend_with_backend_services"
name = "Integrate Systems"
description = "Connect UI to API endpoints and test data flow"
gates = ["integration_tests_passing"]
```

**Example TOML (Microservices Workflow):**
```toml
[[phase]]
id = "integrate_service_communication_layer"
name = "Connect Services"
description = "Implement inter-service messaging and event handling"
gates = ["service_integration_verified"]
```

**Example TOML (Project-Based Learning Workflow):**
```toml
[[phase]]
id = "build_capstone_project_applying_concepts"
name = "Build Integration Project"
description = "Apply learned concepts in comprehensive project"
gates = ["project_demonstrates_mastery"]
```

**Common gates:**
- Components work together
- Integration tests pass
- Data flows correctly
- Error handling works end-to-end

---

### Pattern: Validation/Testing Phase

**When to use:** Verify work meets requirements

**Purpose variations:**
- **Development:** Run tests, fix bugs, validate quality
- **Learning:** Assess understanding, identify gaps
- **Documentation:** Review accuracy, test examples

**Example TOML (TDD Workflow - Green Phase):**
```toml
[[phase]]
id = "validate_tests_pass_with_coverage_goals"
name = "Validate Quality"
description = "Ensure all tests pass and coverage meets standards"
gates = ["all_tests_passing_with_coverage"]
```

**Example TOML (Mastery Learning Workflow):**
```toml
[[phase]]
id = "complete_assessments_and_identify_gaps"
name = "Assess Understanding"
description = "Attempt challenges and evaluate mastery level"
gates = ["assessment_demonstrates_mastery"]
```

**Example TOML (Technical Writing Workflow):**
```toml
[[phase]]
id = "validate_code_examples_execute_correctly"
name = "Review Accuracy"
description = "Test all examples and verify technical correctness"
gates = ["examples_verified_and_accurate"]
```

**Common gates:**
- Tests passing
- Quality standards met
- Requirements validated
- Issues identified and addressed

---

### Pattern: Refinement/Polish Phase

**When to use:** Final improvements before completion

**Purpose variations:**
- **Development:** Code cleanup, documentation, performance
- **Learning:** Fill gaps, strengthen weak areas
- **Documentation:** Editing, formatting, publishing

**Example TOML (Code Quality Workflow):**
```toml
[[phase]]
id = "refactor_and_document_implementation"
name = "Polish Implementation"
description = "Clean up code, add documentation, improve readability"
gates = ["code_meets_quality_standards"]
```

**Example TOML (Performance-Focused Workflow):**
```toml
[[phase]]
id = "optimize_performance_and_resource_usage"
name = "Optimize Performance"
description = "Profile and improve speed, memory, bundle size"
gates = ["performance_targets_achieved"]
```

**Example TOML (Content Publishing Workflow):**
```toml
[[phase]]
id = "edit_and_format_content_for_publication"
name = "Final Editing"
description = "Proofread, format, and prepare for publication"
gates = ["content_ready_to_publish"]
```

**Common gates:**
- Quality standards met
- Documentation complete
- Performance acceptable
- Ready to deploy/publish

---

### Pattern: Reflection/Learning Phase

**When to use:** Learning projects, retrospectives, improvement

**Purpose variations:**
- **Development:** Code review, architectural retrospective
- **Learning:** Capture insights, plan next steps
- **Documentation:** Gather feedback, plan improvements

**Example TOML (Reflective Practice Workflow):**
```toml
[[phase]]
id = "reflect_on_approach_and_capture_learnings"
name = "Conduct Retrospective"
description = "Document what worked, what didn't, and improvements"
gates = ["retrospective_insights_documented"]
```

**Example TOML (Learning Workflow with Reflection):**
```toml
[[phase]]
id = "assess_confidence_and_plan_next_steps"
name = "Reflect on Learning"
description = "Evaluate understanding and identify areas for practice"
gates = ["learning_reflection_complete"]
```

**Example TOML (Iterative Content Workflow):**
```toml
[[phase]]
id = "collect_feedback_and_prioritize_updates"
name = "Gather Feedback"
description = "Review user comments and plan improvements"
gates = ["feedback_reviewed_and_prioritized"]
```

**Common gates:**
- Insights captured
- Learnings documented
- Improvements identified
- Next steps planned

---

### Pattern: Deployment/Release Phase

**When to use:** Shipping to production, publishing content

**Purpose variations:**
- **Development:** Deploy to production, monitor launch
- **Learning:** Publish portfolio project, share learnings
- **Documentation:** Publish to docs site, announce release

**Example TOML (Production Deployment Workflow):**
```toml
[[phase]]
id = "deploy_to_production_and_verify_health"
name = "Deploy to Production"
description = "Deploy changes, verify success, monitor stability"
gates = ["deployment_successful_and_stable"]
```

**Example TOML (Package Publishing Workflow):**
```toml
[[phase]]
id = "publish_release_and_update_changelog"
name = "Release Package"
description = "Build, publish to registry, update documentation"
gates = ["package_published_and_documented"]
```

**Example TOML (Content Publishing Workflow):**
```toml
[[phase]]
id = "publish_content_and_announce_availability"
name = "Publish Content"
description = "Deploy to production site and notify audience"
gates = ["content_live_and_announced"]
```

**Common gates:**
- Deployment successful
- Health checks passing
- Documentation updated
- Announcement sent

---

## 5. Gate Patterns

Gates are bash scripts that validate phase completion. They exit with code 0 (pass) or 1 (fail). Like phases, gate IDs should be **workflow-reusable**.

### Pattern: File Existence Check

**When to use:** Validate that required artifacts were created

**How it works:** Check if specific files/directories exist

**Example TOML:**
```toml
[gates.design_document_exists]
type = "automated"
description = "Design documentation created"
script = "check-design-exists.sh"
```

**Example bash script (`check-design-exists.sh`):**
```bash
#!/bin/bash
# Validates that design documentation exists

if [ -f "docs/design.md" ]; then
    echo "✓ Design document exists"
    exit 0
else
    echo "✗ Design document not found at docs/design.md"
    exit 1
fi
```

**Domain variations:**
- Backend: Check for schema files, API specs
- Frontend: Check for component diagrams, mockups
- Learning: Check for notes, exercise files

---

### Pattern: Command Success (Test/Lint/Build)

**When to use:** Validate that project commands pass

**How it works:** Execute command from workflow.toml [commands] section

**Example TOML:**
```toml
[gates.all_tests_passing]
type = "automated"
description = "Test suite passes with coverage"
script = "check-tests-pass.sh"
```

**Example bash script (`check-tests-pass.sh`):**
```bash
#!/bin/bash
# Validates that all tests pass

if pytest --tb=short --cov=.; then
    echo "✓ All tests passing"
    exit 0
else
    echo "✗ Tests failing"
    exit 1
fi
```

**Domain variations:**
- Python: `pytest --tb=short --cov=.`
- Go: `go test ./... -v -cover`
- JavaScript: `npm test`
- Rust: `cargo test`

**Common command gates:**
- `tests_passing` - Test suite succeeds
- `linter_passing` - Code quality checks pass
- `build_succeeds` - Project builds without errors
- `type_check_passes` - Type validation succeeds

---

### Pattern: Tests Failing (TDD Red Phase)

**When to use:** TDD workflows, validate tests exist and fail before implementation

**How it works:** Check that tests execute but fail appropriately

**Example TOML:**
```toml
[gates.tests_exist_and_fail]
type = "automated"
description = "Tests exist and fail (TDD red phase)"
script = "check-tests-failing.sh"
```

**Example bash script (`check-tests-failing.sh`):**
```bash
#!/bin/bash
# Validates tests exist and fail (TDD red phase)

# Check if test files exist
test_count=$(find . -name "*_test.go" -o -name "*_test.py" -o -name "*.test.js" | wc -l)

if [ "$test_count" -eq 0 ]; then
    echo "✗ No test files found"
    exit 1
fi

# Run tests and expect failure
if go test ./... -v 2>/dev/null; then
    echo "✗ Tests are passing (expected failure for TDD red phase)"
    exit 1
else
    echo "✓ Tests exist and fail appropriately"
    exit 0
fi
```

**Key points:**
- Validates tests were written
- Expects tests to fail (TDD red phase)
- Prevents skipping test-first step

---

### Pattern: Interactive Confirmation

**When to use:** Human approval needed, subjective quality checks

**How it works:** Prompt user for yes/no confirmation

**Example TOML:**
```toml
[gates.code_review_approved]
type = "interactive"
description = "Code reviewed and approved"
script = "prompt-code-review.sh"
```

**Example bash script (`prompt-code-review.sh`):**
```bash
#!/bin/bash
# Prompts for code review approval

echo "Code Review Checklist:"
echo "  - Code follows project conventions"
echo "  - Tests cover edge cases"
echo "  - Documentation is clear"
echo "  - No security issues identified"
echo ""
read -p "Has code review passed? (y/n): " response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "✓ Code review approved"
    exit 0
else
    echo "✗ Code review not approved"
    exit 1
fi
```

**Common interactive gates:**
- `design_approved` - Design review passed
- `ready_to_deploy` - Deployment checklist verified
- `learning_understood` - Self-assessment of understanding
- `documentation_clear` - Clarity check for content

---

### Pattern: Content Validation

**When to use:** Validate file contents, not just existence

**How it works:** Parse files, check for required sections/patterns

**Example TOML:**
```toml
[gates.design_document_complete]
type = "automated"
description = "Design document has required sections"
script = "check-design-complete.sh"
```

**Example bash script (`check-design-complete.sh`):**
```bash
#!/bin/bash
# Validates design document has required sections

design_file="docs/design.md"

if [ ! -f "$design_file" ]; then
    echo "✗ Design document not found"
    exit 1
fi

required_sections=("## Architecture" "## Data Models" "## API Endpoints" "## Error Handling")
missing=()

for section in "${required_sections[@]}"; do
    if ! grep -q "$section" "$design_file"; then
        missing+=("$section")
    fi
done

if [ ${#missing[@]} -eq 0 ]; then
    echo "✓ Design document complete"
    exit 0
else
    echo "✗ Missing sections: ${missing[*]}"
    exit 1
fi
```

**Domain variations:**
- Backend: Check for API specs, error handling
- Frontend: Check for component props, state management
- Learning: Check for reflection notes, key takeaways

---

### Pattern: Threshold Gates

**When to use:** Validate metrics meet minimum standards

**How it works:** Parse tool output, check against thresholds

**Example TOML:**
```toml
[gates.test_coverage_sufficient]
type = "automated"
description = "Test coverage meets 80% threshold"
script = "check-coverage-threshold.sh"
```

**Example bash script (`check-coverage-threshold.sh`):**
```bash
#!/bin/bash
# Validates test coverage meets threshold

threshold=80

# Run tests with coverage
coverage_output=$(pytest --cov=. --cov-report=term-missing 2>&1)

# Extract coverage percentage
coverage=$(echo "$coverage_output" | grep "TOTAL" | awk '{print $NF}' | sed 's/%//')

if [ -z "$coverage" ]; then
    echo "✗ Could not determine coverage"
    exit 1
fi

if (( $(echo "$coverage >= $threshold" | bc -l) )); then
    echo "✓ Coverage $coverage% meets threshold of $threshold%"
    exit 0
else
    echo "✗ Coverage $coverage% below threshold of $threshold%"
    exit 1
fi
```

**Common threshold gates:**
- Test coverage percentage
- Performance benchmarks (response time, load time)
- Code quality scores (complexity, maintainability)
- Error counts (lint warnings, type errors)

---

### Pattern: Multi-Gate Composition

**When to use:** Multiple validations must all pass

**How it works:** Run multiple checks, fail if any fail

**Example TOML:**
```toml
[gates.quality_checks_pass]
type = "automated"
description = "All quality checks pass (tests, lint, types)"
script = "check-all-quality.sh"
```

**Example bash script (`check-all-quality.sh`):**
```bash
#!/bin/bash
# Runs multiple quality checks

failed=0

echo "Running tests..."
if pytest --tb=short; then
    echo "✓ Tests passed"
else
    echo "✗ Tests failed"
    failed=1
fi

echo ""
echo "Running linter..."
if ruff check .; then
    echo "✓ Linter passed"
else
    echo "✗ Linter failed"
    failed=1
fi

echo ""
echo "Running type checker..."
if mypy src/; then
    echo "✓ Type checker passed"
else
    echo "✗ Type checker failed"
    failed=1
fi

if [ $failed -eq 0 ]; then
    echo ""
    echo "✓ All quality checks passed"
    exit 0
else
    echo ""
    echo "✗ Some quality checks failed"
    exit 1
fi
```

**Best practice:** Break into separate gates when possible for clearer feedback

---

### Pattern: Dependency Check

**When to use:** Validate external dependencies or prerequisites

**How it works:** Check for required tools, services, or configurations

**Example TOML:**
```toml
[gates.development_environment_ready]
type = "automated"
description = "All required tools installed and configured"
script = "check-dev-environment.sh"
```

**Example bash script (`check-dev-environment.sh`):**
```bash
#!/bin/bash
# Validates development environment is ready

missing=()

# Check for required tools
if ! command -v go &> /dev/null; then
    missing+=("go")
fi

if ! command -v golangci-lint &> /dev/null; then
    missing+=("golangci-lint")
fi

# Check for required files
if [ ! -f ".env" ]; then
    missing+=(".env file")
fi

if [ ${#missing[@]} -eq 0 ]; then
    echo "✓ Development environment ready"
    exit 0
else
    echo "✗ Missing: ${missing[*]}"
    exit 1
fi
```

**Common dependency checks:**
- Required tools installed (compilers, linters, formatters)
- Configuration files exist (.env, config.toml)
- External services available (database, API)
- Required directories present

---

### Pattern: Git Status Check

**When to use:** Validate work is committed, branch is clean

**How it works:** Check git status for uncommitted changes

**Example TOML:**
```toml
[gates.changes_committed]
type = "automated"
description = "All changes committed to git"
script = "check-git-clean.sh"
```

**Example bash script (`check-git-clean.sh`):**
```bash
#!/bin/bash
# Validates all changes are committed

if [ -z "$(git status --porcelain)" ]; then
    echo "✓ Working directory clean, all changes committed"
    exit 0
else
    echo "✗ Uncommitted changes detected:"
    git status --short
    exit 1
fi
```

**Variations:**
- Check for pushed commits
- Validate branch name follows convention
- Ensure no merge conflicts
- Verify commits follow message format

---

### Gate Naming Guidelines

**Like phases, gate IDs should be workflow-reusable:**

✓ **Good (reusable across stories):**
- `all_tests_passing_with_coverage` - Works for any feature
- `design_document_complete` - Works for any design phase
- `code_review_approved` - Works for any review

✗ **Bad (too task-specific):**
- `login_endpoint_tests_passing` - Specific to one feature
- `shopping_cart_design_approved` - Specific to one feature
- `user_auth_code_reviewed` - Specific to one feature

**Exception:** Some gates are inherently specific to phase order:
- `tests_exist_and_fail` - TDD red phase
- `tests_now_passing` - TDD green phase
- `refactoring_complete` - TDD refactor phase

---

## 6. Command Patterns

Commands map user-facing operations to bash commands. Defined in `[commands]` section of workflow.toml.

### Adapter Pattern Explanation

The `[commands]` section makes workflows tech-stack agnostic. The CLI provides generic commands (`trainset test --json`), and workflows map them to tech-specific tools.

**Example:** Three workflows, same command interface, different implementations:

```toml
# Python Backend Workflow
[commands]
test = "pytest --tb=short --cov=."

# Go CLI Workflow
[commands]
test = "go test ./... -v -cover"

# React Frontend Workflow
[commands]
test = "npm test"
```

Users run `trainset test` regardless of tech stack. Slash commands like `/test-status` work universally.

---

### Test Commands

**Python:**
```toml
test = "pytest --tb=short --cov=."
test-watch = "pytest-watch --runner 'pytest --tb=short'"
test-verbose = "pytest -vv --tb=long"
test-markers = "pytest -m integration"  # Run specific markers
```

**Go:**
```toml
test = "go test ./... -v"
test-coverage = "go test ./... -v -cover -coverprofile=coverage.out"
test-race = "go test ./... -race"  # Race condition detection
test-bench = "go test ./... -bench=."  # Benchmarks
```

**JavaScript/TypeScript:**
```toml
test = "npm test"
test-watch = "npm test -- --watch"
test-coverage = "npm test -- --coverage"
test-e2e = "npm run test:e2e"
```

**Rust:**
```toml
test = "cargo test"
test-coverage = "cargo tarpaulin --out Html --output-dir coverage"
test-integration = "cargo test --test '*'"
test-doc = "cargo test --doc"
```

**Ruby:**
```toml
test = "bundle exec rspec"
test-coverage = "bundle exec rspec --format documentation"
test-profile = "bundle exec rspec --profile"
```

---

### Lint/Format Commands

**Python:**
```toml
lint = "ruff check ."
lint-fix = "ruff check . --fix"
format = "ruff format ."
format-check = "ruff format . --check"
typecheck = "mypy src/"
```

**Go:**
```toml
lint = "golangci-lint run"
lint-fix = "golangci-lint run --fix"
format = "gofmt -w ."
format-check = "gofmt -l ."
vet = "go vet ./..."
```

**JavaScript/TypeScript:**
```toml
lint = "eslint src/"
lint-fix = "eslint src/ --fix"
format = "prettier --write src/"
format-check = "prettier --check src/"
typecheck = "tsc --noEmit"
```

**Rust:**
```toml
lint = "cargo clippy -- -D warnings"
lint-fix = "cargo clippy --fix"
format = "cargo fmt"
format-check = "cargo fmt -- --check"
```

**Ruby:**
```toml
lint = "bundle exec rubocop"
lint-fix = "bundle exec rubocop -a"
format = "bundle exec rubocop --auto-correct-all"
```

---

### Build Commands

**Python:**
```toml
build = "python -m build"
build-wheel = "python -m build --wheel"
build-sdist = "python -m build --sdist"
install = "pip install -e ."
install-prod = "pip install ."
```

**Go:**
```toml
build = "go build -o bin/app ./cmd/app"
build-release = "go build -ldflags='-s -w' -o bin/app ./cmd/app"
build-linux = "GOOS=linux GOARCH=amd64 go build -o bin/app-linux ./cmd/app"
build-windows = "GOOS=windows GOARCH=amd64 go build -o bin/app.exe ./cmd/app"
build-all = "bash scripts/build-all-platforms.sh"
```

**JavaScript/TypeScript:**
```toml
build = "npm run build"
build-prod = "NODE_ENV=production npm run build"
build-analyze = "npm run build -- --analyze"
install = "npm install"
install-clean = "rm -rf node_modules && npm install"
```

**Rust:**
```toml
build = "cargo build"
build-release = "cargo build --release"
build-target = "cargo build --target x86_64-unknown-linux-musl"
install = "cargo install --path ."
```

---

### Run/Dev Commands

**Python (Web):**
```toml
run = "python manage.py runserver"
run-prod = "gunicorn app:app --bind 0.0.0.0:8000"
dev = "python manage.py runserver --reload"
shell = "python manage.py shell"
```

**Go (CLI):**
```toml
run = "./bin/app"
run-example = "./bin/app --help && ./bin/app demo"
dev = "air"  # Live reload with Air
install = "go install"
```

**JavaScript (Frontend):**
```toml
dev = "npm run dev"
start = "npm start"
preview = "npm run preview"
serve = "npm run serve"
```

**Rust:**
```toml
run = "cargo run"
run-release = "cargo run --release"
run-example = "cargo run --example basic"
watch = "cargo watch -x run"
```

---

### Database/Migration Commands

**Python (Django):**
```toml
migrate = "python manage.py migrate"
makemigrations = "python manage.py makemigrations"
seed = "python manage.py loaddata seed.json"
reset-db = "python manage.py flush --no-input"
```

**Python (Alembic):**
```toml
migrate = "alembic upgrade head"
migrate-create = "alembic revision --autogenerate -m"
migrate-rollback = "alembic downgrade -1"
```

**Go (golang-migrate):**
```toml
migrate = "migrate -path migrations -database ${DATABASE_URL} up"
migrate-down = "migrate -path migrations -database ${DATABASE_URL} down 1"
migrate-create = "migrate create -ext sql -dir migrations"
```

**JavaScript (Prisma):**
```toml
migrate = "npx prisma migrate deploy"
migrate-dev = "npx prisma migrate dev"
migrate-reset = "npx prisma migrate reset"
seed = "npx prisma db seed"
```

---

### Deploy/Release Commands

**Docker:**
```toml
docker-build = "docker build -t app:latest ."
docker-run = "docker run -p 8000:8000 app:latest"
docker-push = "docker push app:latest"
deploy = "docker-compose up -d"
```

**Kubernetes:**
```toml
deploy = "kubectl apply -f k8s/"
deploy-staging = "kubectl apply -f k8s/ --namespace=staging"
deploy-prod = "kubectl apply -f k8s/ --namespace=production"
rollback = "kubectl rollout undo deployment/app"
```

**Serverless:**
```toml
deploy = "serverless deploy"
deploy-staging = "serverless deploy --stage staging"
deploy-prod = "serverless deploy --stage production"
logs = "serverless logs -f function-name -t"
```

**Package Registry:**
```toml
publish = "npm publish"
publish-dry = "npm publish --dry-run"
publish-tag = "npm publish --tag beta"
```

---

### Documentation Commands

```toml
docs = "mkdocs serve"
docs-build = "mkdocs build"
docs-deploy = "mkdocs gh-deploy"

# Or with Sphinx
docs = "sphinx-build -b html docs docs/_build"
docs-live = "sphinx-autobuild docs docs/_build"
```

---

### Utility Commands

```toml
clean = "rm -rf dist/ build/ *.egg-info __pycache__"
clean-cache = "find . -type d -name '__pycache__' -exec rm -rf {} +"
deps-update = "pip install --upgrade -r requirements.txt"
deps-check = "pip check"
security-check = "bandit -r src/"
coverage-report = "coverage report -m"
```

---

### Composite Commands

Commands can chain multiple operations:

```toml
# Full quality check
check = "pytest && ruff check . && mypy src/"

# Build and test
verify = "python -m build && pytest"

# Clean, install, test
fresh-test = "rm -rf .pytest_cache && pip install -e . && pytest"

# Deploy pipeline
deploy = "npm run build && npm run test && bash scripts/deploy.sh"
```

---

## 7. Composition Rules

How to combine phases and gates into complete workflows for different contexts.

### TDD Workflow Composition

**Use case:** Feature development with strict test-driven discipline

**Structure:** Design → Test-First (Red) → Implement (Green) → Refactor → Review

```toml
[[phase]]
id = "design_feature_architecture_and_approach"
name = "Design"
description = "Plan feature structure and acceptance criteria"
gates = ["design_document_complete"]

[[phase]]
id = "write_failing_tests_for_acceptance_criteria"
name = "Write Tests (Red)"
description = "Create test suite that defines behavior"
gates = ["tests_exist_and_fail_appropriately"]

[[phase]]
id = "implement_code_to_pass_test_suite"
name = "Implement (Green)"
description = "Write minimal code to make tests pass"
gates = ["all_tests_passing_with_coverage"]

[[phase]]
id = "refactor_implementation_for_quality"
name = "Refactor"
description = "Improve code quality while keeping tests green"
gates = ["code_quality_standards_met"]

[[phase]]
id = "conduct_code_review_and_finalize"
name = "Review"
description = "Peer review and final validation"
gates = ["code_review_approved"]
```

**Key characteristics:**
- Heavy upfront design
- Failing tests BEFORE implementation (enforced by gates)
- Separate refactor phase
- Multiple quality gates
- External review required

**Best for:** Production code, team environments, learning TDD discipline

---

### Exploratory/Spike Workflow Composition

**Use case:** Prototyping, research, evaluating approaches

**Structure:** Spike → Build → Validate → Decide

```toml
[[phase]]
id = "explore_problem_space_and_approaches"
name = "Explore"
description = "Research options, try different approaches"
gates = []  # No gates, maximize exploration freedom

[[phase]]
id = "build_minimal_viable_prototype"
name = "Build Prototype"
description = "Create quick proof-of-concept"
gates = ["prototype_demonstrates_feasibility"]

[[phase]]
id = "validate_prototype_with_real_scenarios"
name = "Validate"
description = "Test with realistic data and usage"
gates = ["prototype_tested_with_scenarios"]

[[phase]]
id = "document_findings_and_recommendation"
name = "Decide"
description = "Capture learnings and recommend path forward"
gates = ["findings_documented_with_decision"]
```

**Key characteristics:**
- Lightweight/no early gates (maximize exploration)
- Fast iteration encouraged
- Reality-testing with actual use cases
- Decision-making captures value
- Throwaway code acceptable

**Best for:** Technical spikes, evaluating libraries/frameworks, proof-of-concepts

---

### Simple/Rapid Workflow Composition

**Use case:** Personal projects, MVPs, "just ship it" mentality

**Structure:** Plan → Build → Ship

```toml
[[phase]]
id = "outline_features_and_basic_approach"
name = "Plan"
description = "Quick sketch of what to build"
gates = []  # Self-assessment only

[[phase]]
id = "build_working_implementation_iteratively"
name = "Build"
description = "Implement features, iterate until working"
gates = ["core_functionality_works"]

[[phase]]
id = "deploy_and_announce_availability"
name = "Ship"
description = "Deploy to production and share"
gates = ["deployed_and_accessible"]
```

**Key characteristics:**
- Minimal process overhead
- Pragmatic quality standards
- Working software is success metric
- Fast feedback loop

**Best for:** Side projects, MVPs, learning projects, solo work

---

### Learning/Tutorial Workflow Composition

**Use case:** Educational content, skill acquisition, structured learning

**Structure:** Goals → Study → Practice → Assess → Reflect

```toml
[[phase]]
id = "define_specific_learning_objectives"
name = "Set Goals"
description = "Identify what to learn and success criteria"
gates = ["learning_goals_clearly_defined"]

[[phase]]
id = "study_concepts_from_multiple_sources"
name = "Study Concepts"
description = "Read docs, watch tutorials, review examples"
gates = ["core_concepts_understood"]

[[phase]]
id = "complete_hands_on_practice_exercises"
name = "Practice"
description = "Apply concepts through exercises and projects"
gates = ["practice_exercises_completed"]

[[phase]]
id = "complete_mastery_assessment_challenges"
name = "Assess Mastery"
description = "Attempt harder problems to validate understanding"
gates = ["assessment_demonstrates_competency"]

[[phase]]
id = "reflect_on_understanding_and_gaps"
name = "Reflect"
description = "Document learnings and identify areas for growth"
gates = ["reflection_complete_with_next_steps"]
```

**Key characteristics:**
- Clear goal-setting upfront
- Multiple practice opportunities
- Self-assessment and external validation
- Reflection cements learning
- Identifies gaps for continued growth

**Best for:** Learning new technologies, course work, skill development

---

### Production/Enterprise Workflow Composition

**Use case:** Team environments, production systems, high stakes

**Structure:** Requirements → Design → Review → Implement → Test → Stage → Deploy

```toml
[[phase]]
id = "gather_and_document_requirements"
name = "Requirements"
description = "Document feature requirements with stakeholders"
gates = ["requirements_approved_by_stakeholders"]

[[phase]]
id = "design_architecture_and_implementation"
name = "Design"
description = "Create technical design and implementation plan"
gates = ["design_reviewed_by_tech_leads"]

[[phase]]
id = "conduct_design_review_with_team"
name = "Design Review"
description = "Present design, gather feedback, iterate"
gates = ["design_review_approved"]

[[phase]]
id = "implement_with_incremental_reviews"
name = "Implement"
description = "Build feature with regular code reviews"
gates = ["implementation_complete", "code_reviews_passed"]

[[phase]]
id = "execute_comprehensive_test_suite"
name = "Test"
description = "Unit, integration, E2E tests all passing"
gates = ["all_tests_passing", "coverage_meets_threshold"]

[[phase]]
id = "deploy_to_staging_and_validate"
name = "Stage"
description = "Deploy to staging, conduct QA testing"
gates = ["staging_deployment_validated"]

[[phase]]
id = "deploy_to_production_with_monitoring"
name = "Deploy"
description = "Production deployment with health monitoring"
gates = ["production_deployment_successful", "monitoring_healthy"]
```

**Key characteristics:**
- Heavy validation at each step
- Multiple stakeholder approvals
- Staging environment validation
- Production-ready quality standards
- Monitoring and observability

**Best for:** Enterprise software, critical systems, regulated industries

---

### Research/Experimentation Workflow Composition

**Use case:** Open-ended investigation, data analysis, academic research

**Structure:** Question → Research → Experiment → Analyze → Document

```toml
[[phase]]
id = "formulate_research_question_hypothesis"
name = "Question"
description = "Define research question and hypothesis"
gates = ["research_question_well_formed"]

[[phase]]
id = "conduct_literature_review_research"
name = "Research"
description = "Review existing work and gather background"
gates = ["literature_review_complete"]

[[phase]]
id = "design_and_execute_experiments"
name = "Experiment"
description = "Set up experiments and collect data"
gates = ["experiments_executed_data_collected"]

[[phase]]
id = "analyze_results_and_draw_conclusions"
name = "Analyze"
description = "Process data and interpret findings"
gates = ["analysis_complete_with_conclusions"]

[[phase]]
id = "document_methodology_and_findings"
name = "Document"
description = "Write up research with reproducible methods"
gates = ["documentation_complete_and_reviewed"]
```

**Key characteristics:**
- Hypothesis-driven
- Literature review foundation
- Reproducible methodology
- Data-driven conclusions
- Peer review validation

**Best for:** Academic research, data science, scientific computing

---

### Maintenance/Bug Fix Workflow Composition

**Use case:** Bug fixes, technical debt, refactoring

**Structure:** Reproduce → Diagnose → Fix → Verify → Document

```toml
[[phase]]
id = "reproduce_issue_with_minimal_example"
name = "Reproduce"
description = "Create minimal reproduction of the bug"
gates = ["issue_reliably_reproducible"]

[[phase]]
id = "diagnose_root_cause_with_debugging"
name = "Diagnose"
description = "Identify root cause through debugging"
gates = ["root_cause_identified"]

[[phase]]
id = "implement_fix_with_regression_test"
name = "Fix"
description = "Fix issue and add test preventing regression"
gates = ["fix_implemented_with_test"]

[[phase]]
id = "verify_fix_across_environments"
name = "Verify"
description = "Validate fix in dev, staging, production"
gates = ["fix_verified_in_all_environments"]

[[phase]]
id = "document_issue_and_resolution"
name = "Document"
description = "Update docs, add to changelog"
gates = ["resolution_documented"]
```

**Key characteristics:**
- Reproduction first (confirms understanding)
- Root cause analysis (not just symptoms)
- Regression test required
- Multi-environment verification
- Documentation for future reference

**Best for:** Bug fixes, maintenance work, production issues

---

### Composition Anti-Patterns

**❌ Too many phases (analysis paralysis):**
```toml
# 12 phases is too many - creates exhaustion
[[phase]]
id = "initial_planning"
# ... 10 more phases ...
[[phase]]
id = "final_final_review"
```
**Better:** 4-6 phases maximum

**❌ No gates anywhere (no validation):**
```toml
[[phase]]
id = "design_and_implement_everything"
gates = []  # Nothing validated!
```
**Better:** At least 1-2 gates at critical milestones

**❌ All gates on first phase (front-loaded):**
```toml
[[phase]]
id = "design_everything_perfectly"
gates = ["gate1", "gate2", "gate3", "gate4", "gate5"]

[[phase]]
id = "implement"
gates = []
```
**Better:** Distribute gates across phases

**❌ Generic phase names:**
```toml
[[phase]]
id = "phase_one_do_stuff"  # Not descriptive!
```
**Better:** Specific to workflow domain

---

## 8. Naming Examples

The 20-45 character requirement forces domain specificity and workflow thinking.

### Good Phase Names (20-45 chars)

**Backend API Development:**
- `design_data_models_and_api_contracts` (37 chars) ✓
- `implement_core_business_logic_layer` (36 chars) ✓
- `write_integration_tests_for_api` (32 chars) ✓
- `validate_api_performance_and_load` (34 chars) ✓
- `deploy_to_staging_environment` (29 chars) ✓

**Frontend React Development:**
- `design_component_hierarchy_and_state` (37 chars) ✓
- `implement_components_with_hooks` (31 chars) ✓
- `add_form_validation_and_feedback` (33 chars) ✓
- `optimize_bundle_size_and_loading` (33 chars) ✓
- `test_user_flows_and_interactions` (33 chars) ✓

**CLI Tool Development:**
- `define_command_interface_and_flags` (35 chars) ✓
- `implement_subcommand_handlers` (29 chars) ✓
- `add_configuration_file_parsing` (31 chars) ✓
- `build_cross_platform_binaries` (30 chars) ✓
- `test_cli_workflows_end_to_end` (30 chars) ✓

**Microservices Development:**
- `design_service_boundaries_and_apis` (35 chars) ✓
- `implement_inter_service_messaging` (34 chars) ✓
- `add_distributed_tracing_observability` (38 chars) ✓
- `test_service_resilience_patterns` (33 chars) ✓
- `deploy_with_canary_rollout_strategy` (37 chars) ✓

**Data Engineering:**
- `design_data_pipeline_architecture` (34 chars) ✓
- `implement_etl_transformations` (29 chars) ✓
- `validate_data_quality_and_schema` (33 chars) ✓
- `optimize_query_performance_tuning` (34 chars) ✓
- `deploy_pipeline_to_production` (30 chars) ✓

**Machine Learning:**
- `prepare_training_data_and_features` (36 chars) ✓
- `train_model_with_hyperparameter_tuning` (40 chars) ✓
- `validate_model_performance_metrics` (35 chars) ✓
- `deploy_model_with_monitoring_alerts` (36 chars) ✓
- `retrain_on_production_feedback_data` (36 chars) ✓

**Learning/Tutorial:**
- `identify_learning_goals_and_metrics` (36 chars) ✓
- `study_core_concepts_and_patterns` (33 chars) ✓
- `complete_practice_exercises_set` (32 chars) ✓
- `build_capstone_project_applying_skills` (40 chars) ✓
- `reflect_on_understanding_and_gaps` (34 chars) ✓

**Technical Documentation:**
- `outline_content_structure_and_flow` (35 chars) ✓
- `write_tutorial_with_code_examples` (34 chars) ✓
- `validate_examples_execute_correctly` (36 chars) ✓
- `gather_feedback_and_iterate_content` (36 chars) ✓
- `publish_documentation_to_site` (30 chars) ✓

---

### Good Gate Names (20-45 chars)

**Validation Gates:**
- `all_tests_passing_with_coverage` (32 chars) ✓
- `integration_tests_pass` (22 chars) ✓
- `performance_benchmarks_met` (26 chars) ✓
- `security_scan_no_vulnerabilities` (33 chars) ✓

**Design/Planning Gates:**
- `design_document_complete` (24 chars) ✓
- `architecture_reviewed_approved` (30 chars) ✓
- `api_contracts_fully_specified` (30 chars) ✓
- `data_model_schema_validated` (28 chars) ✓

**Code Quality Gates:**
- `linter_passes_no_warnings` (26 chars) ✓
- `type_checker_passes_strict_mode` (32 chars) ✓
- `code_complexity_under_threshold` (32 chars) ✓
- `code_review_approved` (20 chars) ✓

**Deployment Gates:**
- `staging_deployment_successful` (30 chars) ✓
- `smoke_tests_pass_in_staging` (28 chars) ✓
- `production_deployment_verified` (31 chars) ✓
- `monitoring_alerts_configured` (28 chars) ✓

---

### Bad Examples (Too Short - Under 20 chars)

**Phases:**
- `design` (6 chars) ✗ - Way too generic
- `implement` (9 chars) ✗ - No domain context
- `test_phase` (10 chars) ✗ - Not descriptive enough
- `review` (6 chars) ✗ - Too vague
- `build_features` (14 chars) ✗ - What features? What workflow?
- `deploy_code` (11 chars) ✗ - Missing workflow context

**Gates:**
- `done` (4 chars) ✗ - Meaningless
- `tests_pass` (10 chars) ✗ - Which tests?
- `approved` (8 chars) ✗ - By whom? For what?
- `ready` (5 chars) ✗ - Ready for what?

---

### Bad Examples (Too Long - Over 45 chars)

**Phases:**
- `implement_the_complete_user_authentication_system_with_oauth_and_jwt` (70 chars) ✗
- `write_comprehensive_unit_and_integration_tests_covering_all_edge_cases` (72 chars) ✗
- `conduct_thorough_security_audit_and_penetration_testing_with_report` (69 chars) ✗
- `deploy_to_production_with_zero_downtime_blue_green_deployment_strategy` (72 chars) ✗

**Better versions:**
- `implement_oauth_authentication_flow` (36 chars) ✓
- `write_comprehensive_test_suite` (31 chars) ✓
- `conduct_security_audit_and_testing` (35 chars) ✓
- `deploy_with_zero_downtime_strategy` (35 chars) ✓

---

### Cross-Domain Comparison

Same phase type, different workflow domains - notice the pattern:

**Design/Planning Phase:**
- Backend API: `design_data_models_and_api_contracts` (37 chars)
- React Frontend: `design_component_hierarchy_and_state` (37 chars)
- Go CLI: `define_command_interface_and_flags` (35 chars)
- Data Pipeline: `design_data_pipeline_architecture` (34 chars)
- Learning: `structure_learning_path_and_goals` (34 chars)

**Implementation Phase:**
- Backend API: `implement_core_business_logic_layer` (36 chars)
- React Frontend: `implement_components_with_hooks` (31 chars)
- Go CLI: `implement_subcommand_handlers` (29 chars)
- Data Pipeline: `implement_etl_transformations` (29 chars)
- Learning: `complete_practice_exercises_set` (32 chars)

**Validation Phase:**
- Backend API: `validate_api_performance_and_load` (34 chars)
- React Frontend: `test_user_flows_and_interactions` (33 chars)
- Go CLI: `test_cli_workflows_end_to_end` (30 chars)
- Data Pipeline: `validate_data_quality_and_schema` (33 chars)
- Learning: `complete_mastery_assessment_challenges` (39 chars)

**Deployment Phase:**
- Backend API: `deploy_to_staging_environment` (29 chars)
- React Frontend: `deploy_optimized_production_build` (34 chars)
- Go CLI: `build_cross_platform_binaries` (30 chars)
- Data Pipeline: `deploy_pipeline_to_production` (30 chars)
- Learning: `publish_portfolio_project_showcase` (35 chars)

---

### Naming Decision Framework

**Ask yourself:**
1. **Is it reusable?** Can this phase name apply to multiple stories in this workflow?
2. **Is it specific?** Does it indicate the workflow domain (API, CLI, learning)?
3. **Is it actionable?** Does it describe what gets done?
4. **Is it scoped?** Is it neither too narrow (task-specific) nor too broad (generic)?

**Examples of applying framework:**

❌ `implement_user_login_feature`
- Not reusable (specific to login feature only)
- Too narrow (task-specific, not workflow-specific)

✓ `implement_authentication_endpoints`
- Reusable (any auth-related story)
- Specific (backend API workflow)
- Actionable (implement)
- Well-scoped (authentication domain)

❌ `do_some_coding_work`
- Generic (no domain indicated)
- Not actionable (vague)
- Not specific to workflow

✓ `implement_react_components_with_state`
- Reusable (any React feature)
- Specific (React frontend workflow)
- Actionable (implement)
- Well-scoped (components + state)

---

## 9. Complete Examples

Full workflow.toml + hierarchy.toml examples across domains with different hierarchy depths.

### Example 1: Backend API with TDD (Single-Level)

**Scenario:** Solo developer building Python FastAPI backend, strict TDD

**hierarchy.toml:**
```toml
type = "work"
levels = ["story"]

[level.story]
singular = "story"
plural = "stories"
workflow_required = true
```

**workflow.toml:**
```toml
[metadata]
name = "python-api-tdd-workflow"
title = "Python API Development with TDD"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

[commands]
test = "pytest --tb=short --cov=. --cov-report=term-missing"
test-watch = "pytest-watch --runner 'pytest --tb=short'"
lint = "ruff check ."
lint-fix = "ruff check . --fix"
format = "ruff format ."
typecheck = "mypy src/"
run = "uvicorn main:app --reload"
run-prod = "gunicorn main:app --bind 0.0.0.0:8000"
migrate = "alembic upgrade head"

[[phase]]
id = "design_data_models_and_api_contracts"
name = "Design API"
description = "Plan database schema, data models, and endpoint contracts"
gates = ["design_document_complete"]

[[phase]]
id = "write_failing_tests_for_api_behavior"
name = "Write Tests (Red)"
description = "Create comprehensive test suite defining API behavior"
gates = ["tests_exist_and_fail_appropriately"]

[[phase]]
id = "implement_endpoints_and_business_logic"
name = "Implement (Green)"
description = "Build API endpoints to pass test suite"
gates = ["all_tests_passing_with_coverage"]

[[phase]]
id = "refactor_implementation_for_quality"
name = "Refactor"
description = "Improve code quality while keeping tests green"
gates = ["code_quality_standards_met"]

[[phase]]
id = "conduct_code_review_and_finalize"
name = "Review"
description = "Self-review and final validation"
gates = ["code_review_checklist_complete"]

[gates.design_document_complete]
type = "automated"
description = "Design document exists with data models and API contracts"
script = "check-design-complete.sh"

[gates.tests_exist_and_fail_appropriately]
type = "automated"
description = "Tests exist and fail before implementation (TDD red)"
script = "check-tests-failing.sh"

[gates.all_tests_passing_with_coverage]
type = "automated"
description = "All tests pass with 80%+ coverage"
script = "check-tests-passing.sh"

[gates.code_quality_standards_met]
type = "automated"
description = "Lint, format, and type checks all pass"
script = "check-quality.sh"

[gates.code_review_checklist_complete]
type = "interactive"
description = "Code review checklist completed"
script = "prompt-code-review.sh"
```

---

### Example 2: Go CLI Tool (Two-Level with Epic Workflow)

**Scenario:** Building a CLI tool with multiple related commands grouped into epics

**hierarchy.toml:**
```toml
type = "work"
levels = ["epic", "story"]

[level.epic]
singular = "epic"
plural = "epics"
workflow_required = true  # Epics have coordination workflow

[level.story]
singular = "story"
plural = "stories"
workflow_required = true
parent_level = "epic"
```

**Story workflow (workflow.toml):**
```toml
[metadata]
name = "go-cli-story-workflow"
title = "Go CLI Command Implementation"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

[commands]
test = "go test ./... -v -cover"
test-race = "go test ./... -race"
lint = "golangci-lint run"
format = "gofmt -w ."
build = "go build -o bin/devbox ./cmd/devbox"
build-release = "go build -ldflags='-s -w' -o bin/devbox ./cmd/devbox"
install = "go install"

[[phase]]
id = "define_command_interface_and_flags"
name = "Define Interface"
description = "Plan command structure, flags, and help text"
gates = ["command_interface_documented"]

[[phase]]
id = "implement_command_handler_logic"
name = "Implement Handler"
description = "Build command handler and core logic"
gates = ["unit_tests_passing"]

[[phase]]
id = "add_error_handling_and_validation"
name = "Add Validation"
description = "Implement input validation and error handling"
gates = ["validation_tests_passing"]

[[phase]]
id = "test_command_end_to_end"
name = "Integration Test"
description = "Test complete command workflow end-to-end"
gates = ["integration_tests_passing"]

[gates.command_interface_documented]
type = "automated"
description = "Command interface documented in docs/"
script = "check-interface-docs.sh"

[gates.unit_tests_passing]
type = "automated"
description = "Unit tests pass with coverage"
script = "check-unit-tests.sh"

[gates.validation_tests_passing]
type = "automated"
description = "Validation and error handling tests pass"
script = "check-validation-tests.sh"

[gates.integration_tests_passing]
type = "automated"
description = "End-to-end integration tests pass"
script = "check-integration-tests.sh"
```

**Epic workflow (epic-workflow.toml):**
```toml
[metadata]
name = "go-cli-epic-workflow"
title = "Go CLI Epic Coordination"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

[commands]
test = "go test ./... -v -cover"
build = "go build -o bin/devbox ./cmd/devbox"

[[phase]]
id = "define_epic_scope_and_story_breakdown"
name = "Scope Epic"
description = "Define epic goals and break down into stories"
gates = ["epic_stories_defined"]

[[phase]]
id = "track_story_progress_and_dependencies"
name = "Coordinate Stories"
description = "Track story completion, manage dependencies"
gates = []  # No gates, advances via DFS when all stories complete

[[phase]]
id = "integrate_and_test_epic_features"
name = "Integration Test"
description = "Test all epic features working together"
gates = ["epic_integration_tests_passing"]

[[phase]]
id = "document_epic_features_and_usage"
name = "Document Epic"
description = "Update documentation for epic features"
gates = ["epic_documentation_complete"]

[gates.epic_stories_defined]
type = "automated"
description = "Epic has documented stories with clear scope"
script = "check-epic-stories.sh"

[gates.epic_integration_tests_passing]
type = "automated"
description = "Epic-level integration tests pass"
script = "check-epic-integration.sh"

[gates.epic_documentation_complete]
type = "automated"
description = "Documentation updated for all epic features"
script = "check-epic-docs.sh"
```

---

### Example 3: Full-Stack Feature (Three-Level)

**Scenario:** Large product initiative with multiple epics and stories

**hierarchy.toml:**
```toml
type = "work"
levels = ["initiative", "epic", "story"]

[level.initiative]
singular = "initiative"
plural = "initiatives"
workflow_required = true  # Strategic planning workflow

[level.epic]
singular = "epic"
plural = "epics"
workflow_required = true  # Coordination workflow
parent_level = "initiative"

[level.story]
singular = "story"
plural = "stories"
workflow_required = true  # Implementation workflow
parent_level = "epic"
```

**Story workflow (story-workflow.toml):**
```toml
[metadata]
name = "fullstack-story-workflow"
title = "Full-Stack Feature Implementation"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

[commands]
test = "npm run test:all"
test-unit = "npm run test:unit"
test-integration = "npm run test:integration"
lint = "npm run lint"
format = "npm run format"
typecheck = "npm run typecheck"
dev = "npm run dev"
build = "npm run build"

[[phase]]
id = "design_feature_with_acceptance_criteria"
name = "Design Feature"
description = "Plan feature architecture and acceptance criteria"
gates = ["design_approved_by_team"]

[[phase]]
id = "implement_backend_api_and_logic"
name = "Implement Backend"
description = "Build API endpoints and business logic"
gates = ["backend_tests_passing"]

[[phase]]
id = "implement_frontend_ui_and_interaction"
name = "Implement Frontend"
description = "Build UI components and user interactions"
gates = ["frontend_tests_passing"]

[[phase]]
id = "integrate_frontend_and_backend"
name = "Integration"
description = "Connect frontend to backend, test data flow"
gates = ["integration_tests_passing"]

[[phase]]
id = "deploy_to_staging_and_validate"
name = "Stage & Validate"
description = "Deploy to staging, conduct QA testing"
gates = ["staging_validation_complete"]

[gates.design_approved_by_team]
type = "interactive"
description = "Design reviewed and approved by team"
script = "prompt-design-approval.sh"

[gates.backend_tests_passing]
type = "automated"
description = "Backend unit and integration tests pass"
script = "check-backend-tests.sh"

[gates.frontend_tests_passing]
type = "automated"
description = "Frontend unit and component tests pass"
script = "check-frontend-tests.sh"

[gates.integration_tests_passing]
type = "automated"
description = "Full-stack integration tests pass"
script = "check-integration-tests.sh"

[gates.staging_validation_complete]
type = "interactive"
description = "QA validation complete in staging"
script = "prompt-staging-qa.sh"
```

**Epic workflow (epic-workflow.toml):**
```toml
[metadata]
name = "fullstack-epic-workflow"
title = "Epic Coordination Workflow"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

[commands]
test = "npm run test:all"
build = "npm run build"

[[phase]]
id = "plan_epic_goals_and_story_breakdown"
name = "Plan Epic"
description = "Define epic goals and break into stories"
gates = ["epic_planning_complete"]

[[phase]]
id = "coordinate_story_development"
name = "Coordinate Development"
description = "Track story progress and unblock dependencies"
gates = []  # Advances when all stories complete

[[phase]]
id = "conduct_epic_integration_testing"
name = "Epic Integration"
description = "Test all epic features working together"
gates = ["epic_integration_verified"]

[[phase]]
id = "prepare_epic_release_and_docs"
name = "Prepare Release"
description = "Finalize documentation and release notes"
gates = ["epic_release_ready"]

[gates.epic_planning_complete]
type = "interactive"
description = "Epic plan reviewed with stakeholders"
script = "prompt-epic-planning.sh"

[gates.epic_integration_verified]
type = "automated"
description = "Epic-level integration tests pass"
script = "check-epic-integration.sh"

[gates.epic_release_ready]
type = "interactive"
description = "Release notes and docs complete"
script = "prompt-release-ready.sh"
```

**Initiative workflow (initiative-workflow.toml):**
```toml
[metadata]
name = "initiative-planning-workflow"
title = "Initiative Strategic Planning"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

[commands]
test = "npm run test:all"

[[phase]]
id = "define_initiative_vision_and_goals"
name = "Define Vision"
description = "Establish initiative vision, goals, and success metrics"
gates = ["vision_approved_by_leadership"]

[[phase]]
id = "plan_epic_breakdown_and_roadmap"
name = "Plan Roadmap"
description = "Break initiative into epics and create roadmap"
gates = ["roadmap_reviewed_and_approved"]

[[phase]]
id = "monitor_epic_progress_and_adjust"
name = "Monitor Progress"
description = "Track epic completion and adjust plans"
gates = []  # Advances when all epics complete

[[phase]]
id = "evaluate_initiative_success_metrics"
name = "Evaluate Success"
description = "Measure against success criteria and document learnings"
gates = ["success_evaluation_complete"]

[gates.vision_approved_by_leadership]
type = "interactive"
description = "Initiative vision approved by leadership"
script = "prompt-vision-approval.sh"

[gates.roadmap_reviewed_and_approved]
type = "interactive"
description = "Roadmap reviewed by stakeholders"
script = "prompt-roadmap-approval.sh"

[gates.success_evaluation_complete]
type = "interactive"
description = "Success metrics evaluated and documented"
script = "prompt-success-evaluation.sh"
```

---

### Example 4: Learning Course (Two-Level)

**Scenario:** Online course with modules and lessons

**hierarchy.toml:**
```toml
type = "learning"
levels = ["module", "lesson"]

[level.module]
singular = "module"
plural = "modules"
workflow_required = true  # Module has synthesis workflow

[level.lesson]
singular = "lesson"
plural = "lessons"
workflow_required = true
parent_level = "module"
```

**Lesson workflow (lesson-workflow.toml):**
```toml
[metadata]
name = "lesson-learning-workflow"
title = "Lesson Learning Workflow"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

[commands]
test = "npm test"
run = "npm start"
check-exercises = "bash scripts/check-exercises.sh"

[[phase]]
id = "review_lesson_objectives_and_materials"
name = "Review Objectives"
description = "Understand what to learn and why it matters"
gates = ["objectives_clearly_understood"]

[[phase]]
id = "study_concepts_with_examples"
name = "Study Concepts"
description = "Read material, watch videos, review examples"
gates = ["core_concepts_grasped"]

[[phase]]
id = "complete_practice_exercises_actively"
name = "Practice"
description = "Complete hands-on exercises applying concepts"
gates = ["exercises_completed_successfully"]

[[phase]]
id = "reflect_on_lesson_understanding"
name = "Reflect"
description = "Self-assess understanding and note questions"
gates = ["reflection_notes_complete"]

[gates.objectives_clearly_understood]
type = "interactive"
description = "Can articulate lesson objectives"
script = "prompt-objectives.sh"

[gates.core_concepts_grasped]
type = "interactive"
description = "Can explain concepts without reference"
script = "prompt-concepts.sh"

[gates.exercises_completed_successfully]
type = "automated"
description = "Practice exercises run without errors"
script = "check-exercises.sh"

[gates.reflection_notes_complete]
type = "automated"
description = "Reflection notes exist with key takeaways"
script = "check-reflection.sh"
```

**Module workflow (module-workflow.toml):**
```toml
[metadata]
name = "module-synthesis-workflow"
title = "Module Synthesis Workflow"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

[commands]
test = "npm test"
run = "npm start"

[[phase]]
id = "set_module_learning_goals"
name = "Set Goals"
description = "Define what to achieve in this module"
gates = ["module_goals_defined"]

[[phase]]
id = "progress_through_lessons"
name = "Complete Lessons"
description = "Work through lessons in sequence"
gates = []  # Advances when all lessons complete

[[phase]]
id = "synthesize_module_concepts_integration"
name = "Synthesize"
description = "Connect concepts across lessons"
gates = ["synthesis_project_complete"]

[[phase]]
id = "assess_module_mastery_level"
name = "Assess Mastery"
description = "Complete module assessment"
gates = ["module_assessment_passed"]

[gates.module_goals_defined]
type = "interactive"
description = "Module learning goals clearly defined"
script = "prompt-module-goals.sh"

[gates.synthesis_project_complete]
type = "automated"
description = "Module synthesis project complete"
script = "check-synthesis-project.sh"

[gates.module_assessment_passed]
type = "automated"
description = "Module assessment demonstrates mastery"
script = "check-module-assessment.sh"
```

---

### Example 5: Documentation Series (Two-Level)

**Scenario:** Technical documentation series with multiple guides

**hierarchy.toml:**
```toml
type = "documentation"
levels = ["guide", "section"]

[level.guide]
singular = "guide"
plural = "guides"
workflow_required = true  # Guide has editorial workflow

[level.section]
singular = "section"
plural = "sections"
workflow_required = true
parent_level = "guide"
```

**Section workflow (section-workflow.toml):**
```toml
[metadata]
name = "docs-section-workflow"
title = "Documentation Section Writing"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

[commands]
test = "bash scripts/test-examples.sh"
lint = "markdownlint docs/"
format = "prettier --write docs/"
preview = "mkdocs serve"

[[phase]]
id = "outline_section_content_and_structure"
name = "Outline"
description = "Plan section structure and key points"
gates = ["outline_approved"]

[[phase]]
id = "write_draft_with_code_examples"
name = "Write Draft"
description = "Write content and create code examples"
gates = ["draft_complete"]

[[phase]]
id = "validate_examples_execute_correctly"
name = "Validate Examples"
description = "Test all code examples run without errors"
gates = ["examples_tested_and_working"]

[[phase]]
id = "review_clarity_and_accuracy"
name = "Review"
description = "Review for clarity, accuracy, and completeness"
gates = ["technical_review_approved"]

[gates.outline_approved]
type = "interactive"
description = "Section outline reviewed and approved"
script = "prompt-outline-approval.sh"

[gates.draft_complete]
type = "automated"
description = "Draft meets minimum word count and structure"
script = "check-draft-complete.sh"

[gates.examples_tested_and_working]
type = "automated"
description = "All code examples execute successfully"
script = "test-code-examples.sh"

[gates.technical_review_approved]
type = "interactive"
description = "Technical review complete"
script = "prompt-technical-review.sh"
```

**Guide workflow (guide-workflow.toml):**
```toml
[metadata]
name = "docs-guide-workflow"
title = "Documentation Guide Editorial"
version = "1.0.0"
created_at = "2025-10-05T00:00:00Z"

[commands]
test = "bash scripts/test-examples.sh"
build = "mkdocs build"
preview = "mkdocs serve"
deploy = "mkdocs gh-deploy"

[[phase]]
id = "plan_guide_scope_and_audience"
name = "Plan Guide"
description = "Define guide scope, audience, and learning path"
gates = ["guide_plan_approved"]

[[phase]]
id = "coordinate_section_development"
name = "Write Sections"
description = "Track section completion and maintain flow"
gates = []  # Advances when all sections complete

[[phase]]
id = "integrate_sections_and_add_navigation"
name = "Integration"
description = "Connect sections, add navigation, cross-references"
gates = ["guide_integration_complete"]

[[phase]]
id = "conduct_guide_editorial_review"
name = "Editorial Review"
description = "Full guide review for consistency and quality"
gates = ["editorial_review_passed"]

[[phase]]
id = "publish_guide_and_announce"
name = "Publish"
description = "Deploy to docs site and announce availability"
gates = ["guide_published_successfully"]

[gates.guide_plan_approved]
type = "interactive"
description = "Guide plan reviewed by stakeholders"
script = "prompt-guide-plan.sh"

[gates.guide_integration_complete]
type = "automated"
description = "Navigation and cross-references working"
script = "check-guide-integration.sh"

[gates.editorial_review_passed]
type = "interactive"
description = "Editorial review complete"
script = "prompt-editorial-review.sh"

[gates.guide_published_successfully]
type = "automated"
description = "Guide deployed and accessible"
script = "check-guide-published.sh"
```

---

## Summary

This template library provides patterns for generating workflow.toml and hierarchy.toml files. Key principles:

1. **Progressive disclosure:** Generate TOML structure first, content comes later
2. **Workflow reusability:** Phase/gate names apply to multiple stories using same workflow
3. **Domain specificity:** 20-45 char names force thinking about specific approach/domain
4. **Hierarchy flexibility:** Choose single/two/three levels based on project complexity
5. **Parent workflows optional:** Epics/Initiatives can have coordination workflows
6. **DFS bubble-up:** Parent phases advance when all children complete
7. **Tech stack adaptation:** Use [commands] section for tech-specific tooling

**Next steps after generating TOML:**
1. CLI validates TOML structure
2. CLI generates placeholder files (phases/*.md, gates/*.sh, principles.md)
3. Read targeted examples for specific phase/gate types you used
4. Fill in placeholder content
5. Start working through your workflow!
