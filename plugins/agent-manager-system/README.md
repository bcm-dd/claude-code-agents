# Agent Manager System

Install and configure Claude Code agents, skills, hooks, and MCP integrations from the marketplace into your local projects.

## Quick Start

### Install an Agent

Ask Claude Code:
```
Install the python-pro agent for my FastAPI project
```

This will:
1. Find the agent in the marketplace
2. Add it to your `CLAUDE.md` file
3. Configure any recommended hooks

### Set Up Hooks

```
Set up auto-formatting hooks for my TypeScript project
```

This will create `.claude/settings.json` with:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "npx prettier --write \"$FILE_PATH\" && npx eslint --fix \"$FILE_PATH\""
      }]
    }]
  }
}
```

### Configure MCP Integration

```
Set up GitHub and Slack MCP servers for my project
```

## What Gets Installed Where

| Component | Location | Purpose |
|-----------|----------|---------|
| Agents | `CLAUDE.md` | Project instructions and behaviors |
| Commands | `.claude/commands/` | Custom slash commands |
| Hooks | `.claude/settings.json` | Automation on tool use |
| MCP Servers | `.claude/settings.json` | External integrations |

## Available Marketplace (66 Plugins)

### By Category

**Languages**
- `python-development` - Python 3.12+, Django, FastAPI, async patterns
- `javascript-typescript` - ES6+, Node.js, React, TypeScript
- `systems-programming` - Rust, Go, C, C++

**Infrastructure**
- `kubernetes-operations` - K8s, Helm, GitOps
- `cloud-infrastructure` - AWS, Azure, GCP, Terraform
- `cicd-automation` - GitHub Actions, GitLab CI

**Security**
- `security-scanning` - SAST, dependency scanning, OWASP
- `security-compliance` - SOC2, HIPAA, GDPR

**AI/ML**
- `llm-application-dev` - LangChain, prompt engineering, RAG
- `machine-learning-ops` - MLOps, model training, deployment

**Workflows**
- `git-pr-workflows` - PR enhancement, code review
- `tdd-workflows` - Test-driven development

### Browse All Plugins

```
What plugins are available for [your use case]?
```

Or explore the `plugins/` directory.

## Installation Methods

### Method 1: Install Agent to CLAUDE.md

The agent's instructions become part of your project context:

```
Install the backend-architect agent
```

Result in `CLAUDE.md`:
```markdown
## Backend Architecture

You are an expert backend architect...
[Full agent instructions]
```

### Method 2: Install Custom Command

Commands become available as `/command-name`:

```
Install the /tdd-cycle command from tdd-workflows
```

Result in `.claude/commands/tdd-cycle.md`

### Method 3: Configure Hooks

Hooks run automatically on tool use:

```
Add a hook to run tests after any Python file is modified
```

Result in `.claude/settings.json`:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "if [[ \"$FILE_PATH\" == *.py ]]; then pytest; fi"
      }]
    }]
  }
}
```

### Method 4: Configure MCP Servers

MCP servers connect Claude Code to external services:

```
Set up PostgreSQL MCP for database queries
```

Result in `.claude/settings.json`:
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

## Common Setup Scenarios

### Python FastAPI Project

```
Set up Claude Code for my FastAPI project with:
- Python pro agent
- Auto-formatting with ruff
- PostgreSQL MCP for database access
```

### TypeScript Next.js Project

```
Configure Claude Code for Next.js with:
- TypeScript agent
- ESLint and Prettier hooks
- GitHub MCP for PR management
```

### Kubernetes DevOps

```
Set up for Kubernetes work with:
- Kubernetes architect agent
- Terraform skill
- Security scanning hooks
```

## Commands

### /install-plugin

Install any plugin, agent, skill, or command from the marketplace:

```
/install-plugin python-development
/install-plugin kubernetes-architect agent
/install-plugin tdd-cycle command
```

### /create-agent

Create a custom agent when marketplace doesn't have what you need:

```
/create-agent A specialized agent for our internal deployment system
```

### /create-skill

Create a custom skill with domain knowledge:

```
/create-skill Our company's API design standards
```

### /create-plugin

Create a complete plugin with multiple components:

```
/create-plugin A complete plugin for our microservices architecture
```

## Skills

### claude-code-local-setup

Complete guide to Claude Code configuration:
- CLAUDE.md structure and best practices
- .claude/settings.json configuration
- Hook types and patterns
- MCP server setup
- Permission configuration

### agent-design-patterns

How to create effective agents:
- Model selection (Haiku vs Sonnet)
- Activation triggers
- Capability organization
- Behavioral traits

### hook-development-patterns

Automation with hooks:
- PreToolUse (validation, blocking)
- PostToolUse (formatting, testing)
- UserPromptSubmit (context injection)
- Stop (cleanup, continuation)

### mcp-server-patterns

External integrations:
- GitHub, GitLab
- JIRA, Linear
- PostgreSQL, MongoDB
- Slack, Discord

### github-actions-workflows

CI/CD with Claude Code:
- PR review automation
- Documentation sync
- Code quality audits
- Dependency updates

## File Structure

```
plugins/agent-manager-system/
├── agents/
│   ├── agent-manager.md          # Main installation/creation agent
│   └── plugin-architect.md       # Plugin design specialist
├── commands/
│   ├── install-plugin.md         # Install from marketplace
│   ├── create-agent.md           # Create new agent
│   ├── create-skill.md           # Create new skill
│   └── create-plugin.md          # Create complete plugin
└── skills/
    ├── claude-code-local-setup/  # Local configuration guide
    ├── agent-design-patterns/    # Agent creation patterns
    ├── skill-development-patterns/
    ├── hook-development-patterns/
    ├── mcp-server-patterns/
    └── github-actions-workflows/
```

## Quick Reference

### Project Setup Checklist

```bash
# 1. Create Claude Code directory
mkdir -p .claude/commands

# 2. Create project instructions
touch CLAUDE.md

# 3. Create settings file
echo '{"hooks": {}, "mcpServers": {}}' > .claude/settings.json
```

### Common Hooks

**Auto-format on save:**
```json
{"hooks": {"PostToolUse": [{"matcher": "Write", "hooks": [{"type": "command", "command": "npm run format"}]}]}}
```

**Run tests on change:**
```json
{"hooks": {"PostToolUse": [{"matcher": "Write|Edit", "hooks": [{"type": "command", "command": "npm test"}]}]}}
```

**Inject context on prompt:**
```json
{"hooks": {"UserPromptSubmit": [{"hooks": [{"type": "command", "command": "cat .claude/context.md"}]}]}}
```

### Common MCP Servers

**GitHub:**
```json
{"mcpServers": {"github": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"], "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"}}}}
```

**PostgreSQL:**
```json
{"mcpServers": {"postgres": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-postgres"], "env": {"DATABASE_URL": "${DATABASE_URL}"}}}}
```

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [MCP Specification](https://modelcontextprotocol.io)
- [Plugin Marketplace](../../plugins/)
- [Architecture Guide](../../docs/architecture.md)
