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
      CREATE TABLE User(id INTEGER PRIMARY KEY, user_id TEXT NOT NULL, password TEXT NOT NULL, nick_name TEXT NOT NULL UNIQUE, shorten_introducing TEXT, created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL)
    ''');

    db.execute('''
     CREATE TABLE Memo(
      id INTEGER PRIMARY KEY,
      user_id INTEGER NOT NULL,
      title TEXT,
      content TEXT,
      password TEXT,
      is_private INTEGER NOT NULL,
      created_at DATETIME NOT NULL,
      updated_at DATETIME NOT NULL,
      FOREIGN KEY(user_id) REFERENCES User(id))
  ''');
  }

  FutureOr<void> _upgradeDb(Database db, int oldVersion, int newVersion) {}

  Future<bool> insertUser(User user) async {
    final db = await database;

    try {
      await db.insert(
        "User",
        user.toJson(),
      );
      return true;
    } catch (e) {
      print('insertUser 에러::::${e.toString()}');
    }
    return false;
  }

  Future<Map<String, dynamic>?>? fetchUser(
      {required String userId, required String password}) async {
    final db = await database;
    try {
      List<Map<String, Object?>> results = await db.query("User",
          where: "user_id = ? and password = ?", whereArgs: [userId, password]);
      // 결과가 있다면 첫 번째 사용자 반환, 없다면 null 반환
      print('results:::${results.length}');
      if (results.isNotEmpty) {
        return results.first;
      } else {
        return null;
      }
    } catch (e) {
      print('fetch User 에러:::${e.toString()}');
    }
    return null;
  }

  Future<bool> insertMemo(Memo memo) async {
    final db = await database;

    try {
      await db.insert(
        "Memo",
        memo.toJson(),
      );
      return true;
    } catch (e) {
      print('insertMemo 에러::::${e.toString()}');
    }
    return false;
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
