import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class DatabaseHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "task";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    {
      try {
        String path = '${await getDatabasesPath()}task.db';
        _db = await openDatabase(path, version: _version,
            onCreate: ((db, version) {
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING,"
            "colors INTEGER, "
            "isComplete INTEGER)",
          );
        }));
      } catch (e) {
        throw ();
      }
    }
  }

  static Future<int> insertDatabase(Note note) async {
    return await _db?.insert(_tableName, note.toJson()) ?? 1;
  }

  static Future<List<Note>> queryDatabase() async {
    if (_db != null) {
      final result = await _db!.query(_tableName);
      final List<Note> note = [];
      note.addAll(result.map((e) => Note.fromJson(e)));
      // note.sort(
      //   (a, b) => a.dateTime!.compareTo(b.dateTime!),
      // );
      return note;
    } else {
      return [];
    }
  }

  static Future<void> deleteNoteById(int id) async {
    try {
      await _db?.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw ();
    }
  }

  static Future<void> updateNoteById(int id, int isComplete) async {
    try {
      await _db?.update(_tableName, {'isComplete': isComplete},
          where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw ();
    }
  }

  // static Future<void> dropTable() async {
  //   _db!.execute('DROP TABLE IF EXISTS $_tableName');
  // }

  static Future<void> deleteDatabse() async {
    deleteDatabase('${await getDatabasesPath()}task.db');
  }
}
