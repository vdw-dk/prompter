package dk.vdw.prompter.domain;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.Map;
import java.util.Optional;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class PromptRepositoryTest {

    @Autowired
    private PromptRepository promptRepository;

    @Test
    void shouldSaveAndFindPrompt() {
        // Given
        Prompt prompt = new Prompt(
            "test-prompt",
            "1.0.0",
            "Hello ${name}",
            "Test description",
            Map.of("model", "gpt-4", "temperature", 0.7)
        );

        // When
        Prompt saved = promptRepository.save(prompt);

        // Then
        assertThat(saved.getId()).isNotNull();
        Optional<Prompt> found = promptRepository.findById(saved.getId());
        assertThat(found).isPresent();
        assertThat(found.get().getName()).isEqualTo("test-prompt");
        assertThat(found.get().getMetadata()).containsEntry("model", "gpt-4");
    }

    @Test
    void shouldEnforceUniqueNameAndVersion() {
        // Given
        Prompt prompt1 = new Prompt("unique-prompt", "1.0.0", "Content 1", null, null);
        promptRepository.saveAndFlush(prompt1);

        // When & Then
        Prompt prompt2 = new Prompt("unique-prompt", "1.0.0", "Content 2", null, null);
        assertThatThrownBy(() -> promptRepository.saveAndFlush(prompt2))
            .isInstanceOf(DataIntegrityViolationException.class);
    }
}
