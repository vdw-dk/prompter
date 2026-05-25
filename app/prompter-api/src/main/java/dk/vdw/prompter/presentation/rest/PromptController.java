package dk.vdw.prompter.presentation.rest;

import dk.vdw.prompter.application.service.PromptService;
import dk.vdw.prompter.presentation.rest.dto.PromptRequest;
import dk.vdw.prompter.presentation.rest.dto.PromptResponse;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/prompts")
public class PromptController {

    private final PromptService promptService;

    public PromptController(PromptService promptService) {
        this.promptService = promptService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public PromptResponse createPrompt(@Valid @RequestBody PromptRequest request) {
        return promptService.createPrompt(request);
    }

    @GetMapping
    public List<PromptResponse> getAllPrompts() {
        return promptService.getAllPrompts();
    }

    @GetMapping("/{id}")
    public PromptResponse getPromptById(@PathVariable UUID id) {
        return promptService.getPromptById(id);
    }

    @GetMapping("/name/{name}")
    public List<PromptResponse> getVersionsByName(@PathVariable String name) {
        return promptService.getVersionsByName(name);
    }

    @GetMapping("/name/{name}/version/{version}")
    public PromptResponse getPromptByNameAndVersion(@PathVariable String name, @PathVariable String version) {
        return promptService.getPromptByNameAndVersion(name, version);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deletePrompt(@PathVariable UUID id) {
        promptService.deletePrompt(id);
    }
}
