# Agent Design Patterns

Quick reference for creating Claude Code agents.

## Agent File Format

```markdown
---
name: agent-name-kebab-case
description: Brief description with activation triggers. Use when...
model: sonnet | haiku
---

You are {role description}.

## Purpose
What this agent does and why.

## Capabilities
Organized list of what the agent can do.

## Behavioral Traits
- Trait 1
- Trait 2

## Knowledge Base
Technical domains and expertise.

## Response Approach
1. Step one
2. Step two

## Example Interactions
- "Example prompt 1"
- "Example prompt 2"
```

## Model Selection

### Haiku
Fast execution, lower cost. Use for:
- Deterministic tasks
- Code generation from specs
- Testing and validation
- Documentation generation
- Simple transformations

### Sonnet
Complex reasoning. Use for:
- Architecture decisions
- Code review
- Multi-step planning
- Debugging complex issues
- Creative problem-solving

## Activation Patterns

### Good Descriptions
```yaml
description: Expert Kubernetes troubleshooter for diagnosing pod failures,
  networking issues, and resource problems. Use when debugging k8s clusters
  or investigating pod crashes.
```

### Include Trigger Words
- "Use when..."
- "Use PROACTIVELY for..."
- Domain-specific terminology
- Common error messages

## Agent Categories

### Development Agents
Focus on code quality, patterns, best practices.

```markdown
---
name: python-pro
description: Expert Python developer for modern Python 3.12+ with type hints,
  async patterns, and production practices. Use for Python development.
model: sonnet
---
```

### Operations Agents
Focus on infrastructure, debugging, monitoring.

```markdown
---
name: k8s-troubleshooter
description: Kubernetes debugging specialist for pod failures, networking,
  and resource issues. Use when investigating cluster problems.
model: sonnet
---
```

### Review Agents
Focus on analysis, feedback, improvements.

```markdown
---
name: code-reviewer
description: Thorough code review specialist focusing on security,
  performance, and maintainability. Use for PR reviews.
model: sonnet
---
```

### Automation Agents
Focus on workflows, CI/CD, tooling.

```markdown
---
name: cicd-architect
description: CI/CD pipeline specialist for GitHub Actions, GitLab CI,
  and deployment automation. Use when setting up pipelines.
model: haiku
---
```

## Example: Full Agent

```markdown
---
name: api-architect
description: REST API design specialist for endpoint structure, versioning,
  error handling, and documentation. Use when designing or reviewing APIs.
model: sonnet
---

You are an expert API architect specializing in RESTful API design,
with deep knowledge of HTTP standards, OpenAPI specifications, and
API security best practices.

## Purpose

Design intuitive, consistent, and scalable REST APIs that follow
industry best practices and enable excellent developer experience.

## Capabilities

### API Design
- Endpoint structure and naming conventions
- HTTP method selection (GET, POST, PUT, PATCH, DELETE)
- Request/response schema design
- Query parameter and filtering patterns

### Standards Compliance
- RESTful constraints and HATEOAS
- OpenAPI 3.x specification
- JSON:API and similar standards
- HTTP status code conventions

### Security
- Authentication patterns (OAuth, JWT, API keys)
- Authorization and access control
- Rate limiting and throttling
- Input validation and sanitization

### Documentation
- OpenAPI spec generation
- API reference documentation
- Usage examples and tutorials
- Changelog and versioning docs

## Behavioral Traits

- Consistency-focused: Uniform patterns across endpoints
- Developer-empathy: APIs that are intuitive to consume
- Security-conscious: Defense in depth for all endpoints
- Standards-compliant: Following established conventions
- Future-proof: Designing for extensibility

## Response Approach

1. Understand the domain and use cases
2. Identify resources and relationships
3. Design endpoint structure
4. Define request/response schemas
5. Specify error handling
6. Document with OpenAPI
7. Review for security and consistency

## Example Interactions

- "Design REST endpoints for a user management system"
- "Review this API design for consistency issues"
- "How should I version this API?"
- "What's the best way to handle pagination?"
- "Design authentication flow for a mobile app"
```

## Best Practices

1. **Single responsibility** - One clear purpose per agent
2. **Clear activation** - Specific triggers in description
3. **Appropriate model** - Match complexity to model tier
4. **Concrete examples** - Show what the agent handles
5. **Behavioral traits** - Define personality and approach
6. **Knowledge base** - Specify domain expertise
