# APIs & SOA Explained Through a Restaurant

## Introduction

Imagine a restaurant.

Customers do not enter the kitchen, cook their own meals, or interact directly with ingredients.

Instead, they interact with a waiter through a standardized process:

1. Request a service
2. Wait for execution
3. Receive a result

This is exactly how APIs work.

---

# API Overview

```text
+-----------+      Order      +---------+      Prepare meal      +----------+
| Customer  | -------------> | Waiter  | ---------------------> | Kitchen  |
+-----------+                +---------+                        +----------+
       ^                           |
       |                           |
       +------ Meal delivered -----+
```

| Restaurant | API World |
|------------|-----------|
| Customer | Application |
| Waiter | API |
| Kitchen | Backend Service |
| Ingredients | Database |
| Menu | API Documentation |
| Order | API Request |
| Meal | API Response |

---

# 1. Service

## Definition

A service provides a specific business capability.

## Restaurant Example

The customer asks:

> "I want a Burger."

The customer does not care:

- Who cooks it
- Which pan is used
- Where ingredients come from

The only expectation is:

> Submit a request and receive a burger.

## API Equivalent

```http
POST /orders
```

The application says:

> Create an order.

---

# 2. Unit of Functionality

## Definition

Each service should perform one clear responsibility.

## Restaurant Example

Instead of one giant service:

❌ "Manage the entire restaurant"

Split into specialized services:

✅ View Menu

✅ Place Order

✅ Pay Bill

✅ Book Table

## Visual

```text
Restaurant
│
├── View Menu
├── Order Food
├── Pay
└── Reserve Table
```

## API Equivalent

```http
GET /menu
POST /orders
POST /payments
POST /reservations
```

---

# 3. Reusable Component

## Definition

The same service can be used by multiple consumers.

## Restaurant Example

The kitchen prepares burgers for:

- Walk-in customers
- Mobile App customers
- Uber Eats customers
- Deliveroo customers

The cooking process remains exactly the same.

## Visual

```text
           Walk-in Customer
                  |
Mobile App -------| 
                  |
Uber Eats --------|----> Burger Service
                  |
Deliveroo --------|
```

## API Equivalent

One API used by:

- Website
- Mobile App
- Internal Tools
- External Partners

---

# 4. Technology Independent

## Definition

Consumers do not need to know the technology implementation.

## Restaurant Example

The customer does not know whether the chef uses:

- Gas stove
- Electric stove
- Wood oven
- Cooking robot

The result remains:

✅ Burger delivered

## API Equivalent

The client does not know whether the backend uses:

- Java
- .NET
- Python
- Node.js

It simply calls:

```http
GET /customer/123
```

---

# 5. Loose Coupling

## Definition

Consumers should not depend on internal implementation.

## Restaurant Example

The customer never enters the kitchen.

They do not say:

❌ Open fridge #2

❌ Take ingredient #5

❌ Use stove #3

Instead:

✅ "I'd like a burger."

## Visual

```text
Customer
    |
    v
 Waiter
    |
    v
 Kitchen

Customer cannot access Kitchen directly
```

## API Equivalent

Applications should access APIs, not databases directly.

---

# 6. Standardized Contract

## Definition

A service exposes a clear contract.

## Restaurant Example

The menu defines:

- Available meals
- Prices
- Options

Everyone uses the same menu.

## Visual

```text
MENU

Burger      €12
Pizza       €15
Salad       €10
```

## API Equivalent

Swagger/OpenAPI documentation.

Input:

```json
{
  "customerId": 123
}
```

Output:

```json
{
  "name": "John Doe"
}
```

---

# 7. Abstraction

## Definition

Hide complexity from consumers.

## Restaurant Example

The customer sees:

✅ Menu

✅ Prices

✅ Waiter

The customer does not see:

❌ Recipes

❌ Suppliers

❌ Stock Levels

❌ Kitchen Operations

## API Equivalent

Applications see endpoints but not business logic.

---

# 8. Discoverability

## Definition

Services should be easy to find and understand.

## Restaurant Example

The menu helps customers discover:

- Burgers
- Drinks
- Desserts

## Visual

```text
MENU
│
├── Burgers
├── Pizzas
├── Drinks
└── Desserts
```

## API Equivalent

Developer Portal

Swagger

Azure API Management

Apigee

Developers can easily discover available APIs.

---

# 9. Autonomy

## Definition

Each service manages itself independently.

## Restaurant Example

The kitchen manages:

- Staff
- Ingredients
- Equipment

Without customer involvement.

## Visual

```text
Customer
     |
     v
  Waiter
     |
     v
 Kitchen
    |
    +-- Staff
    +-- Inventory
    +-- Equipment
```

## API Equivalent

Payment Service owns:

- Payment logic
- Database
- Security rules

Customer Service owns customer data.

Each service evolves independently.

---

# 10. Composability

## Definition

Multiple services can be combined into a larger business process.

## Restaurant Example

Serving a meal requires:

```text
Menu Service
      ↓
Order Service
      ↓
Payment Service
      ↓
Cooking Service
      ↓
Delivery Service
```

Together they achieve:

✅ Customer receives a meal

## API Equivalent

Opening a bank account:

```text
Customer API
      ↓
Identity Verification API
      ↓
Risk API
      ↓
Account API
      ↓
Notification API
```

Several APIs collaborate to deliver one business outcome.

---

# Key Takeaway

## SOA

SOA organizes a system into specialized business services.

## API

An API is the standardized interface used to access those services.

## Restaurant Analogy

```text
Customer
      |
      v
   Waiter  = API
      |
      v
   Kitchen = Services
      |
      v
 Ingredients = Data
```

The customer only interacts with the waiter.

The waiter provides access to the restaurant's capabilities without exposing how everything works internally.