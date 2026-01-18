#!/bin/bash
# Stop Hook - Commit Reminder + Learning Evaluation
#
# Runs when Claude stops to check for uncommitted changes
# and remind about knowledge extraction.
#
# Installation:
#   chmod +x stop-hook.sh
#   Add to ~/.claude/settings.json:
#   {
#     "hooks": {
#       "Stop": [{
#         "hooks": [{
#           "type": "command",
#           "command": "~/.claude/hooks/stop-hook.sh"
#         }]
#       }]
#     }
#   }

# Check for uncommitted changes
if git rev-parse --git-dir > /dev/null 2>&1; then
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        echo "⚠️  Uncommitted changes detected. Consider committing before ending session."
    fi
fi

# Learning reminder
cat << 'EOF'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SESSION END: Did this session contain extractable knowledge?

If you solved a non-obvious problem, consider:
  /retrospective - Review session and extract skills
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
