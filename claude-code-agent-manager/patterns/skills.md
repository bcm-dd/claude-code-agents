# Skill Development Patterns

Quick reference for creating Claude Code skills.

## Skill File Format

```markdown
---
name: kebab-case-skill-name
description: Brief description with activation triggers. Use when...
---

# Skill Title

Brief introduction.

## When to Use This Skill
- Scenario 1
- Scenario 2

## Core Concepts
Fundamental knowledge.

## Quick Start
```code
Minimal working example
```

## Fundamental Patterns
### Pattern 1
Description and example.

## Common Pitfalls
### Pitfall Name
**Problem**: What goes wrong
**Solution**: How to fix

## Resources
- **assets/template.md**: Description
```

## Save Locations

- `~/.claude/skills/` - User-level (all projects)
- `.claude/skills/` - Project-level (this project only)

## Proactive Skill Creation

After debugging, evaluate:

1. Did this require non-obvious investigation?
2. Is the solution reusable for future problems?
3. Did I discover something beyond documentation?

**If YES** → Create a skill file.

### Quality Gates

Only save if:
- Reusable across contexts
- Non-trivial (required discovery)
- Specific with trigger conditions
- Actually verified to work

### Anti-Patterns

- **Over-extraction**: Not every solution is skill-worthy
- **Vague descriptions**: "Python tips" vs "Fixing asyncio nested event loop in Jupyter"
- **Unverified solutions**: Don't save guesses
- **Documentation duplication**: Add value beyond docs

## Example: Debugging Skill

```markdown
---
name: prisma-serverless-connection-pool
description: Fix Prisma connection pool exhaustion in serverless (Vercel, Lambda). Triggers on "Too many connections" or "Connection pool timeout" errors.
version: 1.0.0
date: 2024-01-15
---

# Prisma Serverless Connection Pool Fix

## Problem

Prisma exhausts database connections in serverless environments.

## Trigger Conditions

- Using Prisma with Vercel, AWS Lambda, or serverless
- Errors: "Too many connections", "Connection pool timeout"
- Database connection limits being hit

## Solution

1. Configure connection limits in schema.prisma:

```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
  directUrl = env("DIRECT_URL")
}
```

2. Set pool size:

```
DATABASE_URL="postgresql://...?connection_limit=1"
```

3. Consider Prisma Accelerate for high traffic.

## Verification

- Monitor connection count in database dashboard
- Load test with concurrent requests
- Check for timeout errors

## Caveats

- connection_limit=1 trades throughput for reliability
- Consider Prisma Accelerate for high-traffic serverless
```

## Skill Organization

```
~/.claude/skills/
├── agent-manager/           # This skill
├── prisma-connection-pool/  # Learned skill
├── nextjs-hydration/        # Learned skill
└── typescript-circular/     # Learned skill

project/.claude/skills/
├── our-api-patterns/        # Project-specific
└── deployment-gotchas/      # Project-specific
```

## Progressive Disclosure

Structure skills in tiers:

**Tier 1: Metadata (Always Loaded)**
- YAML frontmatter
- Name and description
- Activation triggers

**Tier 2: Core Content (On Activation)**
- When to Use
- Core Concepts
- Quick Start
- Fundamental Patterns

**Tier 3: Resources (On Demand)**
- Advanced Patterns
- Reference Documentation
- Templates and Checklists

## Best Practices

1. **Specific descriptions** - Include exact error messages
2. **Clear triggers** - When should this activate?
3. **Runnable examples** - Code that works
4. **Verification steps** - How to confirm success
5. **Caveats section** - Edge cases and limitations
