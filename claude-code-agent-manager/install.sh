#!/bin/bash
# Claude Code Agent Manager Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-code-agent-manager/main/install.sh | bash

set -e

INSTALL_DIR="${HOME}/.claude/skills/agent-manager"
REPO_URL="${AGENT_MANAGER_REPO:-https://github.com/YOUR_ORG/claude-code-agent-manager.git}"
MARKETPLACE_URL="${MARKETPLACE_REPO:-https://github.com/YOUR_ORG/claude-code-agents.git}"

echo "Installing Claude Code Agent Manager..."

# Create skills directory if it doesn't exist
mkdir -p "${HOME}/.claude/skills"

# Check if already installed
if [ -d "$INSTALL_DIR" ]; then
    echo "Agent Manager already installed at $INSTALL_DIR"
    echo "Updating..."
    cd "$INSTALL_DIR"
    git pull
    if [ -d "marketplace" ]; then
        git submodule update --remote marketplace
    fi
    echo "Updated successfully!"
    exit 0
fi

# Clone the repository
echo "Cloning agent-manager..."
git clone "$REPO_URL" "$INSTALL_DIR"

# Ask about marketplace
echo ""
echo "Would you like to include the full marketplace? (66+ plugins, ~50MB)"
echo "This enables offline search and browsing of all agents/skills."
read -p "Include marketplace? [y/N] " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Adding marketplace submodule..."
    cd "$INSTALL_DIR"
    git submodule add "$MARKETPLACE_URL" marketplace 2>/dev/null || true
    git submodule update --init --recursive
    echo "Marketplace installed!"
else
    echo "Skipping marketplace (you can add it later with 'git submodule add')"
fi

# Create global CLAUDE.md if it doesn't exist
if [ ! -f "${HOME}/.claude/CLAUDE.md" ]; then
    echo ""
    echo "Creating ~/.claude/CLAUDE.md with continuous learning protocol..."
    cat > "${HOME}/.claude/CLAUDE.md" << 'EOF'
# Global Claude Code Instructions

## Continuous Learning Protocol

After completing debugging or problem-solving work, evaluate:
1. Did this require non-obvious investigation?
2. Is the solution reusable for future similar problems?
3. Did I discover something beyond standard documentation?

If YES to any:
1. Create a skill file in ~/.claude/skills/ with:
   - Specific name (kebab-case)
   - Description optimized for semantic matching
   - Problem, trigger conditions, solution, verification
2. Inform the user what was saved

Quality gates - only save if:
- Reusable across contexts
- Non-trivial (required discovery)
- Specific with trigger conditions
- Actually verified to work
EOF
    echo "Created ~/.claude/CLAUDE.md"
fi

echo ""
echo "Installation complete!"
echo ""
echo "The agent-manager skill is now available globally."
echo "Try asking Claude Code:"
echo "  - 'Search for Python agents in the marketplace'"
echo "  - 'Install auto-formatting hooks for my project'"
echo "  - 'Save what we learned as a skill'"
echo ""
