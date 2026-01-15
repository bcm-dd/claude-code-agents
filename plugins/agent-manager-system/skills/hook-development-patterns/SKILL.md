---
name: hook-development-patterns
description: Master Claude Code hooks for automation, validation, and workflow enhancement. Covers PreToolUse, PostToolUse, UserPromptSubmit, and Stop hooks. Use when automating Claude Code workflows, adding validations, or integrating external tools.
---

# Hook Development Patterns

Master Claude Code hooks to automate workflows, validate operations, and enhance the development experience.

## When to Use This Skill

- Automating code formatting after file writes
- Validating operations before they execute
- Adding context to user prompts automatically
- Integrating linting and testing into workflows
- Blocking dangerous operations on protected branches
- Creating custom notification systems
- Building skill suggestion systems

## Core Concepts

### Hook Types

Claude Code supports four hook types:

| Hook | Trigger | Use Case |
|------|---------|----------|
| **PreToolUse** | Before tool execution | Validation, blocking, modification |
| **PostToolUse** | After tool execution | Formatting, testing, notification |
| **UserPromptSubmit** | When user sends prompt | Context injection, skill suggestion |
| **Stop** | After response completion | Continuation logic, cleanup |

### Hook Configuration Location

Hooks are configured in `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "UserPromptSubmit": [...],
    "Stop": [...]
  }
}
```

### Hook Structure

Each hook entry contains:

```json
{
  "matcher": "ToolName|AnotherTool",  // Optional: regex pattern for tools
  "hooks": [
    {
      "type": "command",
      "command": "script.sh \"$TOOL_INPUT\""
    }
  ]
}
```

### Environment Variables

Hooks receive context via environment variables:

| Variable | Description | Available In |
|----------|-------------|--------------|
| `$TOOL_NAME` | Name of the tool | PreToolUse, PostToolUse |
| `$TOOL_INPUT` | JSON input to tool | PreToolUse, PostToolUse |
| `$TOOL_OUTPUT` | JSON output from tool | PostToolUse |
| `$USER_PROMPT` | User's message | UserPromptSubmit |
| `$STOP_REASON` | Why Claude stopped | Stop |

## Quick Start

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "npm run format"
          }
        ]
      }
    ]
  }
}
```

This runs `npm run format` after every file write operation.

## Fundamental Patterns

### Pattern 1: Auto-Format on Write

Automatically format code after file writes:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write \"$(echo $TOOL_INPUT | jq -r '.file_path')\" 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

**How it works:**
1. Triggers after Write or Edit tool completes
2. Extracts file path from tool input JSON
3. Runs Prettier on the file
4. Silently ignores errors (non-JS files)

### Pattern 2: Branch Protection

Block dangerous operations on protected branches:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$TOOL_INPUT\" | grep -qE 'git (push|commit).*(-f|--force|main|master)'; then echo 'BLOCKED: Force push to protected branch'; exit 1; fi"
          }
        ]
      }
    ]
  }
}
```

**How it works:**
1. Triggers before Bash tool executes
2. Checks if command contains force push to main/master
3. Blocks execution with error message if detected
4. Allows all other commands

### Pattern 3: Auto-Run Tests

Run tests after code changes:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(echo $TOOL_INPUT | jq -r '.file_path'); if [[ $FILE == *.py ]]; then pytest ${FILE%/*}/test_*.py --tb=short 2>/dev/null || true; fi"
          }
        ]
      }
    ]
  }
}
```

**How it works:**
1. Triggers after Python file edits
2. Extracts file path and directory
3. Runs pytest on related test files
4. Continues even if tests fail

### Pattern 4: Context Injection

Add project context to every prompt:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo \"Project context: $(cat .claude/context.md 2>/dev/null || echo 'No context file')\""
          }
        ]
      }
    ]
  }
}
```

**How it works:**
1. Triggers when user submits a prompt
2. Reads project context file
3. Appends context to Claude's input
4. Falls back gracefully if file missing

### Pattern 5: Lint on Save

Run linters after file writes:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(echo $TOOL_INPUT | jq -r '.file_path'); case $FILE in *.py) ruff check --fix $FILE;; *.js|*.ts) eslint --fix $FILE;; esac"
          }
        ]
      }
    ]
  }
}
```

## Advanced Patterns

### Pattern 6: Skill Suggestion System

Analyze prompts and suggest relevant skills:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/suggest-skills.sh \"$USER_PROMPT\""
          }
        ]
      }
    ]
  }
}
```

**suggest-skills.sh:**
```bash
#!/bin/bash
PROMPT="$1"

# Check for testing-related keywords
if echo "$PROMPT" | grep -qiE 'test|coverage|pytest|jest|mock'; then
    echo "Suggested skill: testing-patterns"
fi

# Check for API-related keywords
if echo "$PROMPT" | grep -qiE 'api|endpoint|rest|graphql|openapi'; then
    echo "Suggested skill: api-design-patterns"
fi

# Check for security-related keywords
if echo "$PROMPT" | grep -qiE 'security|vulnerability|injection|xss|auth'; then
    echo "Suggested skill: security-patterns"
fi
```

### Pattern 7: Notification System

Send notifications for important events:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$TOOL_INPUT\" | grep -q 'git push'; then curl -X POST -d '{\"text\":\"Code pushed to repository\"}' $SLACK_WEBHOOK_URL 2>/dev/null; fi"
          }
        ]
      }
    ]
  }
}
```

### Pattern 8: Multi-Step Validation

Chain multiple validations:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/validate-write.sh"
          }
        ]
      }
    ]
  }
}
```

**validate-write.sh:**
```bash
#!/bin/bash
FILE_PATH=$(echo $TOOL_INPUT | jq -r '.file_path')
CONTENT=$(echo $TOOL_INPUT | jq -r '.content')

# Check 1: No secrets in code
if echo "$CONTENT" | grep -qE '(api_key|password|secret).*=.*["\047][^"\047]+["\047]'; then
    echo "BLOCKED: Potential secret detected in code"
    exit 1
fi

# Check 2: No writes to protected directories
if [[ "$FILE_PATH" == /etc/* ]] || [[ "$FILE_PATH" == /usr/* ]]; then
    echo "BLOCKED: Cannot write to system directories"
    exit 1
fi

# Check 3: File size limit
if [ ${#CONTENT} -gt 1000000 ]; then
    echo "BLOCKED: File content exceeds 1MB limit"
    exit 1
fi

# All checks passed
exit 0
```

### Pattern 9: Conditional Continuation

Control when Claude continues after stopping:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "if [ \"$STOP_REASON\" = 'end_turn' ] && [ -f .claude/continue ]; then echo 'continue'; rm .claude/continue; fi"
          }
        ]
      }
    ]
  }
}
```

## Real-World Applications

### Complete Development Workflow

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/validate-commands.sh"
          }
        ]
      },
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/validate-writes.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/post-write.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/enhance-prompt.sh"
          }
        ]
      }
    ]
  }
}
```

**post-write.sh:**
```bash
#!/bin/bash
FILE=$(echo $TOOL_INPUT | jq -r '.file_path')

# Format based on file type
case $FILE in
    *.py)
        ruff format $FILE 2>/dev/null
        ruff check --fix $FILE 2>/dev/null
        ;;
    *.js|*.ts|*.jsx|*.tsx)
        prettier --write $FILE 2>/dev/null
        eslint --fix $FILE 2>/dev/null
        ;;
    *.go)
        gofmt -w $FILE 2>/dev/null
        ;;
esac

# Run related tests if they exist
TEST_FILE="${FILE%.*}_test${FILE##*.}"
if [ -f "$TEST_FILE" ]; then
    echo "Running tests for $FILE..."
fi
```

## Common Pitfalls

### Pitfall 1: Blocking Everything
**Problem**: Hook returns non-zero exit code, blocking all operations
**Solution**: Use `|| true` for non-critical hooks, only exit 1 when blocking is intended

### Pitfall 2: Slow Hooks
**Problem**: Hooks that take too long slow down the workflow
**Solution**: Keep hooks fast, run slow operations in background with `&`

### Pitfall 3: Missing Error Handling
**Problem**: Hook fails when expected file/variable doesn't exist
**Solution**: Add null checks and fallbacks: `2>/dev/null || true`

### Pitfall 4: Incorrect JSON Parsing
**Problem**: jq fails on malformed JSON input
**Solution**: Validate JSON first or use error handling

### Pitfall 5: Environment Variable Issues
**Problem**: Variables not available or not escaped properly
**Solution**: Quote variables and test with echo first

## Testing Your Hooks

1. **Echo Test**: Replace command with `echo "Hook triggered: $TOOL_NAME"` first
2. **Dry Run**: Log what would happen without actually doing it
3. **Error Test**: Verify error handling works correctly
4. **Performance Test**: Ensure hooks don't slow down workflow
5. **Integration Test**: Test hooks with actual Claude Code operations

## Resources

- **assets/hooks-template.json**: Complete hooks configuration template
- **assets/scripts/**: Example validation and formatting scripts
- **references/environment-variables.md**: Complete variable reference
