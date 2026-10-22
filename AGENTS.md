# AGENTS.md

> Read this file before every task. The global `engineering-standards` skill applies
> to all code. This file provides project-specific context that overrides or extends it(you can edited it later).

---

## Project

```
name    : [mobatech]
stack   : [go, flutter, react, nextjs, python]
arch    : [layered, riverpod, app-router]
db      : [mysql, vector-db]
```

## Active Stack Rules

<!-- Active Stacks for CRM Portal: -->

- **typescript**
- **react**
- **nextjs**

### TypeScript Rules

- **Strict Typing:** No implicit or explicit `any`. Set `"strict": true` in `tsconfig.json`.
- **API Payloads:** Define strict interfaces for API responses and request payloads in `src/types/api.ts` matching the Go backend models.
- **Null Safety:** Always handle null/undefined explicitly. Use optional chaining (`?.`) and nullish coalescing (`??`) safely.

### React & Next.js Rules (CRM Portal)

- **Component Architecture:**
  - Leverage Server Components (RSC) by default for data fetching and layout structure.
  - Restrict `"use client"` to interactive UI leaves (e.g., forms, search inputs, modal windows, chart controllers).
  - All pages must define a unique `<h1>` element and appropriate metadata tags for SEO optimization.
- **State Management (Zustand):**
  - Store local ui/global state in slices under `src/store/` (e.g. `useAuthStore`, `useDoctorStore`).
  - Keep stores lean and reactive. Use selector hooks to prevent unnecessary component re-renders.
- **Styling (Glassmorphism & Theme):**
  - Implement a premium Glassmorphism look: `backdrop-filter: blur(12px) saturate(180%)`, semi-transparent background (`rgba(255, 255, 255, 0.7)` / `rgba(23, 42, 30, 0.8)`), dynamic subtle border (`1px solid rgba(...)`), and card shadow.
  - Enforce theme compatibility: Clean Light Mode (white/light gray background) and Elegant Dark Mode (featuring Hermina's deep forest green accents, `#113C2B` / `#1E5E44`).
  - No inline colors, magic spacing numbers, or raw style objects. All themes, sizing tokens, and layout constants must be defined in `src/styles/theme.ts` or `src/styles/globals.css`.
- **Security & PDP Compliance:**
  - Create a secure helper layer (`src/lib/crypto.ts`) to handle AES-256 encryption/decryption of patient data.
  - Route all API interactions through an authenticated Axios instance (`src/lib/api.ts`) that automatically handles JWT tokens and injects encryption for sensitive payloads.
- **Modularity Constraints:**
  - Ensure all components are under 150 lines. Extract complex elements (like Live Booking Queue tables, RAG status graphs) to smaller sub-components in `src/components/`.
  - Limit helper/utility functions to 30 lines. Use custom hooks to extract data-fetching or input-filtering logic.
  - Display user operations status (success, error, warning) using `CustomSnackbar`.

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


mobatech-ai/                  # Python AI & RAG Engine Layer
├── ...                       # Scripts for chunking, embeddings, and RAG

mobatech-crm/                 # CRM Admin Portal (Next.js/React)
├── src/
│   ├── app/                  # App Router (Pages, Layouts, API Routes)
│   ├── components/           # Reusable UI components (Glassmorphism, etc.)
│   ├── lib/                  # Utilities, API clients (Axios/Fetch)
│   ├── store/                # State management (Zustand/Redux)
│   └── styles/               # Global styles (Tailwind/Vanilla CSS)
└── package.json              # Node dependencies
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
- Apply premium, modern, glassmorphism UI themes for web portals (CRM).

Must not:

- Create or rename folders without approval.
- Leave any TODO, placeholder, or debug output in final code.
- Write inline color values, string literals, or magic numbers.
- Exceed 150 lines per file or 30 lines per function.
