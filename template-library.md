# Trainset Lite Template Library

**Purpose:** This document contains all the patterns, examples, and guidance needed to synthesize custom workflows for any project type. Read this after conducting the interview to generate WORKFLOW.md, CONTEXT.md, and PROGRESS.md.

---

## Table of Contents

1. [Core Concepts](#core-concepts)
2. [Phase Patterns](#phase-patterns)
3. [Gate Patterns](#gate-patterns)
4. [Workflow Compositions](#workflow-compositions)
5. [Command Patterns](#command-patterns)
6. [Adaptation Rules](#adaptation-rules)
7. [Domain Examples](#domain-examples)

---

## Core Concepts

### What Is a Workflow?

A workflow is a sequence of **phases** that guide work from start to finish. Each phase has:
- **Purpose** - What this phase accomplishes
- **Inputs** - Prerequisites from previous work
- **Outputs** - Artifacts this phase produces
- **Process** - How to complete the phase
- **Gate** - Checklist to validate readiness to advance

### Workflow Types

**Development** - Building software (features, tools, apps)
**Learning** - Educational projects, skill acquisition
**Documentation** - Writing guides, tutorials, reference docs
**Research** - Investigation, exploration, synthesis

### Guiding Principles

1. **Be specific to the domain** - "Design REST API endpoints" not "Design phase"
2. **Make gates assessable** - LLM should be able to evaluate checklist items through conversation
3. **Adapt, don't copy** - Use patterns as starting points, customize to project needs
4. **Phases are guidance** - Not rigid enforcement, flexible interpretation expected

---

## Phase Patterns

### Pattern: Ideation/Discovery

**When to use:** Project start, need to understand the problem space

**Purpose variations:**
- Development: "Define problem and solution approach"
- Learning: "Identify learning goals and success criteria"
- Documentation: "Understand audience and content scope"
- Research: "Frame research questions and methodology"

**Common inputs:** Project requirements, stakeholder needs, existing constraints

**Common outputs:** Problem statement, success criteria, scope boundaries

**Sample gate checklist:**
- [ ] Problem is clearly articulated
- [ ] Success criteria are defined
- [ ] Scope is bounded (know what you're NOT doing)
- [ ] Key constraints identified

### Pattern: Architecture/Structure

**When to use:** Need high-level design before detailed work

**Purpose variations:**
- Development: "Plan system architecture and component interactions"
- Learning: "Structure learning path and milestones"
- Documentation: "Organize content hierarchy and flow"
- Research: "Design research methodology and data collection"

**Common inputs:** Problem definition, requirements, technical constraints

**Common outputs:** Architecture diagrams, component definitions, structure plan

**Sample gate checklist:**
- [ ] Major components identified
- [ ] Interactions/dependencies mapped
- [ ] Technical approach decided
- [ ] Key risks documented

### Pattern: Design/Specification

**When to use:** Need detailed plans before implementation

**Purpose variations:**
- Development: "Define APIs, data structures, and interfaces"
- Learning: "Plan exercises and assessment methods"
- Documentation: "Create content outlines and examples"
- Research: "Design experiments and data analysis approach"

**Common inputs:** Architecture plan, functional requirements

**Common outputs:** Detailed specifications, interface definitions, implementation plan

**Sample gate checklist:**
- [ ] Interfaces/APIs defined
- [ ] Data structures planned
- [ ] Edge cases identified
- [ ] Implementation approach clear

### Pattern: Implementation/Creation

**When to use:** Building/creating the actual work product

**Purpose variations:**
- Development: "Write code to implement features"
- Learning: "Complete exercises and practice problems"
- Documentation: "Write content and examples"
- Research: "Execute experiments and collect data"

**Common inputs:** Design specifications, tools/environment setup

**Common outputs:** Working implementation, completed exercises, written content, data

**Sample gate checklist:**
- [ ] Core functionality complete
- [ ] Major requirements satisfied
- [ ] Basic testing/validation done
- [ ] Ready for review/refinement

### Pattern: Validation/Testing

**When to use:** Verify that work meets requirements

**Purpose variations:**
- Development: "Test functionality and fix issues"
- Learning: "Assess understanding and fill gaps"
- Documentation: "Review accuracy and clarity"
- Research: "Analyze data and validate findings"

**Common inputs:** Implementation/content, success criteria, test cases

**Common outputs:** Validated work product, test results, identified issues

**Sample gate checklist:**
- [ ] Meets original success criteria
- [ ] Tested against edge cases
- [ ] Issues identified and addressed
- [ ] Ready for final review

### Pattern: Reflection/Iteration

**When to use:** Learning projects, exploratory work, improvement cycles

**Purpose variations:**
- Development: "Review code quality and architectural decisions"
- Learning: "Reflect on understanding and identify next steps"
- Documentation: "Gather feedback and improve content"
- Research: "Interpret findings and plan follow-up"

**Common inputs:** Completed work, feedback, evaluation criteria

**Common outputs:** Lessons learned, improvement plan, next iteration scope

**Sample gate checklist:**
- [ ] Key insights captured
- [ ] Strengths/weaknesses identified
- [ ] Next steps planned
- [ ] Learning/improvements documented

### Pattern: Polish/Finalization

**When to use:** Final preparation before considering work "done"

**Purpose variations:**
- Development: "Code cleanup, documentation, deployment prep"
- Learning: "Synthesize knowledge and plan application"
- Documentation: "Final editing and publication"
- Research: "Write up findings and prepare presentation"

**Common inputs:** Validated work product, quality standards

**Common outputs:** Polished deliverable, documentation, final presentation

**Sample gate checklist:**
- [ ] Quality standards met
- [ ] Documentation complete
- [ ] Ready to share/deploy/present
- [ ] No critical issues remain

---

## Gate Patterns

### Simple Completion Gates

Use when: Clear deliverables, objective assessment possible

```markdown
**Gate Checklist:**
- [ ] [Specific deliverable] exists
- [ ] [Quality criteria] met
- [ ] [Stakeholder] has reviewed and approved
```

### Self-Assessment Gates

Use when: Subjective quality, personal judgment needed

```markdown
**Gate Checklist:**
- [ ] I can clearly explain [concept/decision]
- [ ] I'm confident this meets [standard/requirement]
- [ ] I would be comfortable [sharing/deploying/presenting] this
```

### Process Verification Gates

Use when: Following methodology is important

```markdown
**Gate Checklist:**
- [ ] [Required process step] completed
- [ ] [Tool/method] used correctly
- [ ] [Best practice] followed
```

### Learning Gates

Use when: Understanding/skill development is the goal

```markdown
**Gate Checklist:**
- [ ] Can explain [concept] without looking at notes
- [ ] Successfully completed [exercise/challenge]
- [ ] Identified [gaps/next learning steps]
```

---

## Workflow Compositions

### Development Workflows

**TDD-focused projects:**
- Expand Design phase → Include test planning
- Split Implementation → "Write tests" + "Make tests pass"
- Emphasize Validation → Comprehensive testing

**Exploratory/prototype projects:**
- Lightweight Architecture/Design phases
- Multiple Implementation+Validation cycles
- Strong Reflection phase for lessons learned

**Production/enterprise projects:**
- Detailed Architecture and Design phases
- Implementation with code review checkpoints
- Extensive Validation and Polish phases

### Learning Workflows

**Skill acquisition:**
- Clear goal-setting in Ideation
- Structured practice in Implementation
- Regular reflection and adjustment

**Research-based learning:**
- Strong Discovery/Research phases
- Experimentation focus
- Synthesis and application phases

### Documentation Workflows

**User guides:**
- Audience analysis in Ideation
- Content structure in Architecture
- Writing and user testing cycles

**Technical documentation:**
- System understanding in Discovery
- Content organization
- Accuracy validation with experts

---

## Command Patterns

### Testing Commands

**For projects with formal testing:**
```markdown
# Command: Test

**Command:** `[test-runner] [flags]`
**Purpose:** Run test suite
**When to use:** During Implementation and Validation phases
**Interpreting output:** All pass = ready to advance, failures = need fixes
```

**For learning projects:**
```markdown
# Command: Check Understanding

**Command:** Review exercises and self-assess
**Purpose:** Validate learning progress
**When to use:** End of practice sessions
**Interpreting output:** Can explain concepts = ready to advance
```

### Build/Deploy Commands

**For software projects:**
```markdown
# Command: Build

**Command:** `[build-tool] [target]`
**Purpose:** Compile/package the project
**When to use:** Before testing, during validation
**Interpreting output:** Clean build = ready to test/deploy
```

### Quality Commands

**Code quality:**
```markdown
# Command: Lint

**Command:** `[linter] [flags]`
**Purpose:** Check code style and quality
**When to use:** During Implementation, before review
**Interpreting output:** No issues = meets quality standards
```

### Project-specific Commands

**Always customize based on tech stack and project needs**

Common patterns:
- `run` - Start/execute the project
- `deploy` - Deploy to staging/production
- `migrate` - Database migrations
- `seed` - Test data setup

---

## Adaptation Rules

### Based on Project Type

**If TDD/test-driven:**
- Add "test-first" sub-phases to Implementation
- Emphasize testing in gates
- Include test coverage in validation

**If exploratory/research:**
- Lighter upfront design phases
- More iteration cycles
- Stronger reflection/learning capture

**If learning-focused:**
- Add reflection checkpoints to each phase
- Include "explain concepts" in gates
- Emphasize understanding over deliverables

**If time-constrained:**
- Combine related phases (Architecture+Design)
- Focus on MVP scope
- Streamline polish phase

### Based on Working Style

**If solo developer:**
- Self-assessment gates
- Flexibility in phase progression
- Personal accountability measures

**If team environment:**
- Review/approval gates
- Communication checkpoints
- Shared artifact requirements

**If ADHD/focus challenges:**
- Shorter phases with frequent wins
- Clear completion criteria
- External validation preferred

### Based on Tech Stack

**For different languages/frameworks:**
- Adapt command patterns to tools
- Include framework-specific phases (migration, deployment)
- Adjust testing approaches

**For different domains:**
- Web development: API design, frontend/backend phases
- CLI tools: interface design, platform testing
- Data projects: collection, analysis, visualization phases

---

## Domain Examples

### Web Application Development

```markdown
# Workflow: REST API Development

## Phases

### Phase 1: Define API Requirements
**Purpose:** Understand endpoints, data models, and user flows
**Outputs:** API specification, data model design, authentication plan

### Phase 2: Design Database Schema
**Purpose:** Plan data storage and relationships
**Outputs:** Database schema, migration plan, seed data strategy

### Phase 3: Implement Core Endpoints
**Purpose:** Build basic CRUD operations
**Outputs:** Working endpoints, basic validation, error handling

### Phase 4: Add Authentication and Authorization
**Purpose:** Secure the API
**Outputs:** Auth system, protected routes, user management

### Phase 5: Integration Testing
**Purpose:** Test complete user flows
**Outputs:** End-to-end tests, API documentation, deployment readiness
```

### CLI Tool Development

```markdown
# Workflow: Command-Line Tool

## Phases

### Phase 1: Define Command Interface
**Purpose:** Plan CLI structure, flags, and subcommands
**Outputs:** Command specification, help text design, usage examples

### Phase 2: Implement Core Logic
**Purpose:** Build the tool's main functionality
**Outputs:** Working core features, basic error handling

### Phase 3: Add CLI Layer
**Purpose:** Connect core logic to command-line interface
**Outputs:** Argument parsing, command dispatch, user feedback

### Phase 4: Cross-Platform Testing
**Purpose:** Ensure tool works across target platforms
**Outputs:** Platform-specific builds, installation instructions

### Phase 5: Documentation and Distribution
**Purpose:** Prepare for users
**Outputs:** README, installation guide, release packaging
```

### Learning Project

```markdown
# Workflow: Learn New Framework

## Phases

### Phase 1: Set Learning Goals
**Purpose:** Define what you want to achieve
**Outputs:** Specific learning objectives, success metrics, timeline

### Phase 2: Study Fundamentals
**Purpose:** Understand core concepts and patterns
**Outputs:** Notes on key concepts, basic examples working

### Phase 3: Build Practice Project
**Purpose:** Apply knowledge in realistic context
**Outputs:** Working project demonstrating framework features

### Phase 4: Explore Advanced Features
**Purpose:** Go beyond basics to deeper understanding
**Outputs:** Advanced examples, performance considerations, best practices

### Phase 5: Reflect and Plan Next Steps
**Purpose:** Consolidate learning and identify growth areas
**Outputs:** Learning summary, confidence assessment, next learning goals
```

---

## Synthesis Instructions

When generating a custom workflow:

1. **Start with interview responses** - Use project type, tech stack, constraints to guide adaptation

2. **Choose base pattern** - Pick Development/Learning/Documentation/Research as starting point

3. **Select relevant phases** - Use 4-6 phases, adapted to specific needs:
   - Always start with some form of Ideation/Discovery
   - Include Implementation/Creation phase(s)
   - End with Validation and/or Polish
   - Add domain-specific phases as needed

4. **Customize phase names** - Make them specific to the project domain
   - "Design REST API endpoints" not "Design phase"
   - "Implement user authentication" not "Implementation phase"

5. **Adapt gates** - Choose appropriate gate patterns and customize checklists

6. **Generate supporting files:**
   - CONTEXT.md with project-specific details
   - PROGRESS.md initialized to first phase
   - Relevant command files adapted to tech stack

7. **Remember principles:**
   - Be specific to domain and project
   - Make gates assessable by LLM
   - Prioritize flexibility over rigidity
   - Focus on guidance, not enforcement