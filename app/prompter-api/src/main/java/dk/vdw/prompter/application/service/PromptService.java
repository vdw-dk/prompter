package dk.vdw.prompter.application.service;

import dk.vdw.prompter.domain.Prompt;
import dk.vdw.prompter.domain.PromptRepository;
import dk.vdw.prompter.presentation.rest.dto.PromptRequest;
import dk.vdw.prompter.presentation.rest.dto.PromptResponse;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PromptService {

    private final PromptRepository promptRepository;

    public PromptService(PromptRepository promptRepository) {
        this.promptRepository = promptRepository;
    }

    @Transactional
    public PromptResponse createPrompt(PromptRequest request) {
        if (promptRepository.findByNameAndVersion(request.name(), request.version()).isPresent()) {
            throw new IllegalArgumentException("Prompt with name '" + request.name() + "' and version '" + request.version() + "' already exists.");
        }

        Prompt prompt = new Prompt(
            request.name(),
            request.version(),
            request.content(),
            request.description(),
            request.metadata()
        );

        Prompt saved = promptRepository.save(prompt);
        return mapToResponse(saved);
    }

    @Transactional(readOnly = true)
    public List<PromptResponse> getAllPrompts() {
        return promptRepository.findAll().stream()
            .map(this::mapToResponse)
            .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public PromptResponse getPromptById(UUID id) {
        return promptRepository.findById(id)
            .map(this::mapToResponse)
            .orElseThrow(() -> new ResourceNotFoundException("Prompt not found with id: " + id));
    }

    @Transactional(readOnly = true)
    public List<PromptResponse> getVersionsByName(String name) {
        return promptRepository.findAllByNameOrderByVersionDesc(name).stream()
            .map(this::mapToResponse)
            .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public PromptResponse getPromptByNameAndVersion(String name, String version) {
        return promptRepository.findByNameAndVersion(name, version)
            .map(this::mapToResponse)
            .orElseThrow(() -> new ResourceNotFoundException("Prompt not found with name: " + name + " and version: " + version));
    }

    @Transactional
    public void deletePrompt(UUID id) {
        if (!promptRepository.existsById(id)) {
            throw new ResourceNotFoundException("Prompt not found with id: " + id);
        }
        promptRepository.deleteById(id);
    }

    private PromptResponse mapToResponse(Prompt prompt) {
        return new PromptResponse(
            prompt.getId(),
            prompt.getName(),
            prompt.getVersion(),
            prompt.getContent(),
            prompt.getDescription(),
            prompt.getMetadata(),
            prompt.getCreatedAt(),
            prompt.getUpdatedAt()
        );
    }

    // Custom exception classes can be moved to a separate package later
    public static class ResourceNotFoundException extends RuntimeException {
        public ResourceNotFoundException(String message) {
            super(message);
        }
    }
}
