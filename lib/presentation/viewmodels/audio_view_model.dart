import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class AudioNoteViewModel extends ChangeNotifier {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  String? _audioPath;
  String? get audioPath => _audioPath;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Duration _recordDuration = Duration.zero;
  Duration get recordDuration => _recordDuration;

  Timer? _timer;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  AudioNoteViewModel({String? initialPath}) {
    _audioPath = initialPath;
    _playerStateSubscription = _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });
  }

  Future<void> startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return;

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/${const Uuid().v4()}.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );

    _audioPath = path;
    _isRecording = true;
    _recordDuration = Duration.zero;
    _startTimer();
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
    _stopTimer();
    _isRecording = false;
    notifyListeners();
  }

  Future<void> playPause() async {
    if (_audioPath == null) return;

    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(DeviceFileSource(_audioPath!));
    }
  }

  void deleteRecording() {
    stopRecording(); // на всякий случай
    if (_audioPath != null) {
      final file = File(_audioPath!);
      if (file.existsSync()) file.deleteSync();
    }
    _audioPath = null;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordDuration += const Duration(seconds: 1);
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _player.dispose();
    _stopTimer();
    super.dispose();
  }
}
