---
name: prisma-serverless-connection-pool
description: |
  Fix Prisma P2024 "Timed out fetching a new connection from the connection pool"
  in serverless environments (Vercel, AWS Lambda, Netlify). Triggers on connection
  pool exhaustion, too many database connections, or PrismaClientKnownRequestError.
version: 1.0.0
author: auto-extracted
date: 2024-01-15
---

# Prisma Serverless Connection Pool Exhaustion

Fix connection pool timeout errors when using Prisma with serverless functions.

## Problem

Serverless functions create new Prisma client instances on cold starts. Each instance
opens multiple database connections. Under load, this rapidly exhausts connection
limits on managed databases (especially free tiers with 20-25 connection limits).

**Error message:**
```
PrismaClientKnownRequestError: P2024
Timed out fetching a new connection from the connection pool
```

## Trigger Conditions

- Using Prisma ORM with PostgreSQL/MySQL
- Deployed to serverless: Vercel, AWS Lambda, Netlify Functions
- Managed database: Supabase, Neon, PlanetScale, Railway
- High concurrent traffic or load testing
- Free tier database with limited connections

## Solution

### Step 1: Configure Connection Limits

Add connection parameters to your DATABASE_URL:

```env
# .env
DATABASE_URL="postgresql://user:pass@host:5432/db?connection_limit=1&pool_timeout=20"
```

Parameters:
- `connection_limit=1` - Single connection per serverless instance
- `pool_timeout=20` - Wait up to 20s for available connection

### Step 2: Use Connection Pooler (Recommended)

**For Supabase:**
```env
# Use pooler URL (port 6543, not 5432)
DATABASE_URL="postgresql://user:pass@db.xxx.supabase.co:6543/postgres?pgbouncer=true"
DIRECT_URL="postgresql://user:pass@db.xxx.supabase.co:5432/postgres"
```

**For Neon:**
```env
DATABASE_URL="postgresql://user:pass@ep-xxx.us-east-2.aws.neon.tech/db?sslmode=require&pgbouncer=true"
```

**schema.prisma:**
```prisma
datasource db {
  provider  = "postgresql"
  url       = env("DATABASE_URL")
  directUrl = env("DIRECT_URL")  // For migrations
}
```

### Step 3: Singleton Pattern (Development)

Prevent hot-reload from creating multiple clients:

```typescript
// lib/prisma.ts
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient }

export const prisma = globalForPrisma.prisma || new PrismaClient()

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
```

### Step 4: Consider Prisma Accelerate

For high-traffic production apps:

```bash
npx prisma generate --accelerate
```

```env
DATABASE_URL="prisma://accelerate.prisma-data.net/?api_key=xxx"
```

## Verification

1. Deploy the fix
2. Load test with concurrent requests:
```bash
npx autocannon -c 50 -d 30 https://your-app.vercel.app/api/endpoint
```
3. Monitor database dashboard - connections should stay within limits

## Example

### Before
```
# 50 concurrent requests = 50+ connections
# Database limit: 25
# Result: P2024 errors
```

### After
```
# 50 concurrent requests = 50 connections through pooler
# Pooler handles queuing
# Result: All requests succeed (some with latency)
```

## Notes

- `connection_limit=1` trades throughput for reliability
- PlanetScale (MySQL) uses a different architecture and rarely has this issue
- Prisma Accelerate adds latency but handles connection pooling automatically
- For very high traffic, consider dedicated database or connection pooler infrastructure

## References

- [Prisma Connection Management](https://www.prisma.io/docs/guides/performance-and-optimization/connection-management)
- [Supabase Connection Pooling](https://supabase.com/docs/guides/database/connecting-to-postgres#connection-pooler)
