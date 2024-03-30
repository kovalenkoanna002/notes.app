import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/note.dart';
import '../models/note_dto.dart';
import '../models/note_upsert_dto.dart';
import '../models/user_upsert_dto.dart';
import '../services/api_service.dart';


class NotesProvider with ChangeNotifier {
  bool isLoading = true;
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  bool sorted = false;
  UserUpsertDto? user;

  NotesProvider() {
    if(user != null){
      fetchNotes();
      notifyListeners();
    }
  }

  void sortNotesByModifiedTime() {
    if (sorted) {
      filteredNotes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      filteredNotes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;
    notifyListeners();
  }

  void filterNotes(String searchText) {
    if (searchText.isEmpty) {
      filteredNotes = List.from(notes);
    } else {
      filteredNotes = notes
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    sortNotesByModifiedTime();
  }

  Future<void> addNote(NoteUpsertDto noteUpsertDto) async {
    final result = await ApiService.addNote(noteUpsertDto, user!);
    if (result.isSuccess) {
      notes.add(NoteDto.toNote(result.content));
      filteredNotes = notes;
      sortNotesByModifiedTime();
      notifyListeners();
    } else {
      Fluttertoast.showToast(
        msg: result.errorMessage!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> updateNote(int id, NoteUpsertDto noteUpsertDto) async {
    final result = await ApiService.updateNote(id, noteUpsertDto, user!);
    if (result.isSuccess) {
      int indexOfNote =
          notes.indexWhere((element) => element.id == id); // Находим индекс заметки по ID
      if (indexOfNote != -1) {
        notes[indexOfNote] = NoteDto.toNote(result.content);
        filteredNotes = notes;
        sortNotesByModifiedTime();
        notifyListeners();
      }
    } else {
      Fluttertoast.showToast(
        msg: result.errorMessage!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<bool> deleteNote(Note note) async {
    final result = await ApiService.deleteNote(note.id, user!);
    if (result.isSuccess) {
      notes.remove(note);
      filteredNotes = notes;
      sortNotesByModifiedTime();
      notifyListeners();
    } else {
      Fluttertoast.showToast(
        msg: result.errorMessage!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    return result.isSuccess;
  }

  Future<bool> fetchNotes() async {
    isLoading = true;
    notifyListeners();

    final result = await ApiService.fetchNotes(user!);
    if (result.isSuccess) {
      notes = NoteDto.toNoteList(result.content);
      isLoading = false;
      filteredNotes = notes;
      sortNotesByModifiedTime();
      notifyListeners();
    } else {
      Fluttertoast.showToast(
        msg: result.errorMessage!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      isLoading = false;
      notifyListeners();
    }
    return result.isSuccess;
  }
  
  Future<bool> addUser(UserUpsertDto userUpsertDto) async {
    final result = await ApiService.addUser(userUpsertDto);
    if (result.isSuccess) {
      user = userUpsertDto;
      await fetchNotes();
      notifyListeners();
    } else {
        Fluttertoast.showToast(
          msg: result.errorMessage!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
    }
    return result.isSuccess;
  }

  Future<bool> loginUser(UserUpsertDto userUpsertDto) async {
    final result = await ApiService.getUser(userUpsertDto);

    if(result.isSuccess){
      user = userUpsertDto;
      await fetchNotes();
      notifyListeners();
    } else {
      Fluttertoast.showToast(
        msg: result.errorMessage!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    return result.isSuccess;
  }
}
