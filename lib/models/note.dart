import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'db.dart';

part 'note.freezed.dart';
// write and run "flutter pub run build_runner build"
// then create freezed file
@freezed
class Note with _$Note{
  const factory Note({
    required int id,
    required String title
  }) = _Note;

  static Future<void> insert(String title) async {
    final Database db = await DB().database;
    await db.insert(
      'note',
      {"title": title},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Note>> all() async {
    final Database db = await DB().database;
    final List<Map<String, dynamic>> maps = await db.query('note');
      return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
      );
    });
  }

  static Future<void> delete(int id) async {
    final db = await DB().database;
    await db.delete(
      'note',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}