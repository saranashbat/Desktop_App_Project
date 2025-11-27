package qa.udst.perfume_shop.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import qa.udst.perfume_shop.model.Note;

import java.util.Optional;

public interface NoteRepository extends MongoRepository<Note, String> {

    Optional<Note> findByName(String type); // TOP, MIDDLE, BASE
}
