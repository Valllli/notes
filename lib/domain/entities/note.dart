class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? audioPath;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.audioPath,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    String? audioPath,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  bool get isAudioNote => audioPath != null;
  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
        audioPath: json['audioPath'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'audioPath': audioPath,
      };
}
