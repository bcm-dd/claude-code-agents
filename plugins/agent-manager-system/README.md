# Agent Manager System

A comprehensive Claude Code plugin for developing agents, skills, commands, hooks, and MCP integrations. This plugin serves as the meta-toolkit for extending Claude Code's capabilities.

## Overview

The Agent Manager System provides everything you need to create production-ready Claude Code extensions:

| Component | Count | Description |
|-----------|-------|-------------|
| Agents | 2 | Core agents for development and architecture |
| Commands | 3 | Workflows for creating agents, skills, and plugins |
| Skills | 5 | Patterns for agents, skills, hooks, MCP, and CI/CD |

## Quick Start

### Creating a New Agent

Ask Claude Code to create an agent:

```
Create an agent for Kubernetes troubleshooting that diagnoses pod failures,
analyzes logs, and suggests fixes.
```

The `agent-manager` agent will:
1. Design the agent structure with proper capabilities
2. Select the appropriate model (Haiku vs Sonnet)
3. Create activation triggers for automatic selection
4. Generate the complete agent file

### Creating a New Skill

```
Create a skill for React testing patterns covering unit tests,
integration tests, and component testing with React Testing Library.
```

The workflow will create:
- Progressive disclosure structure (metadata → instructions → resources)
- Core concepts and quick start guide
- Fundamental and advanced patterns with code examples
- Common pitfalls and testing recommendations

### Creating a Complete Plugin

```
Design a complete plugin for GraphQL development with schema design,
resolver patterns, and testing capabilities.
```

This orchestrates the full plugin creation:
- Plugin architecture design
- Multiple agents for different responsibilities
- Skills for domain knowledge
- Commands for workflows
- Marketplace integration

## Agents

### agent-manager

**Model:** Sonnet (complex reasoning)

The core agent for Claude Code development. Use for:

- Creating new agents with proper structure and conventions
- Building skills with progressive disclosure architecture
- Designing commands that orchestrate multi-agent workflows
- Implementing hooks for automation (PreToolUse, PostToolUse, etc.)
- Setting up MCP server integrations
- Creating GitHub Actions workflows

**Example prompts:**
```
"Create an agent for database migration that handles schema changes safely"
"Build a skill for AWS Lambda development patterns"
"Implement a PreToolUse hook that validates SQL queries before execution"
"Set up an MCP integration for Linear issue tracking"
```

### plugin-architect

**Model:** Sonnet (architectural planning)

Strategic plugin design specialist. Use for:

- Designing plugin structures and component organization
- Planning agent-skill-command relationships
- Creating marketplace entries with proper metadata
- Splitting large plugins into focused smaller ones
- Designing plugin ecosystems

**Example prompts:**
```
"Design a plugin structure for microservices development"
"How should I organize a security testing plugin with multiple scanning types?"
"Review this plugin structure and suggest improvements"
"Plan a plugin ecosystem for full DevOps automation"
```

## Commands

### /create-agent

Systematic workflow for creating new agents.

**Phases:**
1. Requirements gathering and use case analysis
2. Capability design and model selection
3. Behavioral trait definition
4. Knowledge base specification
5. File generation and validation

**Usage:**
```
/create-agent A Python optimization agent that profiles code and suggests performance improvements
```

### /create-skill

Workflow for creating skills with progressive disclosure.

**Phases:**
1. Skill scope and activation trigger design
2. Core concept identification
3. Pattern development (fundamental → advanced)
4. Resource organization (assets, references)
5. Testing and pitfall documentation

**Usage:**
```
/create-skill Docker containerization patterns for Python applications
```

### /create-plugin

Comprehensive plugin creation workflow.

**Phases:**
1. Plugin architecture design
2. Agent development (primary + supporting)
3. Skill development
4. Command development
5. Marketplace integration
6. Validation and testing

**Usage:**
```
/create-plugin A payment processing plugin with Stripe, PayPal, and subscription billing support
```

## Skills

### agent-design-patterns

Patterns for creating effective Claude Code agents.

**Topics covered:**
- Model selection strategy (Haiku vs Sonnet)
- Activation trigger design
- Capability organization
- Behavioral trait definition
- Knowledge base structuring
- Multi-agent collaboration patterns

**When activated:** Creating agents, optimizing agent performance, designing agent workflows

### skill-development-patterns

Patterns for building skills with progressive disclosure.

**Topics covered:**
- Three-tier architecture (metadata, instructions, resources)
- Activation trigger design
- Content organization best practices
- Code example patterns
- Resource hierarchy (assets, references)
- Building-block patterns for composable skills

**When activated:** Creating skills, organizing domain knowledge, building educational content

### hook-development-patterns

Claude Code hook automation patterns.

**Hook types covered:**

| Hook | Trigger | Use Cases |
|------|---------|-----------|
| PreToolUse | Before tool execution | Validation, blocking, modification |
| PostToolUse | After tool execution | Auto-formatting, testing, notifications |
| UserPromptSubmit | On user input | Context injection, skill suggestions |
| Stop | On stop signal | Cleanup, conditional continuation |

**Example hooks:**
- Auto-format code after Write operations
- Run tests after file modifications
- Validate branch names before git operations
- Inject project context on every prompt

### mcp-server-patterns

MCP (Model Context Protocol) integration patterns.

**Integration categories:**
- Issue tracking (JIRA, Linear, GitHub Issues)
- Code platforms (GitHub, GitLab)
- Databases (PostgreSQL, MongoDB, Redis)
- Communication (Slack, Discord)
- Custom servers

**Topics covered:**
- Server configuration
- Authentication patterns
- Tool definition
- Error handling
- Multi-server orchestration

### github-actions-workflows

CI/CD automation with Claude Code.

**Workflow patterns:**
- Automated PR review on pull requests
- Scheduled documentation sync (monthly)
- Weekly code quality audits
- Biweekly dependency updates
- Security scanning pipelines

**Example workflow:**
```yaml
name: Claude Code PR Review
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm install -g @anthropic-ai/claude-code
      - name: Review PR
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: claude-code --print "Review this PR..."
```

## File Structure

```
plugins/agent-manager-system/
├── agents/
│   ├── agent-manager.md          # Core development agent
│   └── plugin-architect.md       # Architecture specialist
├── commands/
│   ├── create-agent.md           # Agent creation workflow
│   ├── create-skill.md           # Skill creation workflow
│   └── create-plugin.md          # Plugin creation workflow
└── skills/
    ├── agent-design-patterns/
    │   └── SKILL.md
    ├── skill-development-patterns/
    │   └── SKILL.md
    ├── hook-development-patterns/
    │   └── SKILL.md
    ├── mcp-server-patterns/
    │   └── SKILL.md
    └── github-actions-workflows/
        └── SKILL.md
```

## Common Workflows

### 1. Create a Domain-Specific Agent

```
I need an agent for Terraform infrastructure management that can:
- Generate Terraform configurations
- Review existing infrastructure code
- Suggest security improvements
- Handle state management best practices
```

### 2. Build a Knowledge Skill

```
Create a skill for PostgreSQL optimization covering:
- Query performance tuning
- Index design patterns
- Connection pooling
- Partitioning strategies
```

### 3. Set Up Automation Hooks

```
Implement hooks that:
- Run ESLint after every TypeScript file is written
- Block commits to main branch
- Add JIRA ticket context to every prompt
```

### 4. Configure MCP Integration

```
Set up MCP integration for our development workflow:
- GitHub for code and PRs
- Linear for issue tracking
- Slack for notifications
```

### 5. Create CI/CD Pipeline

```
Design a GitHub Actions workflow that:
- Reviews PRs with Claude Code
- Runs weekly security audits
- Updates documentation monthly
```

## Best Practices

### Agent Design
- Use **Sonnet** for complex reasoning, architecture, and review tasks
- Use **Haiku** for fast execution, code generation, and deterministic tasks
- Include clear activation triggers in descriptions
- Define specific capabilities rather than broad claims

### Skill Design
- Start with "When to Use This Skill" section
- Provide quick start examples early
- Progress from fundamental to advanced patterns
- Include common pitfalls and testing guidance

### Hook Design
- Keep hooks fast to avoid blocking workflows
- Use exit codes for pass/fail signaling
- Log actions for debugging
- Handle errors gracefully

### Plugin Design
- Follow single responsibility principle
- Average 3-4 components per plugin
- Use clear, discoverable keywords
- Document cross-plugin dependencies

## Contributing

When adding to this plugin:

1. Follow existing file naming conventions (kebab-case)
2. Include complete YAML frontmatter
3. Add activation triggers to descriptions
4. Update marketplace.json
5. Test all cross-references

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [MCP Specification](https://modelcontextprotocol.io)
- [Plugin Architecture Guide](../../docs/architecture.md)
- [Agent Reference](../../docs/agents.md)
