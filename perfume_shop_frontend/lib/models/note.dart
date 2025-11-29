// note.dart
class Note {
  String name;
  String? photo;

  Note({required this.name, this.photo});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      name: json['name'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photo': photo,
    };
  }
}