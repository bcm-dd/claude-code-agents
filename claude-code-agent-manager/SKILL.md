---
name: agent-manager
description: Install and manage Claude Code agents, skills, commands, hooks, and MCP servers. Search the claude-code-agents marketplace, install components locally, configure automation, and proactively create new skills from debugging discoveries. Use when setting up Claude Code, installing plugins, or extracting knowledge from sessions.
---

# Agent Manager

Install agents, skills, and commands from the claude-code-agents marketplace into your local Claude Code instance. Create new skills automatically from your debugging discoveries.

## When to Use This Skill

- Installing agents or skills from a marketplace
- Searching for Claude Code plugins by keyword
- Setting up CLAUDE.md, hooks, or MCP servers
- Configuring Claude Code for a new project
- Extracting reusable knowledge from debugging sessions
- Creating new custom agents or skills

## Core Capabilities

### 1. Marketplace Search

Search the claude-code-agents marketplace using tool calls:

```bash
# Search agents by keyword
Grep: pattern="kubernetes|k8s" path="~/.claude/skills/agent-manager/marketplace" glob="**/agents/*.md"

# Search skills
Grep: pattern="async|await" path="~/.claude/skills/agent-manager/marketplace" glob="**/skills/**/SKILL.md"

# Browse a plugin
Glob: ~/.claude/skills/agent-manager/marketplace/plugins/python-development/**/*.md
```

### 2. Local Installation

**Install Agent to CLAUDE.md:**
```bash
# Read the agent content
Read: ~/.claude/skills/agent-manager/marketplace/plugins/{plugin}/agents/{agent}.md

# Append to project CLAUDE.md (use Edit tool or manual copy)
```

**Install Skill (3 options):**

Option A - Key sections to CLAUDE.md (recommended):
```markdown
## Async Python Patterns

When writing async Python:
- Use `async def` for I/O-bound operations
- Prefer `asyncio.gather()` for concurrent tasks
[Extract key sections from skill]
```

Option B - Full copy to .claude/skills/:
```bash
mkdir -p .claude/skills
cp -r ~/.claude/skills/agent-manager/marketplace/plugins/{plugin}/skills/{skill} .claude/skills/
```

Option C - Reference only:
```markdown
## Skills Reference
For async patterns, see: ~/.claude/skills/agent-manager/marketplace/plugins/python-development/skills/async-patterns/
```

**Install Command:**
```bash
mkdir -p .claude/commands
cp ~/.claude/skills/agent-manager/marketplace/plugins/{plugin}/commands/{cmd}.md .claude/commands/
```

### 3. Configure Hooks

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "npm run format 2>/dev/null || true"
      }]
    }]
  }
}
```

Common hook patterns:
- **Auto-format**: Run prettier/eslint after Write
- **Auto-test**: Run tests after file changes
- **Lint check**: Validate before commits
- **Context injection**: Add project context on prompt

### 4. Configure MCP Servers

Add to `.claude/settings.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"}
    }
  }
}
```

### 5. Proactive Skill Creation

After completing debugging or problem-solving, evaluate:

1. Did this require non-obvious investigation?
2. Is the solution reusable for future similar problems?
3. Did I discover something beyond standard documentation?

**If YES to any**, create a skill file:

```markdown
---
name: problem-name-kebab-case
description: Specific description with error messages and trigger conditions for semantic matching.
version: 1.0.0
date: YYYY-MM-DD
---

# Problem Title

## Problem
Exact problem description with error messages.

## Trigger Conditions
- When this skill should activate

## Solution
Step-by-step solution with code.

## Verification
How to confirm it worked.
```

**Save locations:**
- `~/.claude/skills/` - User-level (all projects)
- `.claude/skills/` - Project-level (this project only)

**Quality gates - only save if:**
- Reusable across contexts
- Non-trivial (required discovery)
- Specific with trigger conditions
- Actually verified to work

## Quick Reference

### Project Structure
```
your-project/
├── .claude/
│   ├── settings.json      # Hooks, MCP, permissions
│   ├── commands/          # Custom slash commands
│   └── skills/            # Project-specific skills
├── CLAUDE.md              # Project instructions
└── ...
```

### Common Hooks
```json
{"hooks": {"PostToolUse": [{"matcher": "Write", "hooks": [{"type": "command", "command": "npm run format"}]}]}}
```

### Common MCP Servers
```json
{"mcpServers": {"github": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"], "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"}}}}
```

## Marketplace Reference

The marketplace contains 66+ plugins across categories:

**Languages**: python-development, javascript-typescript, systems-programming
**Infrastructure**: kubernetes-operations, cloud-infrastructure, cicd-automation
**Security**: security-scanning, security-compliance
**AI/ML**: llm-application-dev, machine-learning-ops
**Workflows**: git-pr-workflows, tdd-workflows

## Example Interactions

- "Install the python-pro agent for my FastAPI project"
- "Search for Kubernetes skills in the marketplace"
- "Set up auto-formatting hooks for TypeScript"
- "Configure GitHub MCP for PR management"
- "Save what we learned about connection pooling as a skill"
- "Create a custom agent for our deployment workflow"

## Resources

- **patterns/hooks.md**: Hook development patterns
- **patterns/mcp.md**: MCP server configuration
- **patterns/skills.md**: Skill development patterns
- **patterns/agents.md**: Agent design patterns
- **marketplace/**: Full plugin marketplace (if cloned)
