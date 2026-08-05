package dk.vdw.prompter.presentation.rest;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import tools.jackson.databind.ObjectMapper;
import dk.vdw.prompter.domain.Prompt;
import dk.vdw.prompter.domain.PromptRepository;
import dk.vdw.prompter.presentation.rest.dto.PromptRequest;
import java.util.Map;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
@ActiveProfiles("test")
class PromptControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private PromptRepository promptRepository;

    @Autowired
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        promptRepository.deleteAll();
    }

    @Test
    void shouldCreatePrompt() throws Exception {
        PromptRequest request = new PromptRequest(
            "api-prompt",
            "1.0.0",
            "API Content",
            "API Description",
            Map.of("model", "gpt-4")
        );

        mockMvc.perform(post("/api/prompts")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.name").value("api-prompt"))
            .andExpect(jsonPath("$.version").value("1.0.0"))
            .andExpect(jsonPath("$.metadata.model").value("gpt-4"));
    }

    @Test
    void shouldReturnConflictForDuplicateVersion() throws Exception {
        Prompt existing = new Prompt("dup-prompt", "1.0.0", "Content", null, null);
        promptRepository.save(existing);

        PromptRequest request = new PromptRequest("dup-prompt", "1.0.0", "New Content", null, null);

        mockMvc.perform(post("/api/prompts")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.error").value("Conflict"));
    }

    @Test
    void shouldGetPromptByNameAndVersion() throws Exception {
        Prompt prompt = new Prompt("fetch-me", "1.2.3", "Some Content", null, null);
        promptRepository.save(prompt);

        mockMvc.perform(get("/api/prompts/name/fetch-me/version/1.2.3"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.name").value("fetch-me"))
            .andExpect(jsonPath("$.version").value("1.2.3"));
    }

    @Test
    void shouldReturnNotFoundForMissingPrompt() throws Exception {
        mockMvc.perform(get("/api/prompts/name/missing/version/1.0.0"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.error").value("Not Found"));
    }
}
