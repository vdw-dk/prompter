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
- [x] Prompt CRUD operations (#14, #15, #16, #17)
- [x] Frontend Implementation (#18, #19, #20, #21)
- [ ] Versioning support (Enhanced UI)

## PR Status
| Branch | PR | Status |
|--------|----|--------|
| `app/prompter/frontend-implementation` | | 🚧 Draft |

## Session Summary
**Branch**  : `app/prompter/frontend-implementation`
**Goal**    : Implement the Prompter UI and connect to BFF.
**Scope**   : React components, API client, State management.
**Out**     : CD pipeline setup.
**Issues**  : #18, #19, #20, #21

## Current Status
Implemented the frontend micro-frontend and integrated it with the BFF API. Verified CRUD operations and state management.

## Next Steps
- Connect Micro-frontend to BFF.
- Implement UI for prompt listing and creation.
- Add support for specific agent prompt templates.

## Blockers
None.

## Outstanding Items
- Define MFE technology (Vanilla vs React).
- Setup CI/CD pipeline.
