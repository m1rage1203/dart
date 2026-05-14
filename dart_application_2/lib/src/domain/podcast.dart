import 'identity.dart';
import 'validation.dart';

class Podcast implements Identity {
  @override
  final String id;
  final String authorId;
  final String title;
  final String description;
  final String audioUrl;
  final String coverUrl;
  final int durationSeconds;
  final DateTime createdAt;

  const Podcast({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.coverUrl,
    required this.durationSeconds,
    required this.createdAt,
  });

  
  ValidationErrors validate() {
    final errors = <String>[];
    final idErr = requiredNonEmpty(id, 'id');
    if (idErr != null) errors.add(idErr);
    final authorErr = requiredNonEmpty(authorId, 'authorId');
    if (authorErr != null) errors.add(authorErr);
    final titleErr = requiredNonEmpty(title, 'title');
    if (titleErr != null) errors.add(titleErr);
    final descErr = requiredNonEmpty(description, 'description');
    if (descErr != null) errors.add(descErr);
    final audioErr = requiredNonEmpty(audioUrl, 'audioUrl');
    if (audioErr != null) errors.add(audioErr);
    final coverErr = requiredNonEmpty(coverUrl, 'coverUrl');
    if (coverErr != null) errors.add(coverErr);
    final durErr = positiveInt(durationSeconds, 'durationSeconds');
    if (durErr != null) errors.add(durErr);
    return errors;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'authorId': authorId,
        'title': title,
        'description': description,
        'audioUrl': audioUrl,
        'coverUrl': coverUrl,
        'durationSeconds': durationSeconds,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Podcast.fromMap(Map<String, dynamic> map) {
    return Podcast(
      id: map['id'] as String,
      authorId: map['authorId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      audioUrl: map['audioUrl'] as String,
      coverUrl: map['coverUrl'] as String,
      durationSeconds: _asInt(map['durationSeconds']),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('Ожидали целое число', value);
  }

  @override
  String toString() => '$title (${durationSeconds}с)';
}
