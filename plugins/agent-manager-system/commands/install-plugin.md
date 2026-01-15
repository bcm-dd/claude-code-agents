# Install Claude Code Plugin Locally

Install agents, skills, commands, and hooks from this marketplace into your local Claude Code instance.

## Prerequisites

$ARGUMENTS - Plugin name, agent name, or skill name to install (or "list" to see available)

## What Gets Installed

Claude Code uses these local configuration locations:

| Location | Purpose |
|----------|---------|
| `.claude/` | Project-specific Claude Code configuration |
| `.claude/settings.json` | Hooks, permissions, MCP servers |
| `.claude/commands/` | Custom slash commands |
| `CLAUDE.md` | Project instructions and context |
| `~/.claude/settings.json` | Global user settings |

## Phase 1: Discovery

### 1.1 List Available Plugins

To see what's available for installation:

```bash
# In the claude-code-agents repository
ls plugins/
```

Or ask Claude Code:
```
What plugins are available in the agent-manager-system marketplace?
```

### 1.2 Explore Plugin Contents

For a specific plugin:
```
Show me what's in the python-development plugin
```

This displays:
- Agents and their capabilities
- Skills and what they teach
- Commands and workflows

## Phase 2: Installation Methods

### Method A: Copy Agent Instructions to CLAUDE.md

The simplest installation - add agent instructions to your project:

```markdown
# In your project's CLAUDE.md file

## Python Development Agent

You are an expert Python developer specializing in modern Python 3.12+...

[Copy the full agent content from plugins/python-development/agents/python-pro.md]
```

### Method B: Install Custom Commands

Copy command files to your local `.claude/commands/` directory:

```bash
# Create commands directory
mkdir -p .claude/commands

# Copy a command
cp path/to/claude-code-agents/plugins/python-development/commands/python-scaffold.md \
   .claude/commands/python-scaffold.md
```

Now `/python-scaffold` is available in your project.

### Method C: Configure Hooks

Add hooks to `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Validating write operation...'"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "npm run lint:fix 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

### Method D: Configure MCP Servers

Add MCP servers to `.claude/settings.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
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

## Phase 3: Full Plugin Installation

### 3.1 Create Project Structure

```bash
# Create Claude Code directories
mkdir -p .claude/commands
mkdir -p .claude/skills

# Create or update settings
touch .claude/settings.json
touch CLAUDE.md
```

### 3.2 Install a Complete Plugin

Example: Installing the `python-development` plugin:

```bash
PLUGIN="python-development"
SOURCE="path/to/claude-code-agents/plugins/$PLUGIN"

# Copy commands
cp $SOURCE/commands/*.md .claude/commands/ 2>/dev/null || true

# Append agent instructions to CLAUDE.md
echo "" >> CLAUDE.md
echo "# Python Development" >> CLAUDE.md
cat $SOURCE/agents/python-pro.md >> CLAUDE.md
```

### 3.3 Install Skills as Context

Skills provide knowledge - add them to CLAUDE.md:

```markdown
# In CLAUDE.md

## Async Python Patterns

When working with async Python code, follow these patterns:

[Include relevant sections from the skill]
```

## Phase 4: Verification

### 4.1 Verify Commands

```bash
# List installed commands
ls .claude/commands/

# Test a command in Claude Code
/python-scaffold
```

### 4.2 Verify Hooks

```bash
# Check settings
cat .claude/settings.json | jq '.hooks'

# Test by triggering a tool
# (hooks run automatically)
```

### 4.3 Verify MCP Servers

```bash
# Check MCP configuration
cat .claude/settings.json | jq '.mcpServers'

# In Claude Code, MCP tools appear automatically
```

## Quick Install Scripts

### Install Single Agent

```bash
#!/bin/bash
# install-agent.sh <plugin> <agent>
PLUGIN=$1
AGENT=$2
SOURCE="path/to/claude-code-agents/plugins/$PLUGIN/agents/$AGENT.md"

echo "" >> CLAUDE.md
echo "---" >> CLAUDE.md
cat "$SOURCE" >> CLAUDE.md
echo "Agent $AGENT installed to CLAUDE.md"
```

### Install Single Command

```bash
#!/bin/bash
# install-command.sh <plugin> <command>
PLUGIN=$1
COMMAND=$2
SOURCE="path/to/claude-code-agents/plugins/$PLUGIN/commands/$COMMAND.md"

mkdir -p .claude/commands
cp "$SOURCE" ".claude/commands/$COMMAND.md"
echo "Command /$COMMAND installed"
```

### Install Hooks from Template

```bash
#!/bin/bash
# install-hooks.sh <hook-type>
# Creates .claude/settings.json with common hooks

cat > .claude/settings.json << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "npm run format 2>/dev/null || npx prettier --write \"$TOOL_INPUT\" 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
EOF
echo "Hooks installed to .claude/settings.json"
```

## Common Installation Scenarios

### Scenario 1: Python Project Setup

```
Install the python-development plugin for my FastAPI project.
I want:
- Python pro agent for code assistance
- Async patterns skill for async/await guidance
- Auto-formatting hook for Python files
```

### Scenario 2: Full-Stack JavaScript

```
Set up Claude Code for my Next.js project with:
- TypeScript agent from javascript-typescript plugin
- React patterns from frontend skills
- ESLint hook to auto-fix on save
- GitHub MCP for PR management
```

### Scenario 3: DevOps Automation

```
Configure Claude Code for infrastructure work:
- Kubernetes agent for k8s operations
- Terraform skill for IaC patterns
- Pre-commit hooks for security scanning
- JIRA MCP for ticket integration
```

## Output Format

After installation, provide:

1. **Installed Components**
   - List of agents added to CLAUDE.md
   - List of commands in .claude/commands/
   - Hooks configured
   - MCP servers added

2. **Configuration Files**
   - Show .claude/settings.json content
   - Show relevant CLAUDE.md sections

3. **Verification Steps**
   - How to test each component
   - Expected behavior

4. **Usage Examples**
   - Example prompts for agents
   - Example command invocations
