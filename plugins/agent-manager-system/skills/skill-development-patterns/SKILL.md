---
name: skill-development-patterns
description: Master patterns for creating Claude Code skills with progressive disclosure, comprehensive examples, and effective resource organization. Use when developing new skills, organizing knowledge, or creating learning materials.
---

# Skill Development Patterns

Master patterns for creating effective Claude Code skills that teach concepts progressively and provide actionable knowledge.

## When to Use This Skill

- Creating a new Claude Code skill from scratch
- Organizing technical knowledge into teachable content
- Designing progressive disclosure architectures
- Writing code examples and patterns
- Creating supporting resources (templates, checklists)
- Improving existing skill content

## Core Concepts

### Progressive Disclosure Architecture

Skills use a three-tier architecture to optimize token usage:

**Tier 1: Metadata (Always Loaded)**
```yaml
---
name: skill-name
description: Brief description with activation triggers
---
```
- Determines when the skill activates
- Minimal token cost
- Loaded during initial context

**Tier 2: Core Content (Loaded on Activation)**
- When to Use
- Core Concepts
- Quick Start
- Fundamental Patterns
- Loaded when skill is relevant

**Tier 3: Resources (Loaded on Demand)**
- Advanced Patterns
- Reference Documentation
- Templates and Checklists
- Loaded only when specifically needed

### Content Organization Principles

1. **Start Simple**: Begin with the most common use case
2. **Build Progressively**: Each section builds on previous
3. **Show, Don't Tell**: Code examples over explanations
4. **Be Practical**: Focus on real-world applications
5. **Anticipate Problems**: Document common pitfalls

## Quick Start

```markdown
---
name: my-skill
description: Master {topic} with patterns for {use cases}. Use when {triggers}.
---

# {Skill Title}

{One paragraph introduction explaining what this skill teaches}

## When to Use This Skill
- {Specific scenario 1}
- {Specific scenario 2}
- {Specific scenario 3}

## Core Concepts
{Fundamental knowledge needed to understand the patterns}

## Quick Start
```{language}
# Minimal working example
# that demonstrates the core concept
```

## Fundamental Patterns
### Pattern 1: {Name}
{Description and code example}

## Common Pitfalls
### {Pitfall Name}
**Problem**: {What goes wrong}
**Solution**: {How to fix}

## Resources
- **assets/{template}.md**: {Description}
```

## Fundamental Patterns

### Pattern 1: The Quick Win Start

Always begin with an immediately useful example:

```markdown
## Quick Start

```python
# Get started in 30 seconds
from typing import Optional

def create_user(name: str, email: str, age: Optional[int] = None) -> dict:
    """Create a user with optional fields."""
    return {
        "name": name,
        "email": email,
        "age": age,
        "created_at": datetime.now()
    }

# Usage
user = create_user("Alice", "alice@example.com", 30)
```

This pattern shows:
- Type hints for clarity
- Optional parameters with defaults
- Return type annotation
- Immediate practical usage
```

**Key points**:
- Complete, runnable code
- Comments explain key decisions
- Shows immediate practical value
- Copy-paste ready

### Pattern 2: Building Block Patterns

Organize patterns from simple to complex:

```markdown
## Fundamental Patterns

### Pattern 1: Basic CRUD Operations

The foundation for all data operations:

```python
class UserRepository:
    def create(self, user: User) -> User:
        """Create a new user."""
        pass

    def read(self, user_id: int) -> Optional[User]:
        """Retrieve a user by ID."""
        pass

    def update(self, user_id: int, data: dict) -> User:
        """Update user fields."""
        pass

    def delete(self, user_id: int) -> bool:
        """Delete a user."""
        pass
```

### Pattern 2: Repository with Validation

Builds on Pattern 1 by adding validation:

```python
class ValidatedUserRepository(UserRepository):
    def create(self, user: User) -> User:
        self._validate(user)  # Added validation
        return super().create(user)

    def _validate(self, user: User) -> None:
        if not user.email or '@' not in user.email:
            raise ValidationError("Invalid email")
```

### Pattern 3: Repository with Caching

Builds on Pattern 2 by adding caching:

```python
class CachedUserRepository(ValidatedUserRepository):
    def __init__(self, cache: Cache):
        self.cache = cache

    def read(self, user_id: int) -> Optional[User]:
        cached = self.cache.get(f"user:{user_id}")
        if cached:
            return cached
        user = super().read(user_id)
        self.cache.set(f"user:{user_id}", user)
        return user
```
```

**Key points**:
- Each pattern builds on previous
- Clear naming shows progression
- Code demonstrates the added concept
- Comments highlight what's new

### Pattern 3: Real-World Context

Show patterns in realistic scenarios:

```markdown
## Real-World Applications

### E-commerce Order Processing

Applying the repository patterns to a real e-commerce system:

```python
# Complete working example
from dataclasses import dataclass
from datetime import datetime
from typing import List, Optional
from decimal import Decimal

@dataclass
class Order:
    id: Optional[int]
    customer_id: int
    items: List['OrderItem']
    total: Decimal
    status: str
    created_at: datetime

@dataclass
class OrderItem:
    product_id: int
    quantity: int
    price: Decimal

class OrderRepository:
    """Production-ready order repository with validation and caching."""

    def __init__(self, db: Database, cache: Cache, validator: OrderValidator):
        self.db = db
        self.cache = cache
        self.validator = validator

    async def create(self, order: Order) -> Order:
        """Create order with full validation and inventory check."""
        # Validate order data
        self.validator.validate(order)

        # Check inventory availability
        await self._check_inventory(order.items)

        # Calculate totals
        order.total = self._calculate_total(order.items)

        # Persist to database
        saved = await self.db.orders.insert(order)

        # Invalidate customer's order cache
        self.cache.delete(f"orders:customer:{order.customer_id}")

        return saved

    async def get_customer_orders(
        self,
        customer_id: int,
        limit: int = 10
    ) -> List[Order]:
        """Get customer orders with caching."""
        cache_key = f"orders:customer:{customer_id}"

        cached = self.cache.get(cache_key)
        if cached:
            return cached[:limit]

        orders = await self.db.orders.find(
            customer_id=customer_id,
            limit=100  # Cache more than requested
        )

        self.cache.set(cache_key, orders, ttl=300)
        return orders[:limit]
```

**Why this works in production:**
- Async for non-blocking I/O
- Validation before persistence
- Inventory checking prevents overselling
- Smart caching with invalidation
- Configurable limits for flexibility
```

### Pattern 4: Pitfall Prevention

Document common mistakes with solutions:

```markdown
## Common Pitfalls

### Pitfall 1: N+1 Query Problem

**Problem**: Loading related data in a loop causes performance issues

```python
# BAD: N+1 queries
def get_orders_with_items(order_ids: List[int]):
    orders = db.query("SELECT * FROM orders WHERE id IN (?)", order_ids)
    for order in orders:
        # This runs N additional queries!
        order.items = db.query(
            "SELECT * FROM order_items WHERE order_id = ?",
            order.id
        )
    return orders
```

**Solution**: Use eager loading or batch fetching

```python
# GOOD: 2 queries total
def get_orders_with_items(order_ids: List[int]):
    orders = db.query("SELECT * FROM orders WHERE id IN (?)", order_ids)

    # Batch load all items in one query
    all_items = db.query(
        "SELECT * FROM order_items WHERE order_id IN (?)",
        order_ids
    )

    # Group items by order
    items_by_order = defaultdict(list)
    for item in all_items:
        items_by_order[item.order_id].append(item)

    for order in orders:
        order.items = items_by_order[order.id]

    return orders
```

### Pitfall 2: Missing Transaction Boundaries

**Problem**: Related operations not wrapped in transactions

```python
# BAD: Partial failure leaves inconsistent state
def transfer_funds(from_account: int, to_account: int, amount: Decimal):
    db.query("UPDATE accounts SET balance = balance - ? WHERE id = ?",
             amount, from_account)
    # If this fails, money disappears!
    db.query("UPDATE accounts SET balance = balance + ? WHERE id = ?",
             amount, to_account)
```

**Solution**: Use explicit transactions

```python
# GOOD: All-or-nothing operation
def transfer_funds(from_account: int, to_account: int, amount: Decimal):
    with db.transaction():
        db.query("UPDATE accounts SET balance = balance - ? WHERE id = ?",
                 amount, from_account)
        db.query("UPDATE accounts SET balance = balance + ? WHERE id = ?",
                 amount, to_account)
```
```

## Advanced Patterns

### Pattern 5: Resource Organization

Structure supporting materials effectively:

```
skills/{skill-name}/
├── SKILL.md                    # Main content
├── assets/
│   ├── starter-template.py     # Copy-paste starter
│   ├── checklist.md            # Validation checklist
│   └── config-example.yaml     # Configuration template
└── references/
    ├── deep-dive.md            # Detailed explanations
    ├── comparison.md           # Alternative approaches
    └── migration-guide.md      # Upgrading from old patterns
```

### Pattern 6: Reference Linking

Connect main content to resources:

```markdown
## Resources

### Templates
- **assets/starter-template.py**: Production-ready starter with all patterns
- **assets/config-example.yaml**: Standard configuration with comments

### Deep Dives
- **references/deep-dive.md**: Detailed explanation of internal mechanics
- **references/comparison.md**: When to use this vs. alternatives

### Checklists
- **assets/checklist.md**: Pre-deployment validation checklist
```

## Real-World Applications

### Creating a Testing Patterns Skill

```markdown
---
name: testing-patterns
description: Master testing patterns for Python with pytest. Covers unit tests, fixtures, mocking, and test organization. Use when writing tests or improving coverage.
---

# Testing Patterns for Python

Comprehensive guide to writing effective tests with pytest.

## When to Use This Skill
- Writing unit tests for new code
- Improving test coverage
- Setting up test infrastructure
- Debugging failing tests
- Organizing large test suites

## Quick Start
```python
import pytest

def test_user_creation():
    user = User(name="Alice", email="alice@example.com")
    assert user.name == "Alice"
    assert user.email == "alice@example.com"
```
```

### Creating an API Design Skill

```markdown
---
name: api-design-patterns
description: Master REST API design with best practices for endpoints, versioning, and error handling. Use when designing APIs or reviewing API architecture.
---

# API Design Patterns

Design intuitive, consistent, and scalable REST APIs.

## When to Use This Skill
- Designing new API endpoints
- Reviewing API architecture
- Standardizing API conventions
- Handling API versioning
- Implementing error responses
```

## Common Pitfalls

### Pitfall 1: Too Abstract
**Problem**: Explanations without concrete code examples
**Solution**: Every concept needs a code example

### Pitfall 2: Missing Context
**Problem**: Patterns shown without explaining when to use them
**Solution**: Always include "When to use" for each pattern

### Pitfall 3: Incomplete Examples
**Problem**: Code snippets that can't run standalone
**Solution**: Provide complete, copy-paste ready code

### Pitfall 4: No Progression
**Problem**: All patterns at same complexity level
**Solution**: Build from simple to complex

### Pitfall 5: Missing Pitfalls
**Problem**: Not documenting common mistakes
**Solution**: Add pitfalls section with problem/solution pairs

## Testing Your Skill

1. **Activation Test**: Does it activate for expected prompts?
2. **Completeness Test**: Can someone learn from just the skill?
3. **Code Test**: Do all examples run correctly?
4. **Progression Test**: Do patterns build logically?
5. **Practical Test**: Are examples realistic and useful?

## Resources

- **assets/skill-template.md**: Complete skill template
- **assets/example-checklist.md**: Code example quality checklist
- **references/progressive-disclosure.md**: Detailed architecture guide
