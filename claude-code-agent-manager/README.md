# Claude Code Agent Manager

Install and manage Claude Code agents, skills, commands, hooks, and MCP servers from a marketplace. Proactively create new skills from your debugging discoveries.

## Installation

### One-liner Install

```bash
git clone https://github.com/YOUR_ORG/claude-code-agent-manager.git ~/.claude/skills/agent-manager
```

### With Marketplace (Full)

```bash
# Clone with marketplace submodule
git clone --recurse-submodules https://github.com/YOUR_ORG/claude-code-agent-manager.git ~/.claude/skills/agent-manager

# Or add marketplace after cloning
cd ~/.claude/skills/agent-manager
git submodule add https://github.com/YOUR_ORG/claude-code-agents.git marketplace
```

### Install Script

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-code-agent-manager/main/install.sh | bash
```

## What It Does

Once installed, Claude Code automatically loads this skill and can:

1. **Search the marketplace** for agents and skills by keyword
2. **Install agents** to your project's CLAUDE.md
3. **Install skills** to CLAUDE.md or .claude/skills/
4. **Install commands** to .claude/commands/
5. **Configure hooks** for automation
6. **Set up MCP servers** for external integrations
7. **Create new skills** from debugging discoveries

## Usage

Just ask Claude Code naturally:

```
Install the python-pro agent for my project
```

```
Search for Kubernetes skills in the marketplace
```

```
Set up auto-formatting hooks for my TypeScript project
```

```
Save what we learned about Prisma connection pooling as a skill
```

## File Structure

```
~/.claude/skills/agent-manager/
├── SKILL.md              # Main skill file (loaded by Claude)
├── README.md             # This file
├── install.sh            # Installation script
├── patterns/             # Reference patterns
│   ├── hooks.md          # Hook development patterns
│   ├── mcp.md            # MCP server patterns
│   ├── skills.md         # Skill development patterns
│   └── agents.md         # Agent design patterns
└── marketplace/          # Plugin marketplace (optional submodule)
    └── plugins/          # 66+ plugins with agents, skills, commands
```

## Configuration Locations

| Scope | Location | Purpose |
|-------|----------|---------|
| User-level | `~/.claude/skills/` | Skills for all projects |
| User-level | `~/.claude/settings.json` | Global hooks, MCP |
| Project-level | `.claude/skills/` | Project-specific skills |
| Project-level | `.claude/settings.json` | Project hooks, MCP |
| Project-level | `.claude/commands/` | Custom slash commands |
| Project-level | `CLAUDE.md` | Project instructions |

## Proactive Learning

The agent-manager enables continuous learning by:

1. Evaluating sessions for extractable knowledge
2. Creating skill files from non-obvious discoveries
3. Saving to ~/.claude/skills/ (global) or .claude/skills/ (project)

### Enable Continuous Learning

Add to your `~/.claude/CLAUDE.md` or project `CLAUDE.md`:

```markdown
## Continuous Learning Protocol

After completing debugging or problem-solving work, evaluate:
1. Did this require non-obvious investigation?
2. Is the solution reusable for future similar problems?

If YES: Create a skill file in .claude/skills/ with problem,
trigger conditions, solution, and verification steps.
```

## Updating

```bash
cd ~/.claude/skills/agent-manager
git pull

# If using marketplace submodule
git submodule update --remote marketplace
```

## Uninstall

```bash
rm -rf ~/.claude/skills/agent-manager
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your patterns or improvements
4. Submit a pull request

## License

MIT
