# AGENTS.md

> Read this file before every task. The global `engineering-standards` skill applies
> to all code. This file provides project-specific context that overrides or extends it.

---

## Project

```
name    : [mobatech]
stack   : [go, flutter]
arch    : [layered, riverpod]
db      : [mysql]
```

## Active Stack Rules

<!-- Uncomment one or more: -->
<!-- go | typescript | react | laravel | flutter -->

```
stacks: [go, flutter]
```

## Folder Structure

```
mobatech-backend/
├── config/                   # Global configuration variables
├── controllers/              # HTTP Request handlers, validation, response formatting
├── middleware/               # Request interceptors (auth, logging)
├── models/                   # GORM DB models and entities
├── repositories/             # Database access queries and logic
├── routes/                   # API endpoint definitions
├── services/                 # Core business logic layer
└── main.go                   # Go application entry point

mobatech-flutter/
├── android/                  # Android native project files
├── ios/                      # iOS native project files
├── lib/                      # Application source code
│   ├── features/             # Feature-based modular architecture
│   │   └── [feature]/        
│   │       ├── data/         # Repositories, models, APIs
│   │       ├── domain/       # Business logic, entities
│   │       └── presentation/ # Widgets, Riverpod providers, screens
│   └── main.dart             # Flutter application entry point
└── pubspec.yaml              # App dependencies (Riverpod, Dio, GoRouter, etc.)
```

## Error Code Registry

| Code               | Status | Meaning                           |
| ------------------ | ------ | --------------------------------- |
| `VALIDATION_ERROR` | 422    | Input validation failed           |
| `UNAUTHENTICATED`  | 401    | Missing or invalid token          |
| `UNAUTHORIZED`     | 403    | Insufficient permissions          |
| `NOT_FOUND`        | 404    | Resource does not exist           |
| `CONFLICT`         | 409    | Duplicate or constraint violation |
| `INTERNAL_ERROR`   | 500    | Unexpected failure                |

## Agent Constraints

Must:

- Propose approach before touching more than one file.
- Add new strings/colors to constants files before referencing them.
- Ask before installing a new dependency.

Must not:

- Create or rename folders without approval.
- Leave any TODO, placeholder, or debug output in final code.
- Write inline color values, string literals, or magic numbers.
- Exceed 150 lines per file or 30 lines per function.
