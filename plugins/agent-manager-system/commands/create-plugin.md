# Create Complete Claude Code Plugin

Comprehensive workflow for designing and implementing a complete Claude Code plugin with agents, commands, skills, and marketplace integration.

[Extended thinking: Creating a complete plugin requires holistic design thinking, balancing single responsibility principle with comprehensive functionality. Success depends on proper component organization, clear agent-skill relationships, effective command orchestration, and complete marketplace integration.]

## Prerequisites

$ARGUMENTS - Description of the plugin to create (domain, capabilities, target users)

## Configuration Options

### Complexity Level
- **Micro** (1-2 agents): Single focused capability
- **Standard** (3-5 agents): Domain-specific workflows
- **Enterprise** (6+ agents): Complex multi-workflow systems

### Plugin Type
- **Language**: Programming language support
- **Infrastructure**: Cloud/DevOps capabilities
- **Security**: Security scanning/compliance
- **Workflow**: Automation workflows
- **Domain**: Specialized domain (payments, blockchain, etc.)

## Phase 1: Plugin Architecture

### 1.1 Define Plugin Purpose
```
Use: plugin-architect
Task: Design plugin architecture and scope
```

Document:
- **Domain**: What area does this plugin cover?
- **Target users**: Who will use this plugin?
- **Core value**: What problem does it solve?
- **Differentiator**: What makes this unique from existing plugins?

### 1.2 Analyze Existing Plugins

Research the marketplace:
- Identify related plugins
- Find potential overlaps
- Discover collaboration opportunities
- Determine unique positioning

### 1.3 Design Component Structure

Plan the plugin layout:
```
plugins/{plugin-name}/
├── agents/
│   ├── {primary-agent}.md
│   ├── {supporting-agent-1}.md
│   └── {supporting-agent-2}.md
├── commands/
│   ├── {main-workflow}.md
│   └── {secondary-workflow}.md
└── skills/
    ├── {core-skill}/
    │   ├── SKILL.md
    │   ├── assets/
    │   └── references/
    └── {advanced-skill}/
        └── SKILL.md
```

### 1.4 Map Component Relationships

Document how components interact:

```
Agent Relationships:
- {primary-agent} orchestrates {supporting-agent-1} and {supporting-agent-2}
- {supporting-agent-1} uses {core-skill} for knowledge
- {main-workflow} coordinates all agents

Skill Dependencies:
- {advanced-skill} builds on {core-skill}
- Both skills reference {primary-agent} capabilities
```

## Phase 2: Agent Development

### 2.1 Design Primary Agent

The main agent that represents the plugin's core functionality:
```
Use: agent-manager
Task: Create primary agent for {domain}
```

Primary agent characteristics:
- Comprehensive capabilities for the domain
- Sonnet model for complex reasoning
- Clear activation triggers
- Orchestration of supporting agents

### 2.2 Design Supporting Agents

Specialized agents for specific tasks:
```
Use: agent-manager
Task: Create supporting agent for {specific-capability}
```

Supporting agent characteristics:
- Focused, single-purpose functionality
- Haiku model for fast execution tasks
- Clear handoff patterns from primary agent
- Specific expertise areas

### 2.3 Define Agent Collaboration

Document how agents work together:
- Primary agent delegates to supporting agents
- Context handoff protocols
- Result aggregation patterns
- Error handling and escalation

## Phase 3: Skill Development

### 3.1 Identify Core Skills

Determine essential knowledge areas:
- What domain knowledge is needed?
- What patterns should be documented?
- What best practices should be included?
- What resources would be valuable?

### 3.2 Create Core Skill
```
Use: agent-manager
Task: Create core skill for {fundamental-topic}
```

Core skill focus:
- Fundamental concepts and patterns
- Quick start guides
- Essential best practices
- Common pitfall documentation

### 3.3 Create Advanced Skills
```
Use: agent-manager
Task: Create advanced skill for {advanced-topic}
```

Advanced skill focus:
- Complex patterns and techniques
- Performance optimization
- Production considerations
- Integration patterns

### 3.4 Develop Skill Resources

Create supporting materials:
- Templates in `assets/`
- Checklists and guides
- Reference documentation
- Code examples

## Phase 4: Command Development

### 4.1 Design Main Workflow
```
Use: agent-manager
Task: Create main workflow command for {primary-use-case}
```

Main workflow characteristics:
- Multi-phase execution
- Agent orchestration
- Configuration options
- Clear output format

### 4.2 Design Secondary Workflows

Additional workflows for specific scenarios:
- Specialized use cases
- Quick operations
- Maintenance tasks
- Validation workflows

### 4.3 Define Workflow Phases

Structure each command:
```markdown
## Phase 1: {Analysis/Setup}
- Gather requirements
- Validate inputs
- Prepare context

## Phase 2: {Core Execution}
- Primary agent work
- Supporting agent delegation
- Skill application

## Phase 3: {Validation/Output}
- Result validation
- Output formatting
- Success criteria check
```

## Phase 5: Plugin Implementation

### 5.1 Create Directory Structure

```bash
mkdir -p plugins/{plugin-name}/{agents,commands,skills/{skill-1,skill-2}}
```

### 5.2 Implement Components

Create all files:
1. Agent files in `agents/`
2. Command files in `commands/`
3. SKILL.md files in skill directories
4. Supporting resources in `assets/` and `references/`

### 5.3 Validate File Structure

Ensure all files follow conventions:
- kebab-case naming
- Valid YAML frontmatter
- Complete required sections
- Proper cross-references

## Phase 6: Marketplace Integration

### 6.1 Create Marketplace Entry
```
Use: plugin-architect
Task: Create marketplace.json entry for {plugin-name}
```

Entry structure:
```json
{
  "name": "{plugin-name}",
  "source": "./plugins/{plugin-name}",
  "description": "{Comprehensive description}",
  "version": "1.0.0",
  "author": {
    "name": "{Author Name}",
    "url": "{GitHub URL}"
  },
  "homepage": "{Repository URL}",
  "repository": "{Repository URL}",
  "license": "MIT",
  "keywords": ["{keyword1}", "{keyword2}", "{keyword3}"],
  "category": "{category}",
  "strict": false,
  "commands": [
    "./commands/{command-1}.md",
    "./commands/{command-2}.md"
  ],
  "agents": [
    "./agents/{agent-1}.md",
    "./agents/{agent-2}.md"
  ],
  "skills": [
    "./skills/{skill-1}",
    "./skills/{skill-2}"
  ]
}
```

### 6.2 Select Keywords

Choose discoverable keywords:
- Domain terms
- Technology names
- Use case descriptions
- Related concepts

### 6.3 Assign Category

Select from standard categories:
- development, languages, infrastructure, security
- operations, ai-ml, quality, documentation
- data, database, testing, workflows
- utilities, modernization, performance, api
- marketing, business, blockchain, finance
- gaming, accessibility, payments

## Phase 7: Validation

### 7.1 Structure Validation

- [ ] All directories created correctly
- [ ] All files in correct locations
- [ ] Naming conventions followed
- [ ] No duplicate names

### 7.2 Content Validation

- [ ] All YAML frontmatter valid
- [ ] All required sections present
- [ ] No placeholder text remaining
- [ ] Code examples are complete

### 7.3 Integration Validation

- [ ] marketplace.json entry complete
- [ ] All file paths correct
- [ ] Version number appropriate
- [ ] Keywords and category assigned

### 7.4 Functionality Validation

- [ ] Agents activate correctly
- [ ] Skills provide useful knowledge
- [ ] Commands orchestrate properly
- [ ] Cross-references work

## Output Format

When complete, provide:

1. **Plugin Summary**
   - Name and category
   - Component counts
   - Primary capabilities

2. **File Manifest**
   - Complete list of created files
   - File sizes and line counts

3. **Component Details**
   - Agent descriptions
   - Skill summaries
   - Command workflows

4. **Marketplace Entry**
   - Complete JSON entry
   - Ready for insertion

5. **Usage Examples**
   - How to use each component
   - Common workflows

6. **Testing Recommendations**
   - Validation steps
   - Test scenarios

## Success Criteria

Plugin creation is successful when:
- All components follow conventions
- Agents work individually and together
- Skills provide valuable knowledge
- Commands orchestrate effectively
- Marketplace entry is complete
- Documentation is clear
- No conflicts with existing plugins
