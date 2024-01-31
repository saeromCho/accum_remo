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

  Future<void> saveMemo(Memo memo) async {
    if (memo.id == null) {
      // 새 메모 (id가 없음)
      await insertMemo(memo);
    } else {
      // 기존 메모 업데이트
      await updateMemo(memo);
    }
  }

  Future<int> insertMemo(Memo memo) async {
    final db = await database;

    try {
      final memoId = await db.insert(
        "Memo",
        memo.toJson(),
      );
      return memoId;
    } catch (e) {
      print('insertMemo 에러::::${e.toString()}');
    }
    return -1;
  }

  Future<void> updateMemo(Memo memo) async {
    final db = await database;
    await db.update(
      'Memo',
      memo.toJson(),
      where: 'id = ?',
      whereArgs: [memo.id],
    );
  }

  Future<void> deleteMemo(int memoId) async {
    final db = await database;
    await db.delete("Memo", where: "id = ?", whereArgs: [memoId]);
  }

  Future<Map<String, dynamic>?>? fetchMemo({required int memoId}) async {
    final db = await database;
    try {
      List<Map<String, Object?>> results =
          await db.query("Memo", where: "id = ?", whereArgs: [memoId]);
      if (results.isNotEmpty) {
        return results.first;
      } else {
        return null;
      }
    } catch (e) {
      print('fetch Memo 에러:::${e.toString()}');
    }
    return null;
  }

  Future<List<Memo>> fetchMemos() async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query("Memo", orderBy: "updated_at DESC");

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
