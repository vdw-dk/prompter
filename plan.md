# Plan - prompter

## Problem
Currently, AI prompts are scattered across various agent configurations, making them hard to version, manage, and reuse.

## Approach
Build a centralized Spring Boot service (`prompter-api`) acting as a BFF, a micro-frontend (`prompter-ui`) for user interaction, and use a dedicated PostgreSQL database in the `postgres-hotel`.

## Design Decisions
- **Layer Model:** Follow the 5-layer homelab model.
- **Database:** Layer 3 `postgres-hotel` integration.
- **Infrastructure:** Use `app-skeleton` for Layer 4 deployment.
- **Runtime:** Java 25 + Spring Boot 4.x.
- **Images:** Chainguard for security and minimalism.

## Feature Roadmap
- [ ] Layer 3 Database Infrastructure
- [ ] Layer 4 Application Infrastructure
- [ ] Spring Boot API Foundation (BFF)
- [ ] Micro-frontend Skeleton
- [ ] Prompt CRUD operations
- [ ] Versioning support

## PR Status
| Branch | PR | Status |
|--------|----|--------|
| `infrastructure/prompter/setup` | | 🚧 Draft |

## Session Summary
**Branch**  : `infrastructure/prompter/setup`
**Goal**    : Initialize the prompter project structure and core infrastructure.
**Scope**   : Root docs, Layer 3/4 infra skeletons, Spring Boot API skeleton.
**Out**     : Functional UI implementation, business logic for prompt management.
**Issues**  : #1, #2, #3, #4, #5

## Current Status
Initialized project structure, infrastructure skeletons, and application skeletons. All initial task and test issues verified.

## Next Steps
- Implement Prompt Domain Model and Repository.
- Create basic REST API for Prompt Management.
- Connect Micro-frontend to BFF.

## Blockers
None.

## Outstanding Items
- Define MFE technology (Vanilla vs React).
- Setup CI/CD pipeline.
