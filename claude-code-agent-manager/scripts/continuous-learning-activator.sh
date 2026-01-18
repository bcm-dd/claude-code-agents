#!/bin/bash
# Continuous Learning Activator Hook
#
# This hook injects a learning evaluation reminder into every prompt,
# ensuring Claude evaluates sessions for extractable knowledge.
#
# Installation:
#   1. Copy to ~/.claude/hooks/ (create if needed)
#   2. Make executable: chmod +x continuous-learning-activator.sh
#   3. Add to ~/.claude/settings.json (see below)
#
# Settings.json configuration:
# {
#   "hooks": {
#     "UserPromptSubmit": [{
#       "hooks": [{
#         "type": "command",
#         "command": "~/.claude/hooks/continuous-learning-activator.sh"
#       }]
#     }]
#   }
# }

cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║                    CONTINUOUS LEARNING ACTIVE                     ║
╚══════════════════════════════════════════════════════════════════╝

After completing this request, evaluate:

1. Did this require NON-OBVIOUS investigation or discovery?
2. Is the solution REUSABLE for future similar problems?
3. Did I discover something BEYOND standard documentation?

If YES to any:
→ Create a skill file in ~/.claude/skills/ with:
  - Specific name (kebab-case)
  - Description optimized for semantic matching (include error messages)
  - Problem, trigger conditions, solution, verification steps

Quality gates - only extract if:
✓ Reusable across contexts
✓ Non-trivial (required discovery)
✓ Specific with trigger conditions
✓ Actually verified to work

Use template: ~/.claude/skills/agent-manager/templates/skill-template.md
EOF
