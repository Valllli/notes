import 'package:flutter_test/flutter_test.dart';
import 'package:notes/domain/entities/note.dart';

void main() {
  test('Note toJson and fromJson', () {
    final note = Note(
      id: '1',
      title: 'Test',
      content: 'Content',
      createdAt: DateTime.now(),
    );
    final json = note.toJson();
    final copy = Note.fromJson(json);
    expect(copy.id, note.id);
    expect(copy.title, note.title);
    expect(copy.content, note.content);
    expect(copy.createdAt.toIso8601String(), note.createdAt.toIso8601String());
  });
}
