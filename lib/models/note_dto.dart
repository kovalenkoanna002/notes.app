import 'note.dart';

class NoteDto {
  int id;
  String title;
  String content;
  String modifiedTime;

  NoteDto({required this.id, required this.title, required this.content, required this.modifiedTime});

  factory NoteDto.fromJson(Map<String, dynamic> json) {
    return NoteDto(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      modifiedTime: json['modifiedTime'],
    );
  }

  static List<Note> toNoteList(List<NoteDto>? noteDtos) {
    return noteDtos!.map((dto) => toNote(dto)
    ).toList();
  }

  static Note toNote(NoteDto dto) {
    return  Note(
      id: dto.id,
      title: dto.title,
      content: dto.content,
      modifiedTime: DateTime.parse(dto.modifiedTime),
    );
  }
}