#!/bin/bash
# Skill Index Generator
#
# Scans ~/.claude/skills/ and generates an index file for efficient
# skill discovery. Run periodically or after adding new skills.
#
# Usage: ./generate-skill-index.sh
# Override: SKILLS_DIR=/path/to/skills ./generate-skill-index.sh
#
# This solves the "efficiency problem" - instead of Claude loading
# all skills, it loads one small index file and reads full skills
# only when needed.

set -euo pipefail

SKILLS_DIR="${SKILLS_DIR:-${HOME}/.claude/skills}"
INDEX_FILE="${SKILLS_DIR}/INDEX.md"

# Ensure directory exists
if [ ! -d "$SKILLS_DIR" ]; then
    echo "Skills directory not found: $SKILLS_DIR"
    exit 1
fi

echo "Generating skill index..."

cat > "$INDEX_FILE" << 'HEADER'
# Skill Index

Auto-generated index of available skills. Scan this file to find relevant
skills, then read the full SKILL.md when needed.

## How to Use
1. Scan descriptions below for relevant skills
2. Use `Read: ~/.claude/skills/{skill-name}/SKILL.md` to load full content
3. Apply the skill's solution

## Available Skills

HEADER

skill_count=0

# Find all SKILL.md files and extract metadata
for skill_dir in "$SKILLS_DIR"/*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        skill_file="${skill_dir}SKILL.md"

        if [ -f "$skill_file" ]; then
            # Extract description from YAML frontmatter
            # Handles both single-line and multi-line descriptions
            description=""

            # Try to get description from frontmatter
            if grep -q "^description:" "$skill_file" 2>/dev/null; then
                # Check if it's a multi-line description (starts with |)
                if grep -q "^description: |" "$skill_file" 2>/dev/null; then
                    # Multi-line: get first indented line after description:
                    description=$(awk '/^description: \|/{getline; gsub(/^[ \t]+/, ""); print; exit}' "$skill_file")
                else
                    # Single line: get content after "description:"
                    description=$(grep "^description:" "$skill_file" | head -1 | sed 's/^description:[ ]*//' | cut -c1-120)
                fi
            fi

            # Fallback: get first non-header, non-frontmatter line
            if [ -z "$description" ]; then
                description=$(awk '
                    /^---$/ { in_frontmatter = !in_frontmatter; next }
                    in_frontmatter { next }
                    /^#/ { next }
                    /^$/ { next }
                    { print; exit }
                ' "$skill_file" | cut -c1-120)
            fi

            # Skip agent-manager itself in the index (it's meta)
            if [ "$skill_name" != "agent-manager" ]; then
                echo "- **${skill_name}**: ${description}" >> "$INDEX_FILE"
                skill_count=$((skill_count + 1))
            fi
        fi
    fi
done

# Add footer
cat >> "$INDEX_FILE" << FOOTER

---
*Last updated: $(date -Iseconds)*
*Total skills: ${skill_count}*
FOOTER

echo "Index generated at: $INDEX_FILE"
echo "Found $skill_count skills"
