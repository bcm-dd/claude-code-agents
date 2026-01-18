---
name: continuous-learning-patterns
description: Patterns for Claude Code to learn from sessions and generate new skills autonomously. Implement feedback loops where Claude extracts reusable knowledge from debugging, problem-solving, and discovery. Use when setting up continuous learning, creating retrospectives, or building a personal skill library.
---

# Continuous Learning Patterns

Enable Claude Code to learn from your work sessions and build a persistent library of reusable skills over time.

## When to Use This Skill

- Setting up continuous learning for Claude Code
- Running retrospectives after debugging sessions
- Extracting reusable knowledge from problem-solving
- Building a personal skill library from discoveries
- Integrating the continuous-learning-skill from external sources

## Core Concept

Traditional Claude Code sessions are stateless - knowledge is lost when the session ends. Continuous learning creates a **feedback loop**:

```
Work Session → Discovery → Extract Skill → Save to ~/.claude/skills/ → Future Sessions Load It
```

This transforms Claude Code from a tool that forgets into one that accumulates expertise.

## The Learning Cycle

### 1. Detection

After completing work, evaluate:
- Did this require non-obvious investigation?
- Was the solution something documentation didn't cover?
- Would this help in future similar situations?
- Did I discover project-specific patterns?

### 2. Extraction

If yes to any above, extract the knowledge:
- What was the problem?
- What were the trigger conditions?
- What was the solution?
- How do you verify it worked?

### 3. Codification

Write it as a skill file with semantic description for future matching.

### 4. Persistence

Save to `~/.claude/skills/` (user-level) or `.claude/skills/` (project-level).

## Skill File Format

```markdown
---
name: descriptive-kebab-case-name
description: Specific description optimized for semantic matching. Include exact error messages, tool names, and trigger conditions so Claude can find this skill when facing similar problems.
author: Your Name
version: 1.0.0
date: 2024-01-15
---

# Skill Title

## Problem

Describe the specific problem this skill solves. Include exact error messages if applicable.

## Trigger Conditions

When should Claude activate this skill?
- Specific error patterns
- Tool/framework combinations
- Project configurations

## Solution

Step-by-step solution:

1. First step with explanation
2. Second step with code example
3. Verification step

## Example

\`\`\`bash
# Concrete example of the solution
\`\`\`

## Caveats

- Edge cases to watch for
- When this solution doesn't apply
- Version-specific considerations

## References

- Links to relevant documentation
- Related issues or discussions
```

## Quality Gates

Only extract knowledge that is:

| Criteria | Description |
|----------|-------------|
| **Reusable** | Applies across multiple contexts |
| **Non-trivial** | Required discovery, not just lookup |
| **Specific** | Has exact trigger conditions |
| **Verified** | Actually confirmed to work |

### Anti-Patterns to Avoid

- **Over-extraction**: Not every solution is skill-worthy
- **Vague descriptions**: "Python debugging tips" vs "Fixing asyncio.run() nested event loop error in Jupyter"
- **Unverified solutions**: Don't save guesses
- **Documentation duplication**: Add value beyond official docs

## Installation Methods

### Method 1: Install External Continuous Learning Skill

```bash
# Clone the continuous-learning-skill
git clone https://github.com/blader/claude-code-continuous-learning-skill.git \
  ~/.claude/skills/continuous-learning

# Copy activation hook
cp ~/.claude/skills/continuous-learning/scripts/continuous-learning-activator.sh \
  ~/.claude/hooks/

# Make executable
chmod +x ~/.claude/hooks/continuous-learning-activator.sh
```

Configure the hook in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/continuous-learning-activator.sh"
          }
        ]
      }
    ]
  }
}
```

### Method 2: Manual Retrospectives

After significant work, run a retrospective:

```
Run a learning retrospective on this debugging session.
Extract any non-obvious solutions as skills.
```

### Method 3: Inline Learning Prompts

Add to your CLAUDE.md:

```markdown
## Continuous Learning

After completing debugging or problem-solving work:
1. Evaluate if the solution was non-obvious
2. If reusable, create a skill file in .claude/skills/
3. Use semantic descriptions for future matching
```

## Hook Implementation

### UserPromptSubmit Hook for Learning Evaluation

```bash
#!/bin/bash
# continuous-learning-evaluator.sh

cat << 'EOF'
[LEARNING EVALUATION PROTOCOL]
After completing the user's request, briefly evaluate:
1. Did this require non-obvious investigation?
2. Is the solution reusable for future similar problems?
3. Did I discover something beyond standard documentation?

If YES to any: Consider extracting as a skill to ~/.claude/skills/
If NO to all: Continue normally without extraction.
EOF
```

### PostToolUse Hook for Debugging Sessions

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if [ $? -ne 0 ]; then echo '[Debug session - evaluate for learning]'; fi"
          }
        ]
      }
    ]
  }
}
```

## Skill Organization

```
~/.claude/skills/                    # User-level skills (all projects)
├── continuous-learning/             # The meta-skill
├── prisma-connection-pooling/       # Learned skill
├── nextjs-hydration-mismatch/       # Learned skill
└── typescript-circular-deps/        # Learned skill

your-project/.claude/skills/         # Project-level skills
├── our-api-error-patterns/          # Project-specific
└── deployment-gotchas/              # Project-specific
```

## Integration with Agent Manager

The agent-manager can:

1. **Install continuous-learning from external sources**
   ```
   Install the continuous-learning-skill from github.com/blader/claude-code-continuous-learning-skill
   ```

2. **List user-generated skills**
   ```
   What skills have I generated through continuous learning?
   ```

3. **Promote project skills to user-level**
   ```
   Move the prisma-connection-pooling skill to my global skills
   ```

4. **Share skills to marketplace**
   ```
   Package my learned skills for contribution to the marketplace
   ```

## Example: Learning from a Debugging Session

### The Problem

You spent 2 hours debugging why Prisma connections were exhausting in production.

### The Discovery

The issue was missing connection pool configuration for serverless environments.

### The Extracted Skill

```markdown
---
name: prisma-serverless-connection-pool
description: Fix Prisma connection pool exhaustion in serverless environments (Vercel, AWS Lambda). Triggers on "Too many connections" or "Connection pool timeout" errors with Prisma + serverless.
author: Your Name
version: 1.0.0
date: 2024-01-15
---

# Prisma Serverless Connection Pool Fix

## Problem

Prisma exhausts database connections in serverless environments because each function invocation creates new connections without proper pooling.

## Trigger Conditions

- Using Prisma with Vercel, AWS Lambda, or other serverless
- Errors: "Too many connections", "Connection pool timeout"
- Database connection limits being hit

## Solution

1. Use Prisma Accelerate or PgBouncer for connection pooling
2. Configure connection limits in schema.prisma:

\`\`\`prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
  directUrl = env("DIRECT_URL")
}
\`\`\`

3. Set pool size for serverless:

\`\`\`
DATABASE_URL="postgresql://...?connection_limit=1"
\`\`\`

## Verification

- Monitor connection count in database dashboard
- Load test with concurrent requests
- Check for connection timeout errors

## Caveats

- connection_limit=1 trades throughput for reliability
- Consider Prisma Accelerate for high-traffic serverless

## References

- https://www.prisma.io/docs/guides/performance-and-optimization/connection-management
```

## Research Foundation

This approach draws from:

- **Voyager** (MineDojo): Agents building skill libraries through exploration
- **CASCADE**: Meta-skills that improve agent capabilities over time
- **SEAgent**: Environment learning for development tasks

The key insight: **Persistent knowledge dramatically improves agent performance** compared to stateless sessions.

## Best Practices

1. **Be specific in descriptions** - Semantic matching depends on it
2. **Include exact error messages** - Makes future matching precise
3. **Verify before saving** - Don't persist guesses
4. **Review periodically** - Prune outdated skills
5. **Share valuable discoveries** - Contribute to community marketplaces

## Resources

- [continuous-learning-skill repo](https://github.com/blader/claude-code-continuous-learning-skill)
- [Claude Code Skills Documentation](https://docs.anthropic.com/claude-code/skills)
- [Voyager Paper](https://voyager.minedojo.org/) - Agent skill library research
