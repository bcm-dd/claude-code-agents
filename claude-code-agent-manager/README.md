# Claude Code Agent Manager

Install and manage Claude Code agents, skills, and commands. Extract knowledge from debugging sessions into reusable skills.

## Installation

```bash
git clone https://github.com/YOUR_ORG/claude-code-agent-manager.git ~/.claude/skills/agent-manager
```

### Enable Continuous Learning (Recommended)

```bash
# Install the activation hook
mkdir -p ~/.claude/hooks
cp ~/.claude/skills/agent-manager/scripts/continuous-learning-activator.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/continuous-learning-activator.sh

# Add to settings
cat >> ~/.claude/settings.json << 'EOF'
{
  "hooks": {
    "UserPromptSubmit": [{
      "hooks": [{
        "type": "command",
        "command": "~/.claude/hooks/continuous-learning-activator.sh"
      }]
    }]
  }
}
EOF
```

### With Marketplace (Optional)

```bash
cd ~/.claude/skills/agent-manager
git submodule add https://github.com/YOUR_ORG/claude-code-agents.git marketplace
```

## Usage

Once installed, Claude Code can:

**Search for skills:**
```
Search for Kubernetes skills in the marketplace
```

**Install components:**
```
Install the python-pro agent for my project
```

**Configure automation:**
```
Set up auto-formatting hooks for TypeScript
```

**Extract knowledge:**
```
Save what we learned about connection pooling as a skill
```

**Review session:**
```
/retrospective
```

## Architecture

```
~/.claude/skills/agent-manager/
├── SKILL.md                    # Main skill (loaded by Claude)
├── commands/
│   └── retrospective.md        # /retrospective command
├── scripts/
│   ├── continuous-learning-activator.sh  # Prompt hook
│   ├── stop-hook.sh            # Session end hook
│   └── generate-skill-index.sh # Index generator
├── templates/
│   └── skill-template.md       # Template for new skills
├── patterns/
│   ├── hooks.md                # Hook patterns
│   ├── mcp.md                  # MCP server patterns
│   ├── skills.md               # Skill development patterns
│   └── agents.md               # Agent design patterns
├── examples/                   # Example extracted skills
└── marketplace/                # Plugin marketplace (optional)
```

## Efficient Skill Discovery

The traditional approach loads all skills into context. This is expensive.

**Our approach:**

1. **Skill Index** - Single file listing all skills with descriptions
2. **On-demand loading** - Read full skill only when needed
3. **Active search** - Use Grep/Glob to find relevant skills

```bash
# Generate index after adding skills
~/.claude/skills/agent-manager/scripts/generate-skill-index.sh

# Claude reads index first
Read: ~/.claude/skills/INDEX.md

# Then loads specific skill if needed
Read: ~/.claude/skills/prisma-connection-pool/SKILL.md
```

## Continuous Learning

The activation hook reminds Claude to evaluate each session:

1. Did this require non-obvious investigation?
2. Is the solution reusable?
3. Did I discover something beyond docs?

If yes → Create a skill using the template.

**Quality gates:**
- Reusable across contexts
- Non-trivial (required discovery)
- Specific with trigger conditions
- Actually verified to work

## Configuration Locations

| Scope | Path | Purpose |
|-------|------|---------|
| User | `~/.claude/skills/` | Skills for all projects |
| User | `~/.claude/settings.json` | Global hooks, MCP |
| User | `~/.claude/CLAUDE.md` | Global instructions |
| Project | `.claude/skills/` | Project-specific skills |
| Project | `.claude/settings.json` | Project hooks, MCP |
| Project | `CLAUDE.md` | Project instructions |

## Credits

Continuous learning patterns adapted from [blader/claude-code-continuous-learning-skill](https://github.com/blader/claude-code-continuous-learning-skill).

## License

MIT
