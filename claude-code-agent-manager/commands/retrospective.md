# /retrospective - Session Knowledge Extraction

Review the current session and extract valuable knowledge into reusable skills.

## Process

### Step 1: Review Session History

Analyze what was accomplished:
- Problems solved
- Errors debugged
- Configurations made
- Patterns discovered

### Step 2: Identify Extraction Candidates

For each significant task, evaluate:

| Criterion | Question |
|-----------|----------|
| Non-obvious | Did this require investigation beyond docs? |
| Reusable | Would this help with future similar problems? |
| Specific | Can we define clear trigger conditions? |
| Verified | Did the solution actually work? |

### Step 3: Prioritize

Rank candidates by value:
1. **High**: Debugging discoveries with specific error messages
2. **Medium**: Configuration patterns for common scenarios
3. **Low**: General best practices (often already documented)

### Step 4: Extract Top Skills

For each high-value candidate:

1. Create skill file using template:
   ```bash
   Read: ~/.claude/skills/agent-manager/templates/skill-template.md
   ```

2. Fill in:
   - **name**: kebab-case, specific
   - **description**: Include error messages, trigger conditions
   - **problem**: What went wrong
   - **trigger conditions**: When this applies
   - **solution**: Step-by-step fix
   - **verification**: How to confirm it works

3. Save to appropriate location:
   - `~/.claude/skills/{name}/SKILL.md` - User-level (all projects)
   - `.claude/skills/{name}/SKILL.md` - Project-level

### Step 5: Update Index

After adding skills:
```bash
~/.claude/skills/agent-manager/scripts/generate-skill-index.sh
```

### Step 6: Report

Summarize what was extracted:
- Number of skills created
- Names and brief descriptions
- Save locations

## Anti-Patterns

Do NOT extract:
- Trivial solutions (easily found in docs)
- Unverified guesses
- One-off configurations specific to this project
- Sensitive information (credentials, internal URLs)

## Output Format

```markdown
## Retrospective Summary

### Session Overview
[Brief description of work done]

### Knowledge Extracted

#### 1. {skill-name}
- **Problem**: [Brief description]
- **Value**: [Why this is worth saving]
- **Location**: ~/.claude/skills/{skill-name}/SKILL.md

#### 2. {skill-name}
...

### Skipped
- [Item]: [Reason not extracted]
```
