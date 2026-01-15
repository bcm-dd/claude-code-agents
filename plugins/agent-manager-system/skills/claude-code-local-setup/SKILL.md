---
name: claude-code-local-setup
description: Master Claude Code local configuration including CLAUDE.md project instructions, .claude/ directory setup, settings.json for hooks and MCP servers, and custom commands. Use when setting up Claude Code for a project or configuring local automation.
---

# Claude Code Local Setup

Complete guide to configuring Claude Code for your local projects with custom instructions, hooks, MCP servers, and commands.

## When to Use This Skill

- Setting up Claude Code for a new project
- Adding custom project instructions to CLAUDE.md
- Configuring hooks for automation (linting, testing, formatting)
- Setting up MCP servers for external integrations
- Installing custom slash commands
- Configuring permissions and security settings

## Core Concepts

### Configuration Hierarchy

Claude Code uses a layered configuration system:

```
Priority (highest to lowest):
1. Command-line flags
2. Project settings (.claude/settings.json)
3. Project instructions (CLAUDE.md)
4. User settings (~/.claude/settings.json)
5. Default behavior
```

### Directory Structure

```
your-project/
├── .claude/
│   ├── settings.json      # Hooks, MCP, permissions
│   ├── commands/          # Custom slash commands
│   │   ├── deploy.md
│   │   └── test-all.md
│   └── context/           # Additional context files
├── CLAUDE.md              # Project instructions
└── ... (your project files)
```

### Key Files

| File | Purpose | Scope |
|------|---------|-------|
| `CLAUDE.md` | Project instructions, coding standards, agent behaviors | Project |
| `.claude/settings.json` | Hooks, MCP servers, permissions | Project |
| `.claude/commands/*.md` | Custom slash commands | Project |
| `~/.claude/settings.json` | Global user preferences | User |

## Quick Start

### 1. Initialize Claude Code for Your Project

```bash
# Create configuration directory
mkdir -p .claude/commands

# Create project instructions
cat > CLAUDE.md << 'EOF'
# Project Instructions

## Overview
This is a [describe your project].

## Tech Stack
- Language: [e.g., TypeScript, Python]
- Framework: [e.g., Next.js, FastAPI]
- Database: [e.g., PostgreSQL, MongoDB]

## Coding Standards
- Use [your style guide]
- Follow [your conventions]

## Important Files
- `src/` - Source code
- `tests/` - Test files
- `.env.example` - Environment template
EOF

# Create settings
cat > .claude/settings.json << 'EOF'
{
  "hooks": {},
  "mcpServers": {},
  "permissions": {}
}
EOF
```

### 2. Add Your First Hook

```bash
# Add auto-formatting hook
cat > .claude/settings.json << 'EOF'
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
EOF
```

### 3. Add Your First Custom Command

```bash
cat > .claude/commands/run-tests.md << 'EOF'
# Run Tests

Execute the project test suite and report results.

## Instructions
1. Run the test command: `npm test` or `pytest`
2. Analyze any failures
3. Suggest fixes for failing tests
EOF
```

Now `/run-tests` is available in Claude Code.

## CLAUDE.md Deep Dive

### Structure

```markdown
# Project Name

## Overview
Brief description of the project.

## Tech Stack
- List technologies
- Include versions if important

## Architecture
Describe the project structure.

## Coding Standards
- Style guidelines
- Naming conventions
- Best practices to follow

## Important Patterns
Document project-specific patterns.

## Do's and Don'ts
### Do
- Follow X pattern
- Use Y approach

### Don't
- Avoid Z anti-pattern
- Never do W

## Key Files
- `src/index.ts` - Entry point
- `src/config/` - Configuration

## Testing
How to run and write tests.

## Deployment
Deployment procedures.
```

### Including Agent Behaviors

Add specialized behaviors to CLAUDE.md:

```markdown
## Agent Behaviors

### When Writing Python Code
- Use type hints for all function parameters and returns
- Follow PEP 8 style guidelines
- Prefer f-strings over .format()
- Use pathlib for file operations

### When Writing Tests
- Use pytest with fixtures
- Aim for 80%+ coverage
- Mock external services
- Test edge cases

### When Reviewing Code
- Check for security vulnerabilities
- Verify error handling
- Ensure proper logging
- Validate input sanitization
```

### Dynamic Context

Reference other files for context:

```markdown
## Additional Context

See also:
- [API Documentation](./docs/api.md)
- [Architecture Decision Records](./docs/adr/)
- [Contributing Guidelines](./CONTRIBUTING.md)
```

## Settings.json Deep Dive

### Complete Settings Structure

```json
{
  "hooks": {
    "PreToolUse": [],
    "PostToolUse": [],
    "UserPromptSubmit": [],
    "Stop": []
  },
  "mcpServers": {},
  "permissions": {
    "allow": [],
    "deny": []
  },
  "env": {}
}
```

### Hook Configuration

#### PreToolUse Hooks

Run before a tool executes. Can block execution.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'About to run: $TOOL_INPUT'"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "test ! -f \"$FILE_PATH\" || echo 'Warning: overwriting existing file'"
          }
        ]
      }
    ]
  }
}
```

#### PostToolUse Hooks

Run after a tool completes.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$FILE_PATH\" 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "npm test 2>/dev/null || echo 'Tests need attention'"
          }
        ]
      }
    ]
  }
}
```

#### UserPromptSubmit Hooks

Run when user submits a prompt. Great for context injection.

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Current branch: '$(git branch --show-current)"
          },
          {
            "type": "command",
            "command": "cat .claude/context/project-status.md 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

### MCP Server Configuration

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
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/dir"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@localhost/db"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_TEAM_ID": "${SLACK_TEAM_ID}"
      }
    }
  }
}
```

### Permission Configuration

```json
{
  "permissions": {
    "allow": [
      "Read(**)",
      "Write(src/**)",
      "Bash(npm test)",
      "Bash(npm run lint)"
    ],
    "deny": [
      "Write(.env)",
      "Write(**/*.key)",
      "Bash(rm -rf *)",
      "Bash(*sudo*)"
    ]
  }
}
```

## Custom Commands

### Command File Format

```markdown
# Command Title

Description of what this command does.

## Arguments
$ARGUMENTS - Description of expected arguments

## Instructions

### Step 1: First Step
What to do first.

### Step 2: Second Step
What to do next.

## Output
What output to provide.
```

### Example Commands

#### /deploy

```markdown
# Deploy Application

Deploy the application to the specified environment.

## Arguments
$ARGUMENTS - Environment (staging|production)

## Instructions

1. Run pre-deployment checks:
   - Verify all tests pass
   - Check for uncommitted changes
   - Validate environment configuration

2. Build the application:
   - Run `npm run build`
   - Verify build artifacts

3. Deploy:
   - For staging: `npm run deploy:staging`
   - For production: `npm run deploy:production`

4. Verify deployment:
   - Check health endpoints
   - Run smoke tests

## Output
- Deployment status
- Environment URL
- Any warnings or issues
```

#### /review-pr

```markdown
# Review Pull Request

Perform a comprehensive code review on the current PR.

## Instructions

1. Get PR information:
   - Fetch changed files
   - Read PR description

2. Review each changed file for:
   - Code quality and best practices
   - Security vulnerabilities
   - Performance implications
   - Test coverage

3. Provide structured feedback:
   - Critical issues (must fix)
   - Suggestions (should consider)
   - Nitpicks (optional improvements)

## Output
Structured review with actionable feedback.
```

## Real-World Configurations

### Python FastAPI Project

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "ruff check --fix \"$FILE_PATH\" 2>/dev/null; ruff format \"$FILE_PATH\" 2>/dev/null || true"
          }
        ]
      }
    ]
  },
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

### TypeScript Next.js Project

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx eslint --fix \"$FILE_PATH\" 2>/dev/null; npx prettier --write \"$FILE_PATH\" 2>/dev/null || true"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$TOOL_INPUT\" | grep -q 'rm -rf'; then echo 'BLOCKED: Dangerous command' >&2; exit 1; fi"
          }
        ]
      }
    ]
  }
}
```

### Full DevOps Setup

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo '=== Current Context ===' && git branch --show-current && kubectl config current-context 2>/dev/null || true"
          }
        ]
      }
    ]
  },
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

## Common Pitfalls

### Pitfall 1: Hook Command Failures Breaking Flow
**Problem**: Hook command fails and blocks Claude Code
**Solution**: Always add `|| true` or `2>/dev/null` for non-critical hooks

### Pitfall 2: Missing Environment Variables
**Problem**: MCP server fails because env var not set
**Solution**: Use `${VAR}` syntax and ensure vars are exported

### Pitfall 3: Overly Broad Permissions
**Problem**: Permissions allow dangerous operations
**Solution**: Use specific patterns, deny dangerous commands explicitly

### Pitfall 4: CLAUDE.md Too Long
**Problem**: Very long CLAUDE.md uses too many tokens
**Solution**: Keep it focused, reference external files for details

### Pitfall 5: Conflicting Hooks
**Problem**: Multiple hooks interfere with each other
**Solution**: Order hooks carefully, use specific matchers

## Testing Your Configuration

### Test Hooks

```bash
# Trigger a Write hook
echo "test" > test-file.txt
rm test-file.txt

# Check hook output in Claude Code logs
```

### Test MCP Servers

```bash
# In Claude Code, MCP tools appear as available tools
# Try: "List my GitHub repositories" (with GitHub MCP)
```

### Test Commands

```bash
# In Claude Code
/your-command argument
```

### Validate Settings JSON

```bash
# Check JSON syntax
cat .claude/settings.json | jq .

# Validate structure
cat .claude/settings.json | jq 'keys'
```

## Resources

- **assets/settings-templates/**: Ready-to-use settings.json templates
- **assets/claude-md-templates/**: CLAUDE.md templates by project type
- **assets/command-templates/**: Common command templates
- **references/mcp-servers.md**: Available MCP servers and configuration
- **references/hook-patterns.md**: Advanced hook patterns
