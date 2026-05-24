# prompter

Spring Boot application for storing and managing AI prompts for various agents.

## Purpose
Provide a centralized, versioned, and managed store for AI prompts with a micro-frontend for management and a BFF for agent integration.

## Prerequisites
- Java 25 (LTS)
- Maven
- Node.js (for MFE)
- access to `postgres-hotel`

## Usage/Quick Start
TBD

## Features or Outputs
- Prompt Storage and Versioning
- Backend for Frontend (BFF)
- Micro-frontend UI
- PostgreSQL persistence (Layer 3)

### 2026-05-24: Domain Model Implementation
- Implemented `Prompt` domain entity with UUID ID, semantic versioning, and JSONB metadata.
- Created `PromptRepository` for persistence.
- Verified persistence with integration tests using H2.
- Initialized repository structure.
- Defined Layer 3 (DB) and Layer 4 (App) infrastructure layout.
- Planned Spring Boot API and MFE initialization.
- Created Layer 3 PostgreSQL configuration in `infrastructure/prompter-db/`.
- Scaffolded Layer 4 App deployment in `infrastructure/prompter/` using `app-skeleton`.
- Initialized Spring Boot API in `app/prompter-api/` (Java 25, Spring Boot 4.0.6).
- Initialized React Micro-frontend in `app/prompter-ui/` (Vite, TS).
- Configured CI/CD pipeline in `.github/workflows/pipeline.yml`.

## Troubleshooting
TBD
