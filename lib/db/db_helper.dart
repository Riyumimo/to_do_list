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
          print('Create new Databse ');
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
        print(e);
      }
    }
  }

  static Future<int> insertDatabase(Note note) async {
    print('Insert Funcion called');
    return await _db?.insert(_tableName, note.toJson()) ?? 1;
  }

  static Future<List<Note>> queryDatabase() async {
    print('Query Funcion called');
    print(_db);
    if (_db != null) {
      final result = await _db!.query(_tableName);
      final List<Note> note = [];
      note.addAll(result.map((e) => Note.fromJson(e)));
      // note.sort(
      //   (a, b) => a.dateTime!.compareTo(b.dateTime!),
      // );
      return note;
    } else {
      print('error');
      return [];
    }
  }

  static Future<void> deleteNoteById(int id) async {
    try {
      await _db?.delete(_tableName, where: 'id = ?', whereArgs: [id]);
      print('Delet has Successfully');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateNoteById(int id, int isComplete) async {
    try {
      await _db?.update(_tableName, {'isComplete': isComplete},
          where: 'id = ?', whereArgs: [id]);
      print("Update Succsefully");
    } catch (e) {
      print(e);
    }
  }

  // static Future<void> dropTable() async {
  //   _db!.execute('DROP TABLE IF EXISTS $_tableName');
  // }

  static Future<void> deleteDatabse() async {
    deleteDatabase('${await getDatabasesPath()}task.db');
    print('database has been delete');
  }
}
