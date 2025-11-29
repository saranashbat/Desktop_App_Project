enum NoteType {
  TOP,
  MIDDLE,
  BASE,
}

NoteType noteTypeFromString(String type) {
  switch (type) {
    case 'TOP':
      return NoteType.TOP;
    case 'MIDDLE':
      return NoteType.MIDDLE;
    case 'BASE':
      return NoteType.BASE;
    default:
      throw Exception('Unknown NoteType: $type');
  }
}

String noteTypeToString(NoteType type) {
  return type.toString().split('.').last;
}
