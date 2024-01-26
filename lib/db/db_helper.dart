import 'dart:async';

import 'package:local_db_sqlite/model/memo.dart';
import 'package:local_db_sqlite/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await initDB();
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'remo.db');

    // return await deleteDatabase(path);
    return await openDatabase(path,
        version: 1, onCreate: _createDb, onUpgrade: _upgradeDb);
  }

  FutureOr<void> _createDb(Database db, int version) {
    db.execute('''
      CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL UNIQUE)
    ''');

    db.execute('''
     CREATE TABLE Memo(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      content TEXT,
      written_at DATETIME NOT NULL,
      FOREIGN KEY(user_id) REFERENCES User(id))
  ''');
  }

  FutureOr<void> _upgradeDb(Database db, int oldVersion, int newVersion) {}

  Future<void> insertUser(User user) async {
    final db = await database;

    await db.insert(
      "User",
      user.toJson(),
    );
  }

  Future<void> insertMemo(Memo memo) async {
    final db = await database;

    await db.insert("Memo", memo.toJson());
  }

  Future<List<Memo>> fetchMemos() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query("Memo");

    List<Memo> memos = [];
    for (int i = 0; i < results.length; i++) {
      Memo memo = Memo.fromJson(results[i]);

      memos.add(memo);
    }

    return memos;
  }

  Future<List<Memo>> fetchUserMemos(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query("Memo", where: "user_id = ?", whereArgs: [userId]);

    List<Memo> memos = [];
    for (int i = 0; i < results.length; i++) {
      Memo memo = Memo.fromJson(results[i]);

      memos.add(memo);
    }
    return memos;
  }

  // Future<User> upsertUser(User user) async {
  //   DBHelper dbHelper = DBHelper();
  //   dbHelper.in(User(id: 1, name: 'Mini', age: 8));
  //
  // }
}
