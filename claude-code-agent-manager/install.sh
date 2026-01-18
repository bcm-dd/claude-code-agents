#!/bin/bash
# Claude Code Agent Manager Installer
#
# Usage (clone first - more secure):
#   git clone https://github.com/YOUR_ORG/claude-code-agent-manager.git ~/.claude/skills/agent-manager
#   ~/.claude/skills/agent-manager/install.sh --local
#
# Or direct install (review the script first):
#   curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-code-agent-manager/main/install.sh | bash
#
# Security note: Always review scripts before running them with curl | bash

set -euo pipefail

INSTALL_DIR="${HOME}/.claude/skills/agent-manager"
HOOKS_DIR="${HOME}/.claude/hooks"
COMMANDS_DIR="${HOME}/.claude/commands"
SETTINGS_FILE="${HOME}/.claude/settings.json"

# Colors (if terminal supports them)
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
else
    GREEN=''
    YELLOW=''
    NC=''
fi

log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         Claude Code Agent Manager Installer                   ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Create required directories with safe permissions
mkdir -p "${HOME}/.claude/skills"
mkdir -p "${HOOKS_DIR}"
mkdir -p "${COMMANDS_DIR}"
chmod 700 "${HOME}/.claude"

# Handle --local flag (already cloned)
if [ "${1:-}" = "--local" ]; then
    if [ ! -d "$INSTALL_DIR" ]; then
        echo "Error: --local flag used but $INSTALL_DIR does not exist"
        exit 1
    fi
    echo "Using existing installation at $INSTALL_DIR"
else
    # Clone or update
    if [ -d "$INSTALL_DIR" ]; then
        echo "Agent Manager found. Updating..."
        cd "$INSTALL_DIR"
        git pull --ff-only || { echo "Update failed. Please resolve manually."; exit 1; }
        log_success "Updated successfully"
    else
        echo "Cloning agent-manager..."
        REPO_URL="${AGENT_MANAGER_REPO:-https://github.com/YOUR_ORG/claude-code-agent-manager.git}"
        git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
        log_success "Cloned successfully"
    fi
fi

# Install hooks (copy, don't symlink for security)
echo ""
echo "Installing hooks..."
cp "$INSTALL_DIR/scripts/continuous-learning-activator.sh" "$HOOKS_DIR/"
cp "$INSTALL_DIR/scripts/stop-hook.sh" "$HOOKS_DIR/"
chmod 700 "$HOOKS_DIR"/*.sh
log_success "Hooks installed to $HOOKS_DIR"

# Install /retrospective command
cp "$INSTALL_DIR/commands/retrospective.md" "$COMMANDS_DIR/"
log_success "Installed /retrospective command"

# Handle settings.json
if [ ! -f "$SETTINGS_FILE" ]; then
    echo ""
    echo "Creating ~/.claude/settings.json..."
    cat > "$SETTINGS_FILE" << 'SETTINGS_EOF'
{
  "hooks": {
    "UserPromptSubmit": [{
      "hooks": [{
        "type": "command",
        "command": "~/.claude/hooks/continuous-learning-activator.sh"
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "~/.claude/hooks/stop-hook.sh"
      }]
    }]
  }
}
SETTINGS_EOF
    chmod 600 "$SETTINGS_FILE"
    log_success "Created settings.json with hooks"
else
    log_warn "~/.claude/settings.json exists - manual hook setup may be needed"
    echo "    Add to hooks.UserPromptSubmit:"
    echo '    {"hooks": [{"type": "command", "command": "~/.claude/hooks/continuous-learning-activator.sh"}]}'
fi

# Create global CLAUDE.md
if [ ! -f "${HOME}/.claude/CLAUDE.md" ]; then
    echo ""
    cat > "${HOME}/.claude/CLAUDE.md" << 'CLAUDE_EOF'
# Global Claude Code Instructions

## Skill Discovery

Check available skills before complex tasks:
```
Read: ~/.claude/skills/INDEX.md
```

## Continuous Learning

After debugging or problem-solving, evaluate:
1. Did this require non-obvious investigation?
2. Is the solution reusable for future problems?

If YES: Create a skill using ~/.claude/skills/agent-manager/templates/skill-template.md
CLAUDE_EOF
    log_success "Created ~/.claude/CLAUDE.md"
fi

# Generate skill index
echo ""
echo "Generating skill index..."
if [ -x "$INSTALL_DIR/scripts/generate-skill-index.sh" ]; then
    "$INSTALL_DIR/scripts/generate-skill-index.sh"
else
    chmod +x "$INSTALL_DIR/scripts/generate-skill-index.sh"
    "$INSTALL_DIR/scripts/generate-skill-index.sh"
fi

# Summary
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    Installation Complete                      ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Installed:"
echo "  • Skill:   ~/.claude/skills/agent-manager/"
echo "  • Hooks:   ~/.claude/hooks/"
echo "  • Command: /retrospective"
echo "  • Index:   ~/.claude/skills/INDEX.md"
echo ""
echo "Try:"
echo "  • 'Search for Python skills'"
echo "  • 'Save this as a skill'"
echo "  • '/retrospective'"
echo ""
