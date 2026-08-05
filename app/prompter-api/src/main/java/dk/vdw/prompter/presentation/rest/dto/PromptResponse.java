package dk.vdw.prompter.presentation.rest.dto;

import java.time.OffsetDateTime;
import java.util.Map;
import java.util.UUID;

public record PromptResponse(
    UUID id,
    String name,
    String version,
    String content,
    String description,
    Map<String, Object> metadata,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt
) {}
