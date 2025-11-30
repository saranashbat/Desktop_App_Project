import 'note.dart';
import 'note_type.dart';

class PerfumeNote {
  String? type;
  Note? note;

  PerfumeNote({this.type, this.note});

  factory PerfumeNote.fromJson(Map<String, dynamic> json) {
    return PerfumeNote(
      type: json['type'],          // can be null
      note: json['note'] != null
          ? Note.fromJson(json['note'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'note': note?.toJson(),
      };
}

class Note {
  String? name;
  String? photo;

  Note({this.name, this.photo});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      name: json['name'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'photo': photo,
      };
}

