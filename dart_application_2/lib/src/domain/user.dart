import 'identity.dart';
import 'validation.dart';

class User implements Identity {
  @override
  final String id;
  final String username;
  final String email;
  final String avatarUrl;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
  });

  ValidationErrors validate() {
    final errors = <String>[];
    final idErr = requiredNonEmpty(id, 'id');
    if (idErr != null) errors.add(idErr);
    final usernameErr = requiredNonEmpty(username, 'username');
    if (usernameErr != null) errors.add(usernameErr);
    final emailErr = requiredNonEmpty(email, 'email');
    if (emailErr != null) {
      errors.add(emailErr);
    } else if (!email.contains('@')) {
      errors.add('email: должен содержать @');
    }
    final avatarErr = requiredNonEmpty(avatarUrl, 'avatarUrl');
    if (avatarErr != null) errors.add(avatarErr);
    return errors;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'email': email,
        'avatarUrl': avatarUrl,
      };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      avatarUrl: map['avatarUrl'] as String,
    );
  }

  @override
  String toString() => '$username ($email)';
}
