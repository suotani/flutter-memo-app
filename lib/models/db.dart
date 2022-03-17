import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DB {

  Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) async{
        await db.execute(
          """
            CREATE TABLE note(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT
            )
          """
        );
        await db.execute(
          """
            CREATE TABLE item(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              noteId INTEGER,
              completed INTEGER DEFAULT 0,
              title TEXT
            );
          """
        );
      },
      // onUpgrade: (Database db, int oldVersion, int newVersion) async {
      //   await db.execute("ALTER TABLE item ADD COLUMN completed INTEGER);");
      // },
      version: 1,
    );
    return _database;
  }
}