import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart';

class Journal {
  final int id;
  final String title;
  final String content;
  final DateTime date;

  Journal({required this.id, required this.title, required this.content, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Journal{id: $id, title: $title, content: $content, date: $date}';
  }
}

final journalRepositoryProvider = Provider<JournalRepository>((ref) => JournalRepository());

class JournalRepository {
  late Database _database;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/journals.db';
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE journals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Journal>> getAllJournals() async {
    final List<Map<String, dynamic>> maps = await _database.query('journals', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      return Journal(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  Future<void> addJournal(Journal journal) async {
    await _database.insert(
      'journals',
      journal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateJournal(Journal journal) async {
    await _database.update(
      'journals',
      journal.toMap(),
      where: "id = ?",
      whereArgs: [journal.id],
    );
  }

  Future<void> deleteJournal(int id) async {
    await _database.delete(
      'journals',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
