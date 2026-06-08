import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logging/logging.dart';

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

final journalRepositoryProvider = Provider<JournalRepository>((ref) => JournalRepository.instance);

class JournalRepository {
  static final _singleton = JournalRepository._internal();
  factory JournalRepository() => _singleton;
  JournalRepository._internal();

  late Database _database;
  final Logger _logger = Logger('JournalRepository');

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
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          // Example: Add a new column
          db.execute('ALTER TABLE journals ADD COLUMN new_column TEXT');
        }
      },
    );
  }

  Future<List<Journal>> getAllJournals() async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query('journals', orderBy: 'date DESC');
      return List.generate(maps.length, (i) {
        return Journal(
          id: maps[i]['id'],
          title: maps[i]['title'],
          content: maps[i]['content'],
          date: DateTime.parse(maps[i]['date']),
        );
      });
    } catch (e) {
      _logger.severe('Failed to get all journals: $e');
      rethrow;
    }
  }

  Future<void> addJournal(Journal journal) async {
    try {
      await _database.insert(
        'journals',
        journal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.severe('Failed to add journal: $e');
      rethrow;
    }
  }

  Future<void> updateJournal(Journal journal) async {
    try {
      await _database.update(
        'journals',
        journal.toMap(),
        where: "id = ?",
        whereArgs: [journal.id],
      );
    } catch (e) {
      _logger.severe('Failed to update journal: $e');
      rethrow;
    }
  }

  Future<void> deleteJournal(int id) async {
    try {
      await _database.delete(
        'journals',
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      _logger.severe('Failed to delete journal: $e');
      rethrow;
    }
  }
}
