import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'db.dart';

part 'item.freezed.dart';
// write and run "flutter pub run build_runner build"
// then create freezed file
@freezed
class Item with _$Item{
  const factory Item({
    required int id,
    required int noteId,
    required String text,
    required bool completed
  }) = _Item;

  static Future<void> insert(int id, String title) async {
    final Database db = await DB().database;
    await db.insert(
      'item',
      {"noteId": id, "title": title},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Item>> all(int id) async {
    final Database db = await DB().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'item',
      where: "noteId = ?",
      whereArgs: [id],
      orderBy: 'completed ASC'
    );
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        noteId: maps[i]['noteId'],
        text: maps[i]['title'],
        completed: maps[i]['completed'] == 1
      );
    });
  }

  static Future<void> delete(int id) async {
    final db = await DB().database;
    await db.delete(
      'item',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<void> toggleComplete(int id, bool completed) async {
    final db = await DB().database;
    var values = <String, dynamic>{
      "completed": !completed,
    };
    await db.update("item", values, where: "id=?", whereArgs: [id]);
  }
}