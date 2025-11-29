package qa.udst.perfume_shop.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import qa.udst.perfume_shop.model.Note;
import qa.udst.perfume_shop.repository.NoteRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NoteService {

    private final NoteRepository noteRepository;

    // Get all notes
    public List<Note> getAllNotes() {
        return noteRepository.findAll();
    }

    // Get note by ID
    public Optional<Note> getNoteById(String id) {
        return noteRepository.findById(id);
    }

    // Get note by name
    public Optional<Note> getNoteByName(String name) {
        return noteRepository.findByName(name);
    }

    // Create a new note
    public Note createNote(Note note) {
        return noteRepository.save(note);
    }

    // Delete note
    public void deleteNote(String id) {
        noteRepository.deleteById(id);
    }
}
