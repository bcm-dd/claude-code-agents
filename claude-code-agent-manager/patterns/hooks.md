# Hook Development Patterns

Quick reference for Claude Code hooks.

## Hook Types

### PreToolUse
Runs before a tool executes. Can block the operation.

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "validate-command.sh \"$TOOL_INPUT\""
      }]
    }]
  }
}
```

**Use cases:**
- Validate file paths before write
- Check branch names before git operations
- Prevent dangerous commands
- Require confirmation for destructive actions

### PostToolUse
Runs after a tool completes successfully.

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "npm run format \"$FILE_PATH\" 2>/dev/null || true"
      }]
    }]
  }
}
```

**Use cases:**
- Auto-format on file save
- Run linters after code changes
- Execute tests after modifications
- Update documentation
- Send notifications

### UserPromptSubmit
Runs when user submits a prompt. Output is injected as context.

```json
{
  "hooks": {
    "UserPromptSubmit": [{
      "hooks": [{
        "type": "command",
        "command": "cat .claude/context.md"
      }]
    }]
  }
}
```

**Use cases:**
- Inject project context
- Add skill suggestions
- Include recent changes
- Provide environment info

### Stop
Runs when Claude stops. Output can request continuation.

```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "check-completion.sh"
      }]
    }]
  }
}
```

**Use cases:**
- Check for uncommitted changes
- Verify all tests pass
- Ensure documentation updated
- Request continuation if incomplete

## Common Patterns

### Auto-Format Python
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "if [[ \"$FILE_PATH\" == *.py ]]; then ruff format \"$FILE_PATH\" && ruff check --fix \"$FILE_PATH\"; fi"
      }]
    }]
  }
}
```

### Auto-Format TypeScript
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "if [[ \"$FILE_PATH\" =~ \\.(ts|tsx|js|jsx)$ ]]; then npx prettier --write \"$FILE_PATH\" && npx eslint --fix \"$FILE_PATH\"; fi"
      }]
    }]
  }
}
```

### Run Tests on Change
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "npm test 2>/dev/null || pytest 2>/dev/null || true"
      }]
    }]
  }
}
```

### Commit Reminder
```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "if [ -n \"$(git status --porcelain)\" ]; then echo 'Uncommitted changes detected. Consider committing.'; fi"
      }]
    }]
  }
}
```

### Learning Evaluation
```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "echo '[LEARNING] Evaluate: Was this solution non-obvious and reusable? If yes, consider creating a skill.'"
      }]
    }]
  }
}
```

## Environment Variables

Available in hook commands:
- `$TOOL_INPUT` - The tool's input parameters
- `$FILE_PATH` - Path of file being operated on (for Write/Edit)
- Standard shell environment variables

## Best Practices

1. Always use `2>/dev/null || true` for optional commands
2. Use file extension checks to target specific file types
3. Keep hooks fast - they run synchronously
4. Test hooks in isolation before adding to settings
5. Use absolute paths when possible
