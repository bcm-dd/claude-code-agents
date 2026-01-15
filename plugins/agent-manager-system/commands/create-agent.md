# Create New Claude Code Agent

Systematic workflow for designing and implementing new Claude Code agents with proper structure, capabilities, and marketplace integration.

[Extended thinking: Creating effective agents requires understanding the target domain, designing clear capabilities, selecting the right model tier, crafting activation triggers, and ensuring proper integration with the plugin ecosystem. Success depends on following established conventions while optimizing for the specific use case.]

## Prerequisites

$ARGUMENTS - Description of the agent to create (purpose, domain, capabilities)

## Phase 1: Requirements Analysis

### 1.1 Understand Agent Purpose
```
Use: agent-manager
Task: Analyze requirements and clarify agent purpose
```

Gather information about:
- **Primary function**: What problem does this agent solve?
- **Target domain**: What area of expertise is needed?
- **Use cases**: What are the main scenarios for using this agent?
- **Activation triggers**: What keywords/phrases should invoke this agent?
- **Complexity level**: Does this need complex reasoning (Sonnet) or fast execution (Haiku)?

### 1.2 Research Existing Agents

Search for similar or related agents in the codebase:
- Check if an existing agent covers this functionality
- Identify agents that could be extended instead of creating new ones
- Find agents to reference for style and structure
- Look for potential collaboration patterns with existing agents

### 1.3 Define Agent Scope

Document clear boundaries:
- What this agent WILL do (capabilities)
- What this agent will NOT do (out of scope)
- How it relates to other agents
- Expected input/output patterns

## Phase 2: Agent Design

### 2.1 Select Model Tier

Choose the appropriate model:

**Haiku (Fast Execution)**:
- Code generation and scaffolding
- Documentation generation
- Deterministic transformations
- Testing and validation
- Quick lookups and formatting

**Sonnet (Complex Reasoning)**:
- Architecture decisions
- Code review and analysis
- Multi-step planning
- Security assessments
- Complex problem solving

### 2.2 Design Capabilities

Organize capabilities into logical sections:
```
## Capabilities

### {Category 1}
- Capability 1.1
- Capability 1.2

### {Category 2}
- Capability 2.1
- Capability 2.2
```

Best practices:
- Group related capabilities together
- Be specific about what the agent can do
- Include both what and how
- Cover common use cases comprehensively

### 2.3 Define Behavioral Traits

Specify personality and approach:
- Communication style (concise, detailed, technical)
- Decision-making approach (conservative, innovative)
- Error handling behavior
- Interaction patterns
- Quality focus areas

### 2.4 Build Knowledge Base

Document expertise areas:
- Technical domains
- Best practices and patterns
- Tools and technologies
- Industry standards
- Common pitfalls to avoid

### 2.5 Create Response Approach

Define step-by-step methodology:
1. How the agent analyzes requests
2. How it gathers information
3. How it makes decisions
4. How it structures responses
5. How it validates outputs

## Phase 3: Implementation

### 3.1 Create Agent File

```
Use: agent-manager
Task: Generate the complete agent markdown file
```

File location: `plugins/{plugin-name}/agents/{agent-name}.md`

Required sections:
- YAML frontmatter (name, description, model)
- Opening paragraph (role definition)
- Purpose section
- Capabilities (organized by category)
- Behavioral Traits
- Knowledge Base
- Response Approach
- Example Interactions

### 3.2 Craft Description

The description is critical for agent activation. Include:
- Core purpose in first sentence
- Key capabilities mentioned
- Activation trigger phrases
- "Use when..." or "Use PROACTIVELY for..." guidance

Example:
```
description: Expert Python developer specializing in Django, FastAPI, and async patterns.
Deep expertise in production Python with testing, type hints, and performance optimization.
Use when writing Python code, debugging Python issues, or designing Python architectures.
```

### 3.3 Write Example Interactions

Provide 5-8 example prompts showing:
- Primary use cases
- Edge cases
- Complex scenarios
- Simple quick tasks
- Multi-step workflows

## Phase 4: Integration

### 4.1 Determine Plugin Placement

Decide where the agent belongs:
- Existing plugin that matches the domain?
- New plugin needed?
- Cross-plugin agent shared by multiple plugins?

### 4.2 Update Marketplace

```
Use: plugin-architect
Task: Update marketplace.json with new agent
```

Add agent reference to plugin's agents array:
```json
"agents": [
  "./agents/existing-agent.md",
  "./agents/{new-agent-name}.md"
]
```

### 4.3 Update Plugin Version

Increment version number:
- PATCH: Bug fixes or minor improvements
- MINOR: New agent or capability addition
- MAJOR: Breaking changes or major restructuring

## Phase 5: Validation

### 5.1 File Validation Checklist

- [ ] File name is kebab-case and lowercase
- [ ] YAML frontmatter is valid
- [ ] Name field matches file name (without .md)
- [ ] Description includes activation triggers
- [ ] Model is either "sonnet" or "haiku"
- [ ] All required sections are present
- [ ] No placeholder text remains

### 5.2 Content Quality Checklist

- [ ] Purpose is clear and specific
- [ ] Capabilities are comprehensive
- [ ] Behavioral traits define personality
- [ ] Knowledge base covers domain
- [ ] Response approach is actionable
- [ ] Examples demonstrate real use cases

### 5.3 Integration Checklist

- [ ] Agent is in correct plugin directory
- [ ] marketplace.json is updated
- [ ] Plugin version is incremented
- [ ] No duplicate agents exist
- [ ] Cross-references are accurate

## Output Format

When complete, provide:

1. **Agent File Path**: Full path to created file
2. **Agent Summary**: Brief description of capabilities
3. **Activation Examples**: 3 example prompts that would invoke this agent
4. **Integration Notes**: Any changes needed to other files
5. **Testing Recommendations**: How to validate the agent works correctly

## Success Criteria

Agent creation is successful when:
- Agent activates for intended use cases
- Responses are helpful and accurate
- No conflicts with existing agents
- Marketplace entry is complete
- Documentation is clear
