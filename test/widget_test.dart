import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/domain/repositories/note_repository.dart';
import 'package:notes/presentation/screens/note_list_screen.dart';
import 'package:notes/presentation/viewmodels/note_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Notes screen loads correctly', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => NoteViewModel(NoteRepository()),
        child: const MaterialApp(home: NoteListScreen()),
      ),
    );

    expect(find.text('Заметки'), findsOneWidget);
  });
}
