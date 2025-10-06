# Workflow: Development Project

## Principles

This workflow provides flexible structure for software development projects. It emphasizes iterative progress with clear checkpoints while remaining adaptable to different project types and working styles.

**What it optimizes for:**
- Clear progression from idea to working software
- Regular validation to prevent going off-track
- Flexibility to adapt to project needs
- Sustainable pace with meaningful milestones

**When to use:**
- Building features, tools, or applications
- Projects requiring both planning and implementation
- When you want structure without rigid process overhead

**Trade-offs:**
- Less rigid than formal methodologies (TDD, Agile)
- Relies on self-assessment rather than external validation
- Phases are guidance, not strict enforcement

---

## Phases

### Phase 1: Project Definition

**Purpose:** Clearly understand what you're building and why.

**Inputs:**
- Initial project idea or requirements
- Stakeholder needs and constraints
- Available resources and timeline

**Outputs:**
- Clear problem statement
- Defined success criteria
- Bounded scope (what you will and won't build)
- Basic technical approach

**Process:**
1. Articulate the problem being solved
2. Define what success looks like
3. Identify key constraints (time, scope, technical)
4. Sketch high-level approach
5. Document decisions and rationale

**Gate:**
- [ ] Problem statement is clear and specific
- [ ] Success criteria are measurable
- [ ] Scope boundaries are defined
- [ ] Technical approach is feasible
- [ ] Key risks and constraints identified

**Ready to advance when:** You can clearly explain what you're building, why, and how you'll know when it's done.

---

### Phase 2: Architecture Design

**Purpose:** Plan the high-level structure and key technical decisions.

**Inputs:**
- Problem definition and requirements
- Technical constraints and preferences
- Available tools and libraries

**Outputs:**
- System architecture overview
- Component breakdown and responsibilities
- Key technical decisions documented
- Interface definitions (APIs, data structures)

**Process:**
1. Identify major system components
2. Define how components interact
3. Make key technical decisions (frameworks, data storage, etc.)
4. Design primary interfaces and data structures
5. Document architecture and rationale

**Gate:**
- [ ] Major components identified and defined
- [ ] Component interactions are clear
- [ ] Key technical decisions made and documented
- [ ] Primary interfaces designed
- [ ] Architecture supports defined requirements

**Ready to advance when:** You have a clear mental model of how the system will work.

---

### Phase 3: Implementation

**Purpose:** Build the core functionality.

**Inputs:**
- Architecture design and component definitions
- Development environment setup
- Required tools and dependencies

**Outputs:**
- Working core functionality
- Basic tests covering main features
- Code that implements designed interfaces

**Process:**
1. Set up development environment
2. Implement core components iteratively
3. Write tests as you develop (level depends on project)
4. Handle basic error cases
5. Validate against requirements regularly

**Gate:**
- [ ] Core functionality works as designed
- [ ] Basic error handling implemented
- [ ] Code follows project conventions
- [ ] Main use cases can be demonstrated
- [ ] Basic tests validate functionality

**Ready to advance when:** The system does what you set out to build.

---

### Phase 4: Validation & Refinement

**Purpose:** Ensure the implementation meets requirements and is ready for use.

**Inputs:**
- Working implementation
- Original success criteria
- User feedback (if applicable)

**Outputs:**
- Validated functionality
- Bug fixes and improvements
- Performance optimization (if needed)
- Updated documentation

**Process:**
1. Test against original success criteria
2. Gather feedback from intended users
3. Fix identified issues and bugs
4. Optimize performance if needed
5. Refine based on real usage

**Gate:**
- [ ] Meets original success criteria
- [ ] Major bugs identified and fixed
- [ ] Performance is acceptable for intended use
- [ ] Feedback incorporated appropriately
- [ ] Ready for intended deployment/use

**Ready to advance when:** You're confident in the quality and readiness of the implementation.

---

### Phase 5: Documentation & Deployment

**Purpose:** Prepare for others to use and maintain the system.

**Inputs:**
- Validated implementation
- User feedback and usage patterns
- Deployment requirements

**Outputs:**
- User documentation (README, guides)
- Technical documentation (API docs, architecture)
- Deployment/installation instructions
- Maintainer documentation

**Process:**
1. Write user-facing documentation
2. Document technical details for maintainers
3. Create installation/deployment guides
4. Package for distribution
5. Set up monitoring/maintenance processes

**Gate:**
- [ ] User documentation exists and is clear
- [ ] Technical documentation is complete
- [ ] Installation/deployment process documented
- [ ] Project is packaged for distribution
- [ ] Handoff process complete (if applicable)

**Ready to advance when:** Others can successfully use and maintain the system.

---

## Commands

*[These will be filled in during setup based on your specific tech stack]*

**Common patterns:**
- **Test:** `[test command for your stack]`
- **Lint:** `[code quality/style checking]`
- **Build:** `[compilation/bundling process]`
- **Run:** `[start the application]`
- **Deploy:** `[deployment process]`

---

## Adaptation Notes

This workflow is designed to be customized during setup:

**For TDD/test-driven projects:**
- Expand Implementation phase with "write tests first" step
- Add test coverage requirements to gates
- Include test design in Architecture phase

**For exploratory/prototype projects:**
- Lighter Architecture phase (spike/experiment focus)
- Multiple shorter Implementation cycles
- Emphasis on learning and iteration in Refinement

**For learning projects:**
- Add reflection steps to each phase
- Include "explain concepts" in gate criteria
- Focus on understanding over deliverables

**For production systems:**
- Detailed architecture and security considerations
- Comprehensive testing and validation
- Deployment automation and monitoring

**For solo vs team projects:**
- Solo: self-assessment gates, flexible progression
- Team: review/approval gates, communication checkpoints

The LLM will adapt this structure during setup based on your interview responses.