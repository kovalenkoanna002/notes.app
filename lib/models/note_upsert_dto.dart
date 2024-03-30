class NoteUpsertDto {
  String title;
  String content;

  NoteUpsertDto({required this.title, required this.content});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}