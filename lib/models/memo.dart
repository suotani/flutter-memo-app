import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Memo {
  final int id;
  final String text;

  Memo({required this.id, required this.text});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }

  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'memo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE memo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, text TEXT)"
        );
      },
      version: 2,
    );
    return _database;
  }

  static Future<void> insertMemo(String text) async {
    final Database db = await database;
    await db.insert(
      'memo',
      {"text": text},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Memo>> getMemos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memo');
    return List.generate(maps.length, (i) {
      return Memo(
        id: maps[i]['id'],
        text: maps[i]['text'],
      );
    });
  }

  static Future updateMemo(int id, String text) async {
    final Database db = await database;
    var values = <String, dynamic>{
      "text": text,
    };
    await db.update("memo", values, where: "id=?", whereArgs: [id]);
  }

  static Future<void> deleteMemo(int id) async {
    final db = await database;
    await db.delete(
      'memo',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> getCount() async {
    final Database db = await database;
    var result = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT (*) FROM memo")
    );
    result ??= 0;
    return result;
  }
}