import 'dart:io';

import 'package:dart_application_2/dart_application_2.dart';

const _sizes = [100, 200];

void main() {
  final dbPath = '${Directory.current.path}/bench_db.sqlite';
  final file = File(dbPath);
  if (file.existsSync()) file.deleteSync();

  final db = AppDatabase(dbPath);

  try {
    print('=== Нагрузочное тестирование AppDatabase ===');
    print('');

    for (final size in _sizes) {
      print('--- $size записей ---');

      // ─── Вставка пользователей ─────────────────────────────────────
      final insertUsersMs = _bench('Вставка $size пользователей', () {
        for (var i = 0; i < size; i++) {
          db.insertUser(User(
            id: 'u$i',
            username: 'user_$i',
            email: 'user_$i@mail.com',
            avatarUrl: 'https://img.example.com/$i.png',
          ));
        }
      });

      // ─── Чтение всех пользователей ─────────────────────────────────
      final readAllUsersMs = _bench('Чтение всех пользователей', () {
        db.getAllUsers();
      });

      // ─── Чтение по id ──────────────────────────────────────────────
      final readByIdMs = _bench('Чтение $size пользователей по id', () {
        for (var i = 0; i < size; i++) {
          db.getUserById('u$i');
        }
      });

      // ─── Вставка статей ────────────────────────────────────────────
      final insertArticlesMs = _bench('Вставка $size статей', () {
        for (var i = 0; i < size; i++) {
          db.insertArticle(Article(
            id: 'a$i',
            authorId: 'u${i % size}',
            title: 'Статья $i',
            content: 'Содержание статьи номер $i. ' * 10,
            imageUrl: 'https://img.example.com/articles/$i.png',
            createdAt: DateTime.now(),
          ));
        }
      });

      // ─── Чтение статей по автору ───────────────────────────────────
      final readArticlesByAuthorMs = _bench('Чтение статей по автору (1 автор)', () {
        db.getArticlesByAuthor('u0');
      });

      // ─── Вставка подкастов ─────────────────────────────────────────
      final insertPodcastsMs = _bench('Вставка $size подкастов', () {
        for (var i = 0; i < size; i++) {
          db.insertPodcast(Podcast(
            id: 'p$i',
            authorId: 'u${i % size}',
            title: 'Подкаст $i',
            description: 'Описание подкаста номер $i. ' * 5,
            audioUrl: 'https://audio.example.com/p$i.mp3',
            coverUrl: 'https://img.example.com/podcasts/$i.png',
            durationSeconds: 600 + (i % 3600),
            createdAt: DateTime.now(),
          ));
        }
      });

      // ─── Вставка лайков ────────────────────────────────────────────
      final insertLikesMs = _bench('Вставка $size лайков', () {
        for (var i = 0; i < size; i++) {
          final targetType = i.isEven ? LikeTargetType.article : LikeTargetType.podcast;
          db.insertLike(Like(
            id: 'l$i',
            userId: 'u${i % size}',
            targetId: i.isEven ? 'a${i % size}' : 'p${i % size}',
            targetType: targetType,
            createdAt: DateTime.now(),
          ));
        }
      });

      // ─── Чтение лайков по пользователю ─────────────────────────────
      final readLikesByUserMs = _bench('Чтение лайков по пользователю', () {
        db.getLikesByUser('u0');
      });

      // ─── Чтение лайков по цели ─────────────────────────────────────
      final readLikesByTargetMs = _bench('Чтение лайков по цели (статья)', () {
        db.getLikesByTarget('a0', LikeTargetType.article);
      });

      // ─── Удаление лайков ───────────────────────────────────────────
      final deleteLikesMs = _bench('Удаление $size лайков', () {
        for (var i = 0; i < size; i++) {
          db.deleteLike('l$i');
        }
      });

      // ─── Удаление подкастов ────────────────────────────────────────
      final deletePodcastsMs = _bench('Удаление $size подкастов', () {
        for (var i = 0; i < size; i++) {
          db.deletePodcast('p$i');
        }
      });

      // ─── Удаление статей ───────────────────────────────────────────
      final deleteArticlesMs = _bench('Удаление $size статей', () {
        for (var i = 0; i < size; i++) {
          db.deleteArticle('a$i');
        }
      });

      // ─── Удаление пользователей ────────────────────────────────────
      final deleteUsersMs = _bench('Удаление $size пользователей', () {
        for (var i = 0; i < size; i++) {
          db.deleteUser('u$i');
        }
      });

      // ─── Итого ─────────────────────────────────────────────────────
      final totalMs = insertUsersMs +
          readAllUsersMs +
          readByIdMs +
          insertArticlesMs +
          readArticlesByAuthorMs +
          insertPodcastsMs +
          insertLikesMs +
          readLikesByUserMs +
          readLikesByTargetMs +
          deleteLikesMs +
          deletePodcastsMs +
          deleteArticlesMs +
          deleteUsersMs;

      print('  ИТОГО для $size записей: ${_fmt(totalMs)}');
      print('');
    }

    print('=== Тестирование завершено ===');
  } finally {
    db.close();
    final file = File(dbPath);
    if (file.existsSync()) file.deleteSync();
  }
}

int _bench(String label, void Function() action) {
  final sw = Stopwatch()..start();
  action();
  sw.stop();
  print('  $label: ${_fmt(sw.elapsedMilliseconds)}');
  return sw.elapsedMilliseconds;
}

String _fmt(int ms) {
  if (ms < 1000) return '$ms мс';
  return '${(ms / 1000).toStringAsFixed(2)} с';
}
