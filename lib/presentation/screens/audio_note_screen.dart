import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/presentation/viewmodels/audio_view_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/note.dart';
import '../viewmodels/note_view_model.dart';

class AudioNoteScreen extends StatelessWidget {
  final Note? note;
  const AudioNoteScreen({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AudioNoteViewModel(initialPath: note?.audioPath),
      child: _AudioNoteScreenBody(note: note),
    );
  }
}

class _AudioNoteScreenBody extends StatefulWidget {
  final Note? note;
  const _AudioNoteScreenBody({required this.note});

  @override
  State<_AudioNoteScreenBody> createState() => _AudioNoteScreenBodyState();
}

class _AudioNoteScreenBodyState extends State<_AudioNoteScreenBody> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _saveNote(BuildContext context) {
    final vm = context.read<AudioNoteViewModel>();
    final title = _titleController.text.trim();

    if ((_formKey.currentState?.validate() ?? false) && vm.audioPath != null) {
      final note = Note(
        id: widget.note?.id ?? const Uuid().v4(),
        title: title,
        content: '',
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        audioPath: vm.audioPath,
      );
      context.read<NoteViewModel>().addOrUpdateNote(note);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, добавьте запись')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AudioNoteViewModel>();
    final isAudioAvailable = vm.audioPath != null && File(vm.audioPath!).existsSync();
    final noteVM = context.read<NoteViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Аудиозаметка'),
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
                      await noteVM.deleteNote(widget.note!.id);
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
                validator: (value) => value == null || value.trim().isEmpty ? 'Заголовок обязателен' : null,
              ),
              const SizedBox(height: 24),
              if (vm.isRecording)
                Column(
                  children: [
                    const Text('Идёт запись...', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      _formatDuration(vm.recordDuration),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Icon(Icons.fiber_manual_record, color: Colors.red, size: 36),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: vm.stopRecording,
                      icon: const Icon(Icons.stop),
                      label: const Text('Остановить запись'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              else if (isAudioAvailable)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(vm.isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: vm.playPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: vm.deleteRecording,
                    ),
                    const SizedBox(width: 8),
                    const Text('Запись готова'),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: () async {
                    await vm.startRecording();
                    if (!vm.isRecording) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Микрофон недоступен. Разрешите доступ в настройках.'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.mic),
                  label: const Text('Начать запись'),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveNote(context),
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
