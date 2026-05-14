import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../domain/article.dart';
import '../domain/like.dart';
import '../domain/podcast.dart';
import '../domain/user.dart';

class AppDatabase {
  final Database _sqlite;

  AppDatabase(String filePath) : _sqlite = sqlite3.open(filePath) {
    _createTables();
  }

  factory AppDatabase.inApp() {
    final filePath = p.join(Directory.current.path, 'app.db');
    return AppDatabase(filePath);
  }

  void _createTables() {
    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        avatarUrl TEXT NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS articles (
        id TEXT PRIMARY KEY,
        authorId TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (authorId) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS podcasts (
        id TEXT PRIMARY KEY,
        authorId TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        audioUrl TEXT NOT NULL,
        coverUrl TEXT NOT NULL,
        durationSeconds INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (authorId) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS likes (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        targetId TEXT NOT NULL,
        targetType TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');
  }


  void insertUser(User user) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO users(id,username,email,avatarUrl) VALUES(?,?,?,?)',
      [user.id, user.username, user.email, user.avatarUrl],
    );
  }

  List<User> getAllUsers() {
    final rows = _sqlite.select('SELECT id,username,email,avatarUrl FROM users');
    return rows.map((row) => User.fromMap(row)).toList();
  }

  User? getUserById(String id) {
    final rows = _sqlite.select(
      'SELECT id,username,email,avatarUrl FROM users WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? User.fromMap(rows.first) : null;
  }

  void deleteUser(String id) {
    _sqlite.execute('DELETE FROM users WHERE id=?', [id]);
  }


  void insertArticle(Article article) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO articles(id,authorId,title,content,imageUrl,createdAt) VALUES(?,?,?,?,?,?)',
      [
        article.id,
        article.authorId,
        article.title,
        article.content,
        article.imageUrl,
        article.createdAt.toIso8601String(),
      ],
    );
  }

  List<Article> getAllArticles() {
    final rows = _sqlite.select(
      'SELECT id,authorId,title,content,imageUrl,createdAt FROM articles',
    );
    return rows.map((row) => Article.fromMap(row)).toList();
  }

  Article? getArticleById(String id) {
    final rows = _sqlite.select(
      'SELECT id,authorId,title,content,imageUrl,createdAt FROM articles WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Article.fromMap(rows.first) : null;
  }

  List<Article> getArticlesByAuthor(String authorId) {
    final rows = _sqlite.select(
      'SELECT id,authorId,title,content,imageUrl,createdAt FROM articles WHERE authorId=?',
      [authorId],
    );
    return rows.map((row) => Article.fromMap(row)).toList();
  }

  void deleteArticle(String id) {
    _sqlite.execute('DELETE FROM articles WHERE id=?', [id]);
  }


  void insertPodcast(Podcast podcast) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO podcasts(id,authorId,title,description,audioUrl,coverUrl,durationSeconds,createdAt) VALUES(?,?,?,?,?,?,?,?)',
      [
        podcast.id,
        podcast.authorId,
        podcast.title,
        podcast.description,
        podcast.audioUrl,
        podcast.coverUrl,
        podcast.durationSeconds,
        podcast.createdAt.toIso8601String(),
      ],
    );
  }

  List<Podcast> getAllPodcasts() {
    final rows = _sqlite.select(
      'SELECT id,authorId,title,description,audioUrl,coverUrl,durationSeconds,createdAt FROM podcasts',
    );
    return rows.map((row) => Podcast.fromMap(row)).toList();
  }

  Podcast? getPodcastById(String id) {
    final rows = _sqlite.select(
      'SELECT id,authorId,title,description,audioUrl,coverUrl,durationSeconds,createdAt FROM podcasts WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Podcast.fromMap(rows.first) : null;
  }

  List<Podcast> getPodcastsByAuthor(String authorId) {
    final rows = _sqlite.select(
      'SELECT id,authorId,title,description,audioUrl,coverUrl,durationSeconds,createdAt FROM podcasts WHERE authorId=?',
      [authorId],
    );
    return rows.map((row) => Podcast.fromMap(row)).toList();
  }

  void deletePodcast(String id) {
    _sqlite.execute('DELETE FROM podcasts WHERE id=?', [id]);
  }



  void insertLike(Like like) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO likes(id,userId,targetId,targetType,createdAt) VALUES(?,?,?,?,?)',
      [
        like.id,
        like.userId,
        like.targetId,
        like.targetType.name,
        like.createdAt.toIso8601String(),
      ],
    );
  }

  List<Like> getAllLikes() {
    final rows = _sqlite.select(
      'SELECT id,userId,targetId,targetType,createdAt FROM likes',
    );
    return rows.map((row) => Like.fromMap(row)).toList();
  }

  Like? getLikeById(String id) {
    final rows = _sqlite.select(
      'SELECT id,userId,targetId,targetType,createdAt FROM likes WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Like.fromMap(rows.first) : null;
  }

  List<Like> getLikesByUser(String userId) {
    final rows = _sqlite.select(
      'SELECT id,userId,targetId,targetType,createdAt FROM likes WHERE userId=?',
      [userId],
    );
    return rows.map((row) => Like.fromMap(row)).toList();
  }

  List<Like> getLikesByTarget(String targetId, LikeTargetType targetType) {
    final rows = _sqlite.select(
      'SELECT id,userId,targetId,targetType,createdAt FROM likes WHERE targetId=? AND targetType=?',
      [targetId, targetType.name],
    );
    return rows.map((row) => Like.fromMap(row)).toList();
  }

  void deleteLike(String id) {
    _sqlite.execute('DELETE FROM likes WHERE id=?', [id]);
  }


  void close() {
    _sqlite.dispose();
  }
}
