import 'dart:io';

import '../data/app_database.dart';
import '../domain/article.dart';
import '../domain/like.dart';
import '../domain/podcast.dart';
import '../domain/user.dart';

void runMenu(AppDatabase db) {
  while (true) {
    stdout.writeln('''
--- Контент-платформа ---
1  - список пользователей
2  - добавить пользователя
3  - удалить пользователя по id
4  - список статей
5  - добавить статью
6  - удалить статью по id
7  - список подкастов
8  - добавить подкаст
9  - удалить подкаст по id
10 - список лайков
11 - поставить лайк
12 - удалить лайк по id
13 - лайки пользователя
14 - лайки статьи
15 - лайки подкаста
16 - показать всё из базы
0  - выход
Выберите пункт:''');

    final choice = stdin.readLineSync()?.trim() ?? '';
    switch (choice) {
      case '1':
        _printUsers(db);
        break;
      case '2':
        _addUser(db);
        break;
      case '3':
        _deleteUser(db);
        break;
      case '4':
        _printArticles(db);
        break;
      case '5':
        _addArticle(db);
        break;
      case '6':
        _deleteArticle(db);
        break;
      case '7':
        _printPodcasts(db);
        break;
      case '8':
        _addPodcast(db);
        break;
      case '9':
        _deletePodcast(db);
        break;
      case '10':
        _printLikes(db);
        break;
      case '11':
        _addLike(db);
        break;
      case '12':
        _deleteLike(db);
        break;
      case '13':
        _printLikesByUser(db);
        break;
      case '14':
        _printLikesByArticle(db);
        break;
      case '15':
        _printLikesByPodcast(db);
        break;
      case '16':
        _printAllFromDb(db);
        break;
      case '0':
        stdout.writeln('До свидания.');
        return;
      default:
        stdout.writeln('Неизвестная команда.');
    }
    stdout.writeln();
  }
}



void _printUsers(AppDatabase db) {
  final list = db.getAllUsers();
  if (list.isEmpty) {
    stdout.writeln('Пользователей нет.');
    return;
  }
  for (final u in list) {
    stdout.writeln('id: ${u.id} | ${u.username} | ${u.email} | ${u.avatarUrl}');
  }
}

void _printArticles(AppDatabase db) {
  final list = db.getAllArticles();
  if (list.isEmpty) {
    stdout.writeln('Статей нет.');
    return;
  }
  for (final a in list) {
    stdout.writeln('id: ${a.id} | автор: ${a.authorId} | ${a.title} | ${a.createdAt.toLocal()}');
  }
}

void _printPodcasts(AppDatabase db) {
  final list = db.getAllPodcasts();
  if (list.isEmpty) {
    stdout.writeln('Подкастов нет.');
    return;
  }
  for (final p in list) {
    stdout.writeln('id: ${p.id} | автор: ${p.authorId} | ${p.title} | ${p.durationSeconds}с | ${p.createdAt.toLocal()}');
  }
}

void _printLikes(AppDatabase db) {
  final list = db.getAllLikes();
  if (list.isEmpty) {
    stdout.writeln('Лайков нет.');
    return;
  }
  for (final l in list) {
    stdout.writeln('id: ${l.id} | юзер: ${l.userId} | цель: ${l.targetType.name}:${l.targetId} | ${l.createdAt.toLocal()}');
  }
}

void _printAllFromDb(AppDatabase db) {
  stdout.writeln('=== Пользователи ===');
  _printUsers(db);
  stdout.writeln('=== Статьи ===');
  _printArticles(db);
  stdout.writeln('=== Подкасты ===');
  _printPodcasts(db);
  stdout.writeln('=== Лайки ===');
  _printLikes(db);
}



void _addUser(AppDatabase db) {
  final id = _read('id пользователя: ');
  final username = _read('username: ');
  final email = _read('email: ');
  final avatarUrl = _read('URL аватара: ');

  db.insertUser(User(id: id, username: username, email: email, avatarUrl: avatarUrl));
  stdout.writeln('Пользователь сохранён.');
}

void _addArticle(AppDatabase db) {
  stdout.writeln('Доступные авторы:');
  _printUsers(db);

  final id = _read('id статьи: ');
  final authorId = _read('id автора: ');
  final title = _read('заголовок: ');
  final content = _read('содержание: ');
  final imageUrl = _read('URL картинки: ');
  final createdAt = DateTime.now().toUtc();

  db.insertArticle(Article(
    id: id,
    authorId: authorId,
    title: title,
    content: content,
    imageUrl: imageUrl,
    createdAt: createdAt,
  ));
  stdout.writeln('Статья сохранена.');
}

void _addPodcast(AppDatabase db) {
  stdout.writeln('Доступные авторы:');
  _printUsers(db);

  final id = _read('id подкаста: ');
  final authorId = _read('id автора: ');
  final title = _read('название: ');
  final description = _read('описание: ');
  final audioUrl = _read('URL аудио: ');
  final coverUrl = _read('URL обложки: ');
  final durationSeconds = int.parse(_read('длительность в секундах: '));
  final createdAt = DateTime.now().toUtc();

  db.insertPodcast(Podcast(
    id: id,
    authorId: authorId,
    title: title,
    description: description,
    audioUrl: audioUrl,
    coverUrl: coverUrl,
    durationSeconds: durationSeconds,
    createdAt: createdAt,
  ));
  stdout.writeln('Подкаст сохранён.');
}

void _addLike(AppDatabase db) {
  stdout.writeln('Доступные пользователи:');
  _printUsers(db);
  stdout.writeln('Доступные статьи:');
  _printArticles(db);
  stdout.writeln('Доступные подкасты:');
  _printPodcasts(db);

  final id = _read('id лайка: ');
  final userId = _read('id пользователя: ');
  final targetType = _read('тип цели (article/podcast): ');
  final targetId = _read('id цели: ');
  final createdAt = DateTime.now().toUtc();

  final likeType = targetType == 'podcast'
      ? LikeTargetType.podcast
      : LikeTargetType.article;

  db.insertLike(Like(
    id: id,
    userId: userId,
    targetId: targetId,
    targetType: likeType,
    createdAt: createdAt,
  ));
  stdout.writeln('Лайк сохранён.');
}


void _deleteUser(AppDatabase db) {
  final id = _read('id пользователя для удаления: ');
  db.deleteUser(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _deleteArticle(AppDatabase db) {
  final id = _read('id статьи для удаления: ');
  db.deleteArticle(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _deletePodcast(AppDatabase db) {
  final id = _read('id подкаста для удаления: ');
  db.deletePodcast(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _deleteLike(AppDatabase db) {
  final id = _read('id лайка для удаления: ');
  db.deleteLike(id);
  stdout.writeln('Готово (если id был в базе).');
}


void _printLikesByUser(AppDatabase db) {
  final userId = _read('id пользователя: ');
  final list = db.getLikesByUser(userId);
  if (list.isEmpty) {
    stdout.writeln('Лайков нет.');
    return;
  }
  for (final l in list) {
    stdout.writeln('id: ${l.id} | ${l.targetType.name}:${l.targetId} | ${l.createdAt.toLocal()}');
  }
}

void _printLikesByArticle(AppDatabase db) {
  final articleId = _read('id статьи: ');
  final list = db.getLikesByTarget(articleId, LikeTargetType.article);
  if (list.isEmpty) {
    stdout.writeln('Лайков нет.');
    return;
  }
  for (final l in list) {
    stdout.writeln('id: ${l.id} | юзер: ${l.userId} | ${l.createdAt.toLocal()}');
  }
}

void _printLikesByPodcast(AppDatabase db) {
  final podcastId = _read('id подкаста: ');
  final list = db.getLikesByTarget(podcastId, LikeTargetType.podcast);
  if (list.isEmpty) {
    stdout.writeln('Лайков нет.');
    return;
  }
  for (final l in list) {
    stdout.writeln('id: ${l.id} | юзер: ${l.userId} | ${l.createdAt.toLocal()}');
  }
}



String _read(String label) {
  stdout.write(label);
  return stdin.readLineSync()?.trim() ?? '';
}
