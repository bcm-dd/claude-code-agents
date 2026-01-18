#!/bin/bash
# Skill Index Generator
#
# Scans ~/.claude/skills/ and generates an index file for efficient
# skill discovery. Run periodically or after adding new skills.
#
# Usage: ./generate-skill-index.sh
#
# This solves the "efficiency problem" - instead of Claude loading
# all skills, it loads one small index file and reads full skills
# only when needed.

SKILLS_DIR="${HOME}/.claude/skills"
INDEX_FILE="${SKILLS_DIR}/INDEX.md"

echo "Generating skill index..."

cat > "$INDEX_FILE" << 'HEADER'
# Skill Index

Auto-generated index of available skills. Scan this file to find relevant
skills, then read the full SKILL.md when needed.

## How to Use
1. Scan descriptions below for relevant skills
2. Use `Read: ~/.claude/skills/{skill-name}/SKILL.md` to load full content
3. Apply the skill's solution

---

HEADER

# Find all SKILL.md files and extract metadata
for skill_dir in "$SKILLS_DIR"/*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        skill_file="${skill_dir}SKILL.md"

        if [ -f "$skill_file" ]; then
            # Extract description from frontmatter or first paragraph
            description=$(grep -A1 "^description:" "$skill_file" 2>/dev/null | tail -1 | sed 's/^[ -]*//')

            if [ -z "$description" ]; then
                # Fallback: get first non-empty, non-header line
                description=$(grep -v "^#" "$skill_file" | grep -v "^-" | grep -v "^$" | head -1 | cut -c1-100)
            fi

            echo "- **${skill_name}**: ${description}" >> "$INDEX_FILE"
        fi
    fi
done

echo "" >> "$INDEX_FILE"
echo "---" >> "$INDEX_FILE"
echo "*Last updated: $(date -Iseconds)*" >> "$INDEX_FILE"

echo "Index generated at: $INDEX_FILE"
echo "Found $(grep -c "^\- \*\*" "$INDEX_FILE") skills"
