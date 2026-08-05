package dk.vdw.prompter.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.UUID;
import java.util.List;

@Repository
public interface PromptRepository extends JpaRepository<Prompt, UUID> {
    Optional<Prompt> findByNameAndVersion(String name, String version);
    List<Prompt> findAllByNameOrderByVersionDesc(String name);
    Optional<Prompt> findFirstByNameOrderByCreatedAtDesc(String name);
}
