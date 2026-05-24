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
- [x] Layer 3 Database Infrastructure
- [x] Layer 4 Application Infrastructure
- [x] Spring Boot API Foundation (BFF)
- [x] Micro-frontend Skeleton
- [x] Prompt Domain Model and Repository (#11, #12, #13)
- [ ] Prompt CRUD operations
- [ ] Versioning support

## PR Status
| Branch | PR | Status |
|--------|----|--------|
| `app/prompter/domain-model` | | 🚧 Draft |

## Session Summary
**Branch**  : `app/prompter/domain-model`
**Goal**    : Implement the Prompt domain entity and repository with UUID support.
**Scope**   : Prompt entity, PromptRepository, Integration tests.
**Out**     : REST Controller, Service layer.
**Issues**  : #11, #12, #13

## Current Status
Implemented Prompt domain model and verified with integration tests.

## Next Steps
- Create Application Services for Prompt Management.
- Implement REST API for CRUD operations.
- Connect Micro-frontend to BFF.

## Blockers
None.

## Outstanding Items
- Define MFE technology (Vanilla vs React).
- Setup CI/CD pipeline.
