import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notes/presentation/screens/audio_note_screen.dart';
import 'package:provider/provider.dart';

import '../viewmodels/note_view_model.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NoteViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Поиск...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: viewModel.setQuery,
            ),
          ),
        ),
      ),
      body: viewModel.notes.isEmpty
          ? const Center(child: Text('Нет заметок'))
          : ListView.builder(
              itemCount: viewModel.notes.length,
              itemBuilder: (context, index) {
                final note = viewModel.notes[index];
                return Dismissible(
                  key: Key(note.id),
                  background: Container(color: Colors.red),
                  onDismissed: (_) => viewModel.deleteNote(note.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: note.isAudioNote
                            ? const Icon(Icons.mic, color: Colors.deepOrange)
                            : const Icon(Icons.note, color: Colors.blue),
                        title: Text(
                          note.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          note.content.isNotEmpty ? note.content : 'Аудиозаметка',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontStyle: note.isAudioNote ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                        trailing: Text(
                          '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  note.isAudioNote ? AudioNoteScreen(note: note) : NoteEditScreen(note: note),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        backgroundColor: Theme.of(context).colorScheme.primary,
        overlayOpacity: 0.4,
        spacing: 10,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.text_fields),
            label: 'Текстовая заметка',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NoteEditScreen()),
            ),
          ),
          SpeedDialChild(
            child: const Icon(Icons.mic),
            label: 'Аудиозаметка',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AudioNoteScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
