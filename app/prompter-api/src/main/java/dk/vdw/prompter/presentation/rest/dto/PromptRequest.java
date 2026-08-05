package dk.vdw.prompter.presentation.rest.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import java.util.Map;

public record PromptRequest(
    @NotBlank String name,
    @NotBlank @Pattern(regexp = "^\\d+\\.\\d+\\.\\d+$") String version,
    @NotBlank String content,
    String description,
    Map<String, Object> metadata
) {}
