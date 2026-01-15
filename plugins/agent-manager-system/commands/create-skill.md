# Create New Claude Code Skill

Systematic workflow for designing and implementing new Claude Code skills with progressive disclosure architecture, comprehensive patterns, and proper resource organization.

[Extended thinking: Creating effective skills requires understanding the knowledge domain, designing progressive disclosure content, creating practical examples, and organizing supporting resources. Skills should teach concepts progressively from basic to advanced while providing actionable patterns and real-world applications.]

## Prerequisites

$ARGUMENTS - Description of the skill to create (topic, patterns to cover, target audience)

## Phase 1: Skill Planning

### 1.1 Define Skill Scope
```
Use: agent-manager
Task: Analyze skill requirements and define scope
```

Document:
- **Topic area**: What knowledge domain does this cover?
- **Target audience**: Beginner, intermediate, or advanced developers?
- **Learning objectives**: What should users be able to do after using this skill?
- **Activation triggers**: What keywords/contexts should activate this skill?
- **Depth level**: Quick reference or comprehensive guide?

### 1.2 Research Existing Skills

Search for related skills:
- Check for overlap with existing skills
- Identify complementary skills for cross-referencing
- Find skills to use as structural templates
- Look for gaps this skill would fill

### 1.3 Outline Content Structure

Plan the progressive disclosure:

**Level 1 - Metadata** (Always loaded):
- Name and description
- Activation criteria

**Level 2 - Core Content** (Loaded when activated):
- When to use
- Core concepts
- Fundamental patterns
- Quick start guide

**Level 3 - Advanced Content** (Loaded on demand):
- Advanced patterns
- Real-world applications
- Performance optimization
- Testing strategies

**Level 4 - Resources** (Loaded on request):
- Templates and checklists
- Reference documentation
- Code examples

## Phase 2: Content Development

### 2.1 Write "When to Use" Section

Create clear activation scenarios:
```markdown
## When to Use This Skill

- {Scenario 1 with specific trigger}
- {Scenario 2 with specific trigger}
- {Scenario 3 with specific trigger}
- {Scenario 4 with specific trigger}
```

Be specific about:
- File types or patterns that trigger activation
- User intent keywords
- Problem types being solved
- Technologies involved

### 2.2 Document Core Concepts

Explain fundamental theory:
- Key terminology definitions
- Underlying principles
- Mental models for understanding
- Prerequisites and assumptions

### 2.3 Create Quick Start

Provide immediate value:
```python
# Quick Start Example
# This should be a complete, working example
# that demonstrates the core pattern

def example_function():
    """Demonstrates the fundamental pattern."""
    # Clear, commented code
    pass
```

Requirements:
- Complete, runnable code
- Clear comments explaining each step
- Realistic but simple scenario
- Copy-paste ready

### 2.4 Develop Fundamental Patterns

Document 3-5 essential patterns:

```markdown
### Pattern 1: {Pattern Name}

**When to use**: {Specific scenarios}

**Implementation**:
```python
# Pattern implementation with full code
```

**Key points**:
- Point 1
- Point 2
```

Each pattern should include:
- Clear name and purpose
- When to use guidance
- Complete code example
- Key takeaways

### 2.5 Develop Advanced Patterns

Document 2-4 complex patterns:
- Build on fundamental patterns
- Show composition and combination
- Include edge case handling
- Demonstrate production considerations

### 2.6 Add Real-World Applications

Provide practical examples:
- Common use cases in actual projects
- Integration with popular frameworks
- Before/after comparisons
- Production deployment considerations

### 2.7 Document Common Pitfalls

List mistakes to avoid:
```markdown
## Common Pitfalls

### Pitfall 1: {Name}
**Problem**: {What goes wrong}
**Solution**: {How to fix or avoid}

### Pitfall 2: {Name}
**Problem**: {What goes wrong}
**Solution**: {How to fix or avoid}
```

Include:
- Common beginner mistakes
- Subtle issues that cause bugs
- Performance anti-patterns
- Security vulnerabilities

### 2.8 Create Testing Section

Document validation approaches:
- Unit testing patterns
- Integration testing strategies
- Test data management
- Mocking and stubbing techniques

## Phase 3: Resource Development

### 3.1 Create Assets Directory

`skills/{skill-name}/assets/`

Include:
- **Templates**: Reusable code templates
- **Checklists**: Step-by-step validation lists
- **Scripts**: Automation scripts
- **Configurations**: Config file examples

### 3.2 Create References Directory

`skills/{skill-name}/references/`

Include:
- **Deep dives**: Detailed explanations of complex topics
- **Specifications**: Formal documentation
- **Comparisons**: Alternative approaches compared
- **Migration guides**: Moving from one approach to another

### 3.3 Link Resources in Main Content

Add references section:
```markdown
## Resources

- **assets/template.py**: Starter template for {use case}
- **assets/checklist.md**: Validation checklist for {process}
- **references/deep-dive.md**: Detailed explanation of {topic}
- **references/alternatives.md**: Comparison of {approaches}
```

## Phase 4: Implementation

### 4.1 Create SKILL.md File

```
Use: agent-manager
Task: Generate the complete skill markdown file
```

File location: `plugins/{plugin-name}/skills/{skill-name}/SKILL.md`

Required structure:
```markdown
---
name: {skill-name}
description: {Brief description with activation triggers}
---

# {Skill Title}

{Introduction paragraph}

## When to Use This Skill
{Bullet points}

## Core Concepts
{Fundamental knowledge}

## Quick Start
{Code example}

## Fundamental Patterns
{3-5 patterns with code}

## Advanced Patterns
{2-4 complex patterns}

## Real-World Applications
{Practical examples}

## Performance Best Practices
{Optimization tips}

## Common Pitfalls
{Mistakes to avoid}

## Testing
{Validation approaches}

## Resources
{Links to assets and references}
```

### 4.2 Create Supporting Files

Based on skill needs:
- Templates in `assets/`
- Reference docs in `references/`
- Example code in appropriate locations

## Phase 5: Integration

### 5.1 Determine Plugin Placement

Choose the right plugin:
- Match domain to existing plugin
- Create new plugin if needed
- Consider skill sharing across plugins

### 5.2 Update Marketplace

```
Use: plugin-architect
Task: Update marketplace.json with new skill
```

Add skill reference:
```json
"skills": [
  "./skills/existing-skill",
  "./skills/{new-skill-name}"
]
```

### 5.3 Update Plugin Version

Increment appropriately:
- MINOR for new skill addition
- PATCH for skill improvements

## Phase 6: Validation

### 6.1 Content Checklist

- [ ] YAML frontmatter is valid
- [ ] Name matches directory name
- [ ] Description includes activation triggers
- [ ] All sections are complete
- [ ] Code examples are runnable
- [ ] No placeholder text remains

### 6.2 Quality Checklist

- [ ] Progressive disclosure is logical
- [ ] Patterns build on each other
- [ ] Examples are realistic
- [ ] Pitfalls are actionable
- [ ] Resources are useful

### 6.3 Integration Checklist

- [ ] Skill is in correct plugin directory
- [ ] marketplace.json is updated
- [ ] Supporting files are created
- [ ] Cross-references are accurate

## Output Format

When complete, provide:

1. **Skill Directory Path**: Full path to created skill
2. **Files Created**: List of all files
3. **Activation Examples**: Prompts that would use this skill
4. **Integration Notes**: Plugin updates needed
5. **Testing Recommendations**: How to validate

## Success Criteria

Skill creation is successful when:
- Skill activates for intended contexts
- Content is educational and actionable
- Code examples work correctly
- Resources provide additional value
- Integration is complete
