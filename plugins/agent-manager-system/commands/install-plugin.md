# Install Claude Code Plugin Locally

Install agents, skills, commands, and hooks from this marketplace into your local Claude Code instance.

## Prerequisites

$ARGUMENTS - Plugin name, agent name, or skill name to install (or "search [query]" to find)

## What Gets Installed Where

| Component | Location | Purpose |
|-----------|----------|---------|
| Agents | `CLAUDE.md` | Project instructions and AI behaviors |
| Skills | `CLAUDE.md` or `.claude/skills/` | Domain knowledge and patterns |
| Commands | `.claude/commands/` | Custom slash commands |
| Hooks | `.claude/settings.json` | Automation on tool use |
| MCP Servers | `.claude/settings.json` | External integrations |

## Phase 1: Search & Discovery

Use Claude Code's tools to search the marketplace for what you need.

### 1.1 Search by Keyword

To find plugins/agents/skills for a specific need:

```
Search the marketplace for Kubernetes agents
```

**Behind the scenes**, use Glob and Grep to search:

```bash
# Find all plugins
Glob: plugins/*/

# Search agent descriptions for keywords
Grep: pattern="kubernetes|k8s" path="plugins/" glob="**/agents/*.md"

# Search skill descriptions
Grep: pattern="kubernetes|k8s" path="plugins/" glob="**/skills/**/SKILL.md"

# Search commands
Grep: pattern="kubernetes|k8s" path="plugins/" glob="**/commands/*.md"
```

### 1.2 Browse by Category

Categories available:
- **languages**: python, javascript, typescript, rust, go, java, etc.
- **infrastructure**: kubernetes, cloud, terraform, cicd
- **security**: scanning, compliance, api-security
- **ai-ml**: llm-development, machine-learning, prompt-engineering
- **workflows**: git, tdd, code-review
- **data**: engineering, validation, database
- **operations**: incident-response, monitoring, debugging

```
# List all plugins in a category
Grep: pattern="category.*infrastructure" path=".claude-plugin/marketplace.json"
```

### 1.3 Explore Specific Plugin

Read the plugin contents:

```
# List plugin components
Glob: plugins/python-development/**/*.md

# Read agent details
Read: plugins/python-development/agents/python-pro.md

# Read skill content
Read: plugins/python-development/skills/async-python-patterns/SKILL.md
```

### 1.4 Search marketplace.json

The marketplace.json contains all plugin metadata:

```
# Find plugins with specific keywords
Grep: pattern="kubernetes" path=".claude-plugin/marketplace.json" output_mode="content" -C=5

# List all agent files in a plugin
Grep: pattern="agents.*\.md" path=".claude-plugin/marketplace.json"
```

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

### Method D: Install Skills

Skills provide domain knowledge and patterns. There are three ways to install them:

**Option 1: Add Key Sections to CLAUDE.md (Recommended)**

Extract the most relevant sections from the skill and add to CLAUDE.md:

```markdown
# In CLAUDE.md

## Async Python Patterns

When writing async Python code, follow these patterns:

### Core Patterns
- Use `async def` for I/O-bound operations
- Prefer `asyncio.gather()` for concurrent tasks
- Always use `async with` for context managers

### Best Practices
- Never mix sync and async code without proper bridges
- Use `asyncio.run()` only at the entry point
- Prefer `anyio` for library code that needs to be framework-agnostic

[Include relevant code examples from the skill]
```

**Option 2: Copy Full Skill to .claude/skills/**

For comprehensive skills you reference frequently:

```bash
# Create skills directory
mkdir -p .claude/skills

# Copy entire skill directory
cp -r plugins/python-development/skills/async-python-patterns .claude/skills/

# Reference in CLAUDE.md
echo "## Skills Reference
See .claude/skills/ for detailed patterns:
- async-python-patterns: Async/await patterns and best practices
" >> CLAUDE.md
```

**Option 3: Reference Skills Inline**

For quick reference, add skill pointers to CLAUDE.md:

```markdown
# In CLAUDE.md

## Coding Patterns

When working on this project, follow these skill guides:

### Python
Follow patterns from: plugins/python-development/skills/
- async-python-patterns: For all async code
- python-testing-patterns: For test structure

### Infrastructure
Follow patterns from: plugins/kubernetes-operations/skills/
- k8s-manifest-generator: For Kubernetes resources
- helm-chart-scaffolding: For Helm charts
```

### Method E: Configure MCP Servers

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

### Method F: Configure Hooks

Add hooks to `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "npm run format 2>/dev/null || true"
          }
        ]
      }
    ]
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

### 3.3 Install Skills

Skills can be installed in several ways depending on how often you need them:

**Full Skill Copy (for frequent use):**
```bash
# Copy skill directory
mkdir -p .claude/skills
cp -r $SOURCE/skills/async-python-patterns .claude/skills/
```

**Key Sections to CLAUDE.md (recommended):**
```bash
# Extract and append core sections
echo "" >> CLAUDE.md
echo "## Async Python Patterns" >> CLAUDE.md
echo "" >> CLAUDE.md
# Read the skill and extract "When to Use", "Core Concepts", and "Quick Start" sections
head -100 $SOURCE/skills/async-python-patterns/SKILL.md | tail -80 >> CLAUDE.md
```

**Reference Only:**
```markdown
# In CLAUDE.md
## Skills Reference
For async Python patterns, see: plugins/python-development/skills/async-python-patterns/SKILL.md
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

### Install Single Skill

```bash
#!/bin/bash
# install-skill.sh <plugin> <skill> [--full|--summary]
PLUGIN=$1
SKILL=$2
MODE=${3:---summary}
SOURCE="path/to/claude-code-agents/plugins/$PLUGIN/skills/$SKILL"

if [ "$MODE" == "--full" ]; then
    # Copy entire skill directory
    mkdir -p .claude/skills
    cp -r "$SOURCE" ".claude/skills/"
    echo "Skill $SKILL installed to .claude/skills/"
else
    # Add summary to CLAUDE.md
    echo "" >> CLAUDE.md
    echo "## $SKILL" >> CLAUDE.md
    echo "" >> CLAUDE.md
    # Extract key sections (skip YAML frontmatter, get first 100 lines of content)
    tail -n +5 "$SOURCE/SKILL.md" | head -100 >> CLAUDE.md
    echo "Skill $SKILL summary added to CLAUDE.md"
fi
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
