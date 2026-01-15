---
name: mcp-server-patterns
description: Master MCP (Model Context Protocol) server integration patterns for Claude Code. Connect to external services like JIRA, GitHub, Slack, and databases. Use when integrating external tools, building custom MCP servers, or extending Claude Code capabilities.
---

# MCP Server Patterns

Master Model Context Protocol (MCP) server integration to extend Claude Code with external service connections.

## When to Use This Skill

- Integrating Claude Code with issue trackers (JIRA, Linear)
- Connecting to code platforms (GitHub, GitLab)
- Adding database access (PostgreSQL, MongoDB)
- Building communication integrations (Slack, Discord)
- Creating custom MCP servers for proprietary systems
- Extending Claude Code with external APIs

## Core Concepts

### What is MCP?

Model Context Protocol (MCP) is a standard for connecting AI assistants to external tools and data sources. MCP servers expose:

- **Tools**: Actions the AI can perform
- **Resources**: Data the AI can access
- **Prompts**: Pre-defined prompt templates

### MCP Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Claude Code   │────▶│   MCP Server    │────▶│ External Service│
│    (Client)     │◀────│  (Translator)   │◀────│  (API/Database) │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

### Configuration Location

MCP servers are configured in `.claude/settings.json`:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-name"],
      "env": {
        "API_KEY": "your-key"
      }
    }
  }
}
```

## Quick Start

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

This connects Claude Code to GitHub, enabling:
- Repository browsing
- Issue management
- Pull request operations
- Code search

## Fundamental Patterns

### Pattern 1: Issue Tracker Integration

Connect to JIRA for issue management:

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-jira"],
      "env": {
        "JIRA_URL": "https://your-company.atlassian.net",
        "JIRA_EMAIL": "${JIRA_EMAIL}",
        "JIRA_API_TOKEN": "${JIRA_API_TOKEN}"
      }
    }
  }
}
```

**Capabilities enabled:**
- Fetch issue details
- Create and update issues
- Search issues with JQL
- Manage issue transitions
- Add comments and attachments

**Example usage:**
```
User: "Get the details of PROJ-123 and summarize the requirements"
Claude: [Uses JIRA MCP to fetch issue] Here's the summary...

User: "Create a task for implementing the login feature"
Claude: [Uses JIRA MCP to create issue] Created PROJ-456...
```

### Pattern 2: Code Platform Integration

Connect to GitHub for repository operations:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Capabilities enabled:**
- Repository browsing and search
- Issue and PR management
- Code review operations
- Workflow management
- Release operations

### Pattern 3: Database Integration

Connect to PostgreSQL for data access:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

**Capabilities enabled:**
- Execute SQL queries
- Browse schema information
- Inspect table structures
- Run data analysis queries

**Security note:** Use read-only credentials for safety:
```
DATABASE_URL=postgresql://readonly_user:password@host:5432/dbname
```

### Pattern 4: Communication Integration

Connect to Slack for team communication:

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_TEAM_ID": "${SLACK_TEAM_ID}"
      }
    }
  }
}
```

**Capabilities enabled:**
- Read channel messages
- Post messages and updates
- Search conversation history
- Manage channel membership

### Pattern 5: Error Monitoring Integration

Connect to Sentry for error tracking:

```json
{
  "mcpServers": {
    "sentry": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sentry"],
      "env": {
        "SENTRY_AUTH_TOKEN": "${SENTRY_AUTH_TOKEN}",
        "SENTRY_ORG": "your-org",
        "SENTRY_PROJECT": "your-project"
      }
    }
  }
}
```

**Capabilities enabled:**
- Fetch error details
- Analyze error trends
- Search issues
- Access stack traces

## Advanced Patterns

### Pattern 6: Multi-Service Workflow

Combine multiple MCP servers for complete workflows:

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-jira"],
      "env": {
        "JIRA_URL": "${JIRA_URL}",
        "JIRA_EMAIL": "${JIRA_EMAIL}",
        "JIRA_API_TOKEN": "${JIRA_API_TOKEN}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_TEAM_ID": "${SLACK_TEAM_ID}"
      }
    }
  }
}
```

**Example workflow:**
```
User: "Implement PROJ-123"
Claude:
1. [JIRA MCP] Fetches issue details
2. [GitHub MCP] Creates branch, implements code
3. [GitHub MCP] Creates PR linked to issue
4. [JIRA MCP] Updates issue status
5. [Slack MCP] Notifies team of PR
```

### Pattern 7: Custom MCP Server

Build a custom MCP server for proprietary systems:

```typescript
// custom-server/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server(
  { name: "custom-server", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

// Define a tool
server.setRequestHandler("tools/list", async () => ({
  tools: [
    {
      name: "fetch_data",
      description: "Fetch data from internal API",
      inputSchema: {
        type: "object",
        properties: {
          endpoint: { type: "string", description: "API endpoint" },
          params: { type: "object", description: "Query parameters" }
        },
        required: ["endpoint"]
      }
    }
  ]
}));

// Implement the tool
server.setRequestHandler("tools/call", async (request) => {
  if (request.params.name === "fetch_data") {
    const { endpoint, params } = request.params.arguments;
    const response = await fetch(`${process.env.API_BASE}${endpoint}`, {
      headers: { Authorization: `Bearer ${process.env.API_TOKEN}` }
    });
    return { content: [{ type: "text", text: await response.text() }] };
  }
});

// Start server
const transport = new StdioServerTransport();
await server.connect(transport);
```

**Configuration:**
```json
{
  "mcpServers": {
    "custom": {
      "command": "node",
      "args": ["./custom-server/dist/index.js"],
      "env": {
        "API_BASE": "https://internal-api.company.com",
        "API_TOKEN": "${INTERNAL_API_TOKEN}"
      }
    }
  }
}
```

### Pattern 8: Resource Exposure

Expose data sources as MCP resources:

```typescript
server.setRequestHandler("resources/list", async () => ({
  resources: [
    {
      uri: "config://app/settings",
      name: "Application Settings",
      description: "Current application configuration",
      mimeType: "application/json"
    },
    {
      uri: "docs://api/reference",
      name: "API Reference",
      description: "Internal API documentation",
      mimeType: "text/markdown"
    }
  ]
}));

server.setRequestHandler("resources/read", async (request) => {
  const uri = request.params.uri;

  if (uri === "config://app/settings") {
    const config = await loadConfig();
    return {
      contents: [{ uri, mimeType: "application/json", text: JSON.stringify(config) }]
    };
  }

  if (uri === "docs://api/reference") {
    const docs = await loadDocs();
    return {
      contents: [{ uri, mimeType: "text/markdown", text: docs }]
    };
  }
});
```

## Real-World Applications

### Complete Development Environment

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-jira"],
      "env": {
        "JIRA_URL": "${JIRA_URL}",
        "JIRA_EMAIL": "${JIRA_EMAIL}",
        "JIRA_API_TOKEN": "${JIRA_API_TOKEN}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "sentry": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sentry"],
      "env": {
        "SENTRY_AUTH_TOKEN": "${SENTRY_AUTH_TOKEN}",
        "SENTRY_ORG": "${SENTRY_ORG}",
        "SENTRY_PROJECT": "${SENTRY_PROJECT}"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_TEAM_ID": "${SLACK_TEAM_ID}"
      }
    }
  }
}
```

## Common Pitfalls

### Pitfall 1: Missing Environment Variables
**Problem**: MCP server fails to start due to missing credentials
**Solution**: Use `${VAR_NAME}` syntax and ensure variables are set in shell

### Pitfall 2: Overly Permissive Credentials
**Problem**: Using admin credentials when read-only would suffice
**Solution**: Create dedicated service accounts with minimal permissions

### Pitfall 3: Not Handling Rate Limits
**Problem**: MCP server gets rate limited by external API
**Solution**: Implement retry logic and caching in custom servers

### Pitfall 4: Sensitive Data Exposure
**Problem**: MCP server returns sensitive data to Claude
**Solution**: Filter sensitive fields before returning data

### Pitfall 5: Connection Timeouts
**Problem**: Long-running operations timeout
**Solution**: Implement streaming responses or async patterns

## Security Best Practices

1. **Least Privilege**: Use credentials with minimal required permissions
2. **Environment Variables**: Never hardcode secrets in configuration
3. **Read-Only by Default**: Prefer read-only access unless writes are needed
4. **Audit Logging**: Log all MCP server operations
5. **Network Isolation**: Run MCP servers in isolated environments

## Testing Your MCP Integration

1. **Connection Test**: Verify MCP server starts successfully
2. **Auth Test**: Ensure credentials are valid
3. **Tool Test**: Test each exposed tool individually
4. **Error Test**: Verify error handling for invalid inputs
5. **Performance Test**: Check response times under load

## Resources

- **assets/mcp-config-template.json**: Complete MCP configuration template
- **assets/custom-server-template/**: Starter template for custom servers
- **references/mcp-protocol.md**: Protocol specification reference
- **references/available-servers.md**: List of official MCP servers
