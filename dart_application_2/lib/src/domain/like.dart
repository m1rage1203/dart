import 'identity.dart';
import 'validation.dart';

enum LikeTargetType { article, podcast }

class Like implements Identity {
  @override
  final String id;
  final String userId;
  final String targetId;
  final LikeTargetType targetType;
  final DateTime createdAt;

  const Like({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.targetType,
    required this.createdAt,
  });

  
  ValidationErrors validate() {
    final errors = <String>[];
    final idErr = requiredNonEmpty(id, 'id');
    if (idErr != null) errors.add(idErr);
    final userErr = requiredNonEmpty(userId, 'userId');
    if (userErr != null) errors.add(userErr);
    final targetErr = requiredNonEmpty(targetId, 'targetId');
    if (targetErr != null) errors.add(targetErr);
    return errors;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'targetId': targetId,
        'targetType': targetType.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id'] as String,
      userId: map['userId'] as String,
      targetId: map['targetId'] as String,
      targetType: LikeTargetType.values.firstWhere(
        (e) => e.name == map['targetType'],
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() => 'Like($userId -> ${targetType.name}:$targetId)';
}
