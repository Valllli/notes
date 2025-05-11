import 'package:flutter/material.dart';
import 'package:notes/domain/repositories/note_repository.dart';

import '../../domain/entities/note.dart';

class NoteViewModel extends ChangeNotifier {
  final NoteRepository _repository;
  List<Note> _notes = [];
  String _query = '';

  NoteViewModel(this._repository);

  List<Note> get notes {
    final filtered = _notes
        .where((note) =>
            note.title.toLowerCase().contains(_query.toLowerCase()) ||
            note.content.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  Future<void> loadNotes() async {
    _notes = await _repository.loadNotes();
    notifyListeners();
  }

  Future<void> addOrUpdateNote(Note note) async {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      _notes[index] = note;
    } else {
      _notes.add(note);
    }
    await _repository.saveNotes(_notes);
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    await _repository.saveNotes(_notes);
    notifyListeners();
  }

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }
}
