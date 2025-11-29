package qa.udst.perfume_shop.controller;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import qa.udst.perfume_shop.model.Note;
import qa.udst.perfume_shop.service.NoteService;

import java.util.List;

@RestController
@RequestMapping("/api/notes")
@RequiredArgsConstructor
public class NoteController {

    private final NoteService noteService;

    // GET all notes
    @Operation(summary = "Get all perfume notes")
    @GetMapping
    public ResponseEntity<List<Note>> getAllNotes() {
        return ResponseEntity.ok(noteService.getAllNotes());
    }

    // GET note by ID
    @Operation(summary = "Get a note by its ID")
    @GetMapping("/{id}")
    public ResponseEntity<Note> getNoteById(@PathVariable String id) {
        return noteService.getNoteById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // GET note by name
    @Operation(summary = "Get a note by its name")
    @GetMapping("/search")
    public ResponseEntity<Note> getNoteByName(@RequestParam String name) {
        return noteService.getNoteByName(name)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // CREATE note
    @Operation(summary = "Create a new note")
    @PostMapping
    public ResponseEntity<Note> createNote(@RequestBody Note note) {
        Note saved = noteService.createNote(note);
        return ResponseEntity.status(201).body(saved);
    }

    // DELETE note
    @Operation(summary = "Delete a note")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNote(@PathVariable String id) {
        noteService.deleteNote(id);
        return ResponseEntity.noContent().build();
    }
}
