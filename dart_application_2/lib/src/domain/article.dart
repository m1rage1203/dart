import 'identity.dart';
import 'validation.dart';

class Article implements Identity {
  @override
  final String id;
  final String authorId;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime createdAt;

  const Article({
    required this.id,
    required this.authorId,
    required this.title,
    required this.content,
    required this.imageUrl,
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
    final contentErr = requiredNonEmpty(content, 'content');
    if (contentErr != null) errors.add(contentErr);
    final imageErr = requiredNonEmpty(imageUrl, 'imageUrl');
    if (imageErr != null) errors.add(imageErr);
    return errors;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'authorId': authorId,
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] as String,
      authorId: map['authorId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['imageUrl'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() => '$title (by $authorId)';
}
