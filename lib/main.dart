import 'package:flutter/material.dart';
import 'package:notes/domain/repositories/note_repository.dart';
import 'package:notes/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'presentation/theme/theme_view_model.dart';
import 'presentation/viewmodels/note_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeViewModel = ThemeViewModel();
  await themeViewModel.loadTheme();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteViewModel(NoteRepository())..loadNotes()),
        ChangeNotifierProvider(create: (_) => themeViewModel),
      ],
      child: const NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeViewModel.themeMode,
      home: const HomeScreen(),
    );
  }
}
