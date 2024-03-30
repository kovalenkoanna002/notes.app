import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note_dto.dart';
import '../models/note_upsert_dto.dart';
import '../models/result.dart';
import '../models/result_list.dart';
import '../models/user_dto.dart';
import '../models/user_upsert_dto.dart';

class ApiService {
  static const String _baseUrl = "http://localhost:8080/api/secure/Notes";
  static const String _baseUserUrl = "http://localhost:8080/api/Users";

  static Future<ResultList<NoteDto>> fetchNotes(UserUpsertDto user) async {
    final response = await http.get(
      Uri.parse(_baseUrl), 
      headers: <String, String> {
        'Authorization': 'Basic ${user.toBase64()}',
        'Content-Type': 'application/json',
      }
    );
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return ResultList.fromJson(jsonMap, (json) => NoteDto.fromJson(json));
    } else {
      throw Exception('Failed to fetch notes');
    }
  }

  static Future<Result> addNote(NoteUpsertDto note, UserUpsertDto user) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic ${user.toBase64()}'
        },
      body: jsonEncode(note.toJson()),
    );
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return Result.fromJson(jsonMap, (json) => NoteDto.fromJson(json));
    } else {
      throw Exception('Failed to add note');
    }
  }

  static Future<Result> updateNote(int noteId, NoteUpsertDto note, UserUpsertDto user) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$noteId'),
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic ${user.toBase64()}'
        },
      body: jsonEncode(note.toJson()),
    );
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return Result.fromJson(jsonMap, (json) => NoteDto.fromJson(json));
    } else {
      throw Exception('Failed to update note');
    }
  }

  static Future<Result> deleteNote(int noteId, UserUpsertDto user) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$noteId'), 
    headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic ${user.toBase64()}'
        });
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return Result.fromJson(jsonMap, (json) => NoteDto.fromJson(json));
    } else {
      throw Exception('Failed to delete note');
    }
  }

  static Future<Result> addUser(UserUpsertDto user) async {
      final response = await http.post(
        Uri.parse(_baseUserUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        return Result.fromJson(jsonMap, (json) => UserDto.fromJson(json));
      } else {
        throw Exception('Failed to add user');
      }
    }

    static Future<Result> getUser(UserUpsertDto user) async {
      final response = await http.get(
        Uri.parse('$_baseUserUrl/${user.name}/${user.password}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        return Result.fromJson(jsonMap, (json) => UserDto.fromJson(json));
      } else {
        throw Exception('Failed to get user');
      }
    }
}
