import 'note.dart';
import 'note_type.dart';

class PerfumeNote {
  Note note;
  NoteType type;

  PerfumeNote({
    required this.note,
    required this.type,
  });

  factory PerfumeNote.fromJson(Map<String, dynamic> json) {
    return PerfumeNote(
      note: Note.fromJson(json['note']),
      type: noteTypeFromString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note': note.toJson(),
      'type': noteTypeToString(type),
    };
  }
}
