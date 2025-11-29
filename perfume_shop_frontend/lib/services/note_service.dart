import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/global_parameters.dart';
import '../models/note.dart';

class NoteService {
  // -------------------------------
  // GET ALL NOTES
  // -------------------------------
  Future<List<Note>> getAllNotes() async {
    final response = await http.get(Uri.parse(GlobalParameters.notesEndpoint));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Note.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  // -------------------------------
  // GET NOTE BY ID
  // -------------------------------
  Future<Note?> getNoteById(String id) async {
    final response = await http.get(Uri.parse('${GlobalParameters.notesEndpoint}/$id'));

    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load note by id');
    }
  }

  // -------------------------------
  // GET NOTE BY NAME
  // -------------------------------
  Future<Note?> getNoteByName(String name) async {
    final response = await http.get(
      Uri.parse('${GlobalParameters.notesEndpoint}/search?name=$name'),
    );

    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load note by name');
    }
  }

  // -------------------------------
  // CREATE NOTE
  // -------------------------------
  Future<Note> createNote(Note note) async {
    final response = await http.post(
      Uri.parse(GlobalParameters.notesEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create note');
    }
  }

  // -------------------------------
  // DELETE NOTE
  // -------------------------------
  Future<void> deleteNote(String id) async {
    final response = await http.delete(Uri.parse('${GlobalParameters.notesEndpoint}/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete note');
    }
  }
}
