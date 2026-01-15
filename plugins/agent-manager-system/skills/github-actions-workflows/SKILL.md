---
name: github-actions-workflows
description: Master GitHub Actions workflows for Claude Code automation. Create PR reviews, documentation sync, code quality audits, and dependency updates. Use when automating Claude Code with GitHub Actions or building CI/CD pipelines.
---

# GitHub Actions Workflows for Claude Code

Master GitHub Actions workflows to automate Claude Code operations in your CI/CD pipeline.

## When to Use This Skill

- Automating PR reviews with Claude Code
- Setting up scheduled code quality audits
- Creating documentation synchronization workflows
- Building dependency update automation
- Implementing security scanning pipelines
- Creating custom Claude Code automation

## Core Concepts

### Claude Code in CI/CD

Claude Code can run in GitHub Actions to:
- Review pull requests automatically
- Generate and update documentation
- Perform code quality audits
- Update dependencies with testing
- Run security scans
- Automate routine tasks

### Authentication

Claude Code in GitHub Actions requires:
- `ANTHROPIC_API_KEY`: API key for Claude
- `GITHUB_TOKEN`: Automatically provided by GitHub Actions
- Repository permissions: Contents, Pull Requests, Issues

### Workflow Triggers

Common triggers for Claude Code workflows:

| Trigger | Use Case |
|---------|----------|
| `pull_request` | PR review automation |
| `schedule` | Regular audits and updates |
| `workflow_dispatch` | Manual triggering |
| `push` | Post-merge operations |

## Quick Start

```yaml
name: Claude Code PR Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Review PR
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude-code --print "Review this PR and provide feedback on:
          1. Code quality and best practices
          2. Potential bugs or issues
          3. Security concerns
          4. Suggestions for improvement"
```

## Fundamental Patterns

### Pattern 1: Automated PR Review

```yaml
# .github/workflows/pr-claude-code-review.yml
name: Claude Code PR Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

permissions:
  contents: read
  pull-requests: write

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Full history for diff

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Get changed files
        id: changed-files
        run: |
          echo "files=$(git diff --name-only origin/${{ github.base_ref }}...HEAD | tr '\n' ' ')" >> $GITHUB_OUTPUT

      - name: Review changes
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          claude-code --print "
          Review the following changed files: ${{ steps.changed-files.outputs.files }}

          Provide a code review covering:
          1. **Code Quality**: Best practices, readability, maintainability
          2. **Potential Bugs**: Logic errors, edge cases, error handling
          3. **Security**: Vulnerabilities, injection risks, auth issues
          4. **Performance**: Efficiency concerns, optimization opportunities
          5. **Testing**: Test coverage, missing tests

          Format as a structured review with severity levels (Critical/High/Medium/Low).
          " > review.md

      - name: Post review comment
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('review.md', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: review
            });
```

### Pattern 2: Scheduled Documentation Sync

```yaml
# .github/workflows/scheduled-claude-code-docs-sync.yml
name: Documentation Sync

on:
  schedule:
    - cron: '0 0 1 * *'  # Monthly on the 1st
  workflow_dispatch:  # Manual trigger

permissions:
  contents: write
  pull-requests: write

jobs:
  sync-docs:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Update documentation
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude-code --print "
          Analyze the codebase and update documentation:

          1. Update README.md with current project state
          2. Generate/update API documentation
          3. Update CHANGELOG.md with recent changes
          4. Ensure all public functions have docstrings

          Make necessary file changes directly.
          "

      - name: Create PR with updates
        uses: peter-evans/create-pull-request@v5
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: "docs: sync documentation with codebase"
          title: "[Automated] Documentation Sync"
          body: |
            This PR was automatically generated by Claude Code to sync documentation.

            Please review the changes before merging.
          branch: docs/automated-sync
          delete-branch: true
```

### Pattern 3: Weekly Code Quality Audit

```yaml
# .github/workflows/scheduled-claude-code-quality.yml
name: Weekly Code Quality Audit

on:
  schedule:
    - cron: '0 9 * * 1'  # Every Monday at 9 AM
  workflow_dispatch:

permissions:
  contents: read
  issues: write

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Run quality audit
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude-code --print "
          Perform a comprehensive code quality audit:

          1. **Architecture Review**
             - Identify architectural issues
             - Check for circular dependencies
             - Review module organization

          2. **Code Smells**
             - Find duplicated code
             - Identify overly complex functions
             - Check for dead code

          3. **Security Scan**
             - Identify potential vulnerabilities
             - Check for hardcoded secrets
             - Review authentication/authorization

          4. **Performance Analysis**
             - Find N+1 queries
             - Identify memory leaks
             - Check for blocking operations

          5. **Technical Debt**
             - List TODO/FIXME comments
             - Identify outdated patterns
             - Suggest modernization opportunities

          Output a prioritized list of issues with severity and recommendations.
          " > audit-report.md

      - name: Create issue with report
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const report = fs.readFileSync('audit-report.md', 'utf8');
            github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: `Weekly Code Quality Audit - ${new Date().toISOString().split('T')[0]}`,
              body: report,
              labels: ['audit', 'technical-debt']
            });
```

### Pattern 4: Dependency Update Workflow

```yaml
# .github/workflows/scheduled-claude-code-dependency-audit.yml
name: Biweekly Dependency Audit

on:
  schedule:
    - cron: '0 10 1,15 * *'  # 1st and 15th of each month
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

jobs:
  update-deps:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Audit and update dependencies
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          # Get outdated packages
          npm outdated --json > outdated.json || true

          claude-code --print "
          Review the outdated dependencies in outdated.json and:

          1. Identify security vulnerabilities
          2. Check for breaking changes in major updates
          3. Update safe dependencies (patch/minor)
          4. Create a migration plan for major updates

          Update package.json for safe updates only.
          "

      - name: Run tests
        run: npm test

      - name: Create PR if changes
        uses: peter-evans/create-pull-request@v5
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: "chore(deps): update dependencies"
          title: "[Automated] Dependency Updates"
          body: |
            This PR updates dependencies identified as safe to upgrade.

            All tests have passed. Please review before merging.
          branch: deps/automated-update
          delete-branch: true
```

## Advanced Patterns

### Pattern 5: Security Scanning Pipeline

```yaml
name: Security Scan

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

permissions:
  contents: read
  security-events: write

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Run security scan
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude-code --print "
          Perform a comprehensive security scan:

          1. **OWASP Top 10 Check**
             - Injection vulnerabilities
             - Broken authentication
             - Sensitive data exposure
             - XXE
             - Broken access control
             - Security misconfiguration
             - XSS
             - Insecure deserialization
             - Vulnerable components
             - Insufficient logging

          2. **Secret Detection**
             - Hardcoded API keys
             - Passwords in code
             - Private keys
             - Connection strings

          3. **Dependency Vulnerabilities**
             - Known CVEs
             - Outdated packages with security issues

          Output in SARIF format for GitHub Security tab integration.
          " > security-results.sarif

      - name: Upload SARIF results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: security-results.sarif
```

### Pattern 6: Multi-Job Pipeline

```yaml
name: Full CI Pipeline with Claude Code

on:
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test

  claude-review:
    needs: [lint, test]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm install -g @anthropic-ai/claude-code
      - name: Review
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude-code --print "
          Lint and tests passed. Now perform a deep code review...
          "
```

## Real-World Applications

### Complete CI/CD Integration

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm run build
      - run: npm test

  claude-code-review:
    needs: build
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - run: npm install -g @anthropic-ai/claude-code
      - name: Comprehensive Review
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude-code --print "
          Perform a comprehensive PR review covering:
          - Code quality and architecture
          - Security vulnerabilities
          - Performance implications
          - Test coverage
          - Documentation completeness
          "

  deploy-staging:
    needs: [build, claude-code-review]
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploy to staging"

  deploy-production:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: echo "Deploy to production"
```

## Common Pitfalls

### Pitfall 1: Missing API Key
**Problem**: Workflow fails because ANTHROPIC_API_KEY is not set
**Solution**: Add secret in repository settings: Settings > Secrets > Actions

### Pitfall 2: Insufficient Permissions
**Problem**: Workflow can't write comments or create PRs
**Solution**: Add appropriate permissions to workflow

### Pitfall 3: Rate Limiting
**Problem**: Too many Claude Code calls exceed rate limits
**Solution**: Add caching, reduce frequency, or batch requests

### Pitfall 4: Large Diffs
**Problem**: PR has too many changes for effective review
**Solution**: Filter to relevant files, summarize large changes

### Pitfall 5: Sensitive Data in Logs
**Problem**: API responses contain sensitive information
**Solution**: Filter outputs, use secrets masking

## Security Best Practices

1. **Store API keys as secrets**: Never hardcode in workflow files
2. **Use minimal permissions**: Only request necessary permissions
3. **Pin action versions**: Use specific versions, not `@latest`
4. **Review before merge**: Always review automated changes
5. **Limit trigger scope**: Don't run on all events unnecessarily

## Testing Your Workflow

1. **Dry Run**: Use `workflow_dispatch` to test manually
2. **Fork Test**: Test in a fork before main repo
3. **Step Output**: Add echo statements to debug
4. **Local Act**: Use [act](https://github.com/nektos/act) for local testing

## Resources

- **assets/workflow-templates/**: Ready-to-use workflow templates
- **assets/scripts/**: Helper scripts for workflows
- **references/github-actions.md**: GitHub Actions best practices
- **references/claude-code-ci.md**: Claude Code CI/CD patterns
