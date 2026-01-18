#!/bin/bash
# Verify Agent Manager Installation
#
# Checks that all components are properly installed and working.
# Run after installation to confirm everything is set up correctly.

set -uo pipefail

SKILLS_DIR="${HOME}/.claude/skills"
HOOKS_DIR="${HOME}/.claude/hooks"
COMMANDS_DIR="${HOME}/.claude/commands"
SETTINGS_FILE="${HOME}/.claude/settings.json"

# Colors
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
else
    GREEN=''; RED=''; YELLOW=''; NC=''
fi

pass() { echo -e "${GREEN}✓${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; ERRORS=$((ERRORS + 1)); }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }

ERRORS=0

echo "Verifying Agent Manager Installation"
echo "====================================="
echo ""

# Check skill directory
echo "Checking skill installation..."
if [ -d "${SKILLS_DIR}/agent-manager" ]; then
    pass "agent-manager skill directory exists"
else
    fail "agent-manager skill directory missing"
fi

if [ -f "${SKILLS_DIR}/agent-manager/SKILL.md" ]; then
    pass "SKILL.md exists"
else
    fail "SKILL.md missing"
fi

# Check scripts
echo ""
echo "Checking scripts..."
for script in generate-skill-index.sh continuous-learning-activator.sh stop-hook.sh; do
    if [ -f "${SKILLS_DIR}/agent-manager/scripts/${script}" ]; then
        if [ -x "${SKILLS_DIR}/agent-manager/scripts/${script}" ]; then
            pass "${script} exists and is executable"
        else
            warn "${script} exists but is not executable"
        fi
    else
        fail "${script} missing"
    fi
done

# Check hooks
echo ""
echo "Checking hooks installation..."
if [ -d "${HOOKS_DIR}" ]; then
    pass "hooks directory exists"
else
    fail "hooks directory missing"
fi

for hook in continuous-learning-activator.sh stop-hook.sh; do
    if [ -f "${HOOKS_DIR}/${hook}" ]; then
        if [ -x "${HOOKS_DIR}/${hook}" ]; then
            pass "${hook} installed and executable"
        else
            warn "${hook} installed but not executable"
        fi
    else
        warn "${hook} not installed in hooks directory"
    fi
done

# Check commands
echo ""
echo "Checking commands..."
if [ -f "${COMMANDS_DIR}/retrospective.md" ]; then
    pass "/retrospective command installed"
else
    warn "/retrospective command not installed"
fi

# Check settings.json
echo ""
echo "Checking settings.json..."
if [ -f "${SETTINGS_FILE}" ]; then
    pass "settings.json exists"

    if grep -q "continuous-learning-activator" "${SETTINGS_FILE}" 2>/dev/null; then
        pass "continuous learning hook configured"
    else
        warn "continuous learning hook not in settings.json"
    fi

    if grep -q "stop-hook" "${SETTINGS_FILE}" 2>/dev/null; then
        pass "stop hook configured"
    else
        warn "stop hook not in settings.json"
    fi
else
    warn "settings.json missing (hooks won't run)"
fi

# Check INDEX.md
echo ""
echo "Checking skill index..."
if [ -f "${SKILLS_DIR}/INDEX.md" ]; then
    skill_count=$(grep -c "^\- \*\*" "${SKILLS_DIR}/INDEX.md" 2>/dev/null || echo "0")
    pass "INDEX.md exists with ${skill_count} skills"
else
    warn "INDEX.md not generated (run generate-skill-index.sh)"
fi

# Check templates
echo ""
echo "Checking templates..."
if [ -f "${SKILLS_DIR}/agent-manager/templates/skill-template.md" ]; then
    pass "skill template exists"
else
    fail "skill template missing"
fi

# Check patterns
echo ""
echo "Checking patterns..."
for pattern in hooks.md mcp.md skills.md agents.md; do
    if [ -f "${SKILLS_DIR}/agent-manager/patterns/${pattern}" ]; then
        pass "patterns/${pattern} exists"
    else
        fail "patterns/${pattern} missing"
    fi
done

# Summary
echo ""
echo "====================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}Installation verified successfully!${NC}"
    exit 0
else
    echo -e "${RED}Found ${ERRORS} error(s). Please fix and re-run.${NC}"
    exit 1
fi
