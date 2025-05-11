import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/note.dart';

class NoteRepository {
  static const String _notesKey = 'notes';

  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_notesKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Note.fromJson(json)).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notes.map((note) => note.toJson()).toList();
    final success = await prefs.setString('notes', json.encode(jsonList));
    if (!success) {
      throw Exception('Не удалось сохранить заметки');
    }
  }
}
