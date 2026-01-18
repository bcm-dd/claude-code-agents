---
name: agent-manager
description: |
  Install and manage Claude Code agents, skills, commands, hooks, and MCP servers.
  Search the marketplace, install components locally, and extract knowledge from sessions.
  Use when setting up Claude Code, installing plugins, or running /retrospective.
---

# Agent Manager

Install agents and skills from marketplaces. Extract knowledge from debugging sessions.
Configure hooks and MCP servers for automation.

## Quick Start

### Find Available Skills
```bash
# Check skill index first (fast)
Read: ~/.claude/skills/INDEX.md

# Or search marketplace
Grep: pattern="kubernetes" path="~/.claude/skills/agent-manager/marketplace" glob="**/*.md"
```

### Install a Skill
```bash
# Read full skill
Read: ~/.claude/skills/agent-manager/marketplace/plugins/{plugin}/skills/{skill}/SKILL.md

# Copy to project
mkdir -p .claude/skills && cp -r {source} .claude/skills/
```

### Extract Knowledge
After debugging, run `/retrospective` or ask to "save this as a skill".

---

## Efficient Skill Discovery

### Method 1: Skill Index (Recommended)

Read the auto-generated index for fast lookup:
```bash
Read: ~/.claude/skills/INDEX.md
```

The index lists all installed skills with descriptions. Read full skill only when needed.

**Regenerate index after adding skills:**
```bash
~/.claude/skills/agent-manager/scripts/generate-skill-index.sh
```

### Method 2: Marketplace Search

Search by keyword:
```bash
# Search agents
Grep: pattern="python|fastapi" path="~/.claude/skills/agent-manager/marketplace" glob="**/agents/*.md"

# Search skills
Grep: pattern="async|concurrent" path="~/.claude/skills/agent-manager/marketplace" glob="**/skills/**/SKILL.md"

# Browse plugin
Glob: ~/.claude/skills/agent-manager/marketplace/plugins/python-development/**/*.md
```

---

## Installation Methods

### Agents → CLAUDE.md

```bash
# Read agent
Read: ~/.claude/skills/agent-manager/marketplace/plugins/{plugin}/agents/{agent}.md

# Append key sections to CLAUDE.md
Edit: CLAUDE.md - add agent role and capabilities
```

### Skills → .claude/skills/

**Option A: Full copy (recommended for frequent use)**
```bash
mkdir -p .claude/skills
cp -r ~/.claude/skills/agent-manager/marketplace/plugins/{plugin}/skills/{skill} .claude/skills/
```

**Option B: Key sections to CLAUDE.md**
```markdown
## Python Async Patterns
When writing async Python:
- Use `async def` for I/O-bound operations
- Prefer `asyncio.gather()` for concurrent tasks
```

**Option C: Reference only**
```markdown
For async patterns, see: ~/.claude/skills/agent-manager/marketplace/plugins/python-development/skills/async-patterns/
```

### Commands → .claude/commands/

```bash
mkdir -p .claude/commands
cp ~/.claude/skills/agent-manager/marketplace/plugins/{plugin}/commands/{cmd}.md .claude/commands/
```

---

## Continuous Learning

### Automatic Evaluation

After completing work, evaluate:
1. Did this require **non-obvious** investigation?
2. Is the solution **reusable** for similar problems?
3. Did I discover something **beyond documentation**?

**If YES** → Extract as a skill.

### Quality Gates

Only extract if:
- ✓ Reusable across contexts
- ✓ Non-trivial (required discovery)
- ✓ Specific with trigger conditions
- ✓ Actually verified to work

### Skill Template

```bash
Read: ~/.claude/skills/agent-manager/templates/skill-template.md
```

### Save Locations

| Scope | Location | Use When |
|-------|----------|----------|
| User | `~/.claude/skills/{name}/SKILL.md` | Useful across all projects |
| Project | `.claude/skills/{name}/SKILL.md` | Project-specific knowledge |

### /retrospective Command

Explicitly review session and extract skills:
```bash
Read: ~/.claude/skills/agent-manager/commands/retrospective.md
```

---

## Hooks Configuration

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "npm run format \"$FILE_PATH\" 2>/dev/null || true"
      }]
    }],
    "UserPromptSubmit": [{
      "hooks": [{
        "type": "command",
        "command": "~/.claude/hooks/continuous-learning-activator.sh"
      }]
    }]
  }
}
```

**Install continuous learning hook:**
```bash
mkdir -p ~/.claude/hooks
cp ~/.claude/skills/agent-manager/scripts/continuous-learning-activator.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/continuous-learning-activator.sh
```

---

## MCP Servers

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

See `patterns/mcp.md` for more servers.

---

## Reference Files

| File | Purpose |
|------|---------|
| `patterns/hooks.md` | Hook development patterns |
| `patterns/mcp.md` | MCP server configuration |
| `patterns/skills.md` | Skill creation patterns |
| `patterns/agents.md` | Agent design patterns |
| `templates/skill-template.md` | Template for new skills |
| `commands/retrospective.md` | Knowledge extraction workflow |
| `scripts/generate-skill-index.sh` | Regenerate skill index |
| `scripts/continuous-learning-activator.sh` | Prompt hook for learning |
| `examples/` | Example extracted skills |

---

## Example Interactions

- "Search for Kubernetes skills"
- "Install the python-pro agent"
- "Set up auto-formatting hooks"
- "Configure GitHub MCP"
- "Save this solution as a skill"
- "/retrospective"
