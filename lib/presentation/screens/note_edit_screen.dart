import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/note.dart';
import '../viewmodels/note_view_model.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;
  const NoteEditScreen({super.key, this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState?.validate() ?? false) {
      final note = Note(
        id: widget.note?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        content: _contentController.text,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
      );

      try {
        await Provider.of<NoteViewModel>(context, listen: false).addOrUpdateNote(note);
        if (context.mounted) Navigator.pop(context);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при сохранении: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NoteViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Редактировать' : 'Новая заметка'),
        actions: widget.note != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Удалить заметку?'),
                        content: const Text('Это действие нельзя отменить.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Удалить'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await viewModel.deleteNote(widget.note!.id);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                )
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Заголовок'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Заголовок не может быть пустым';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Текст'),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
