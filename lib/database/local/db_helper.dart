import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/task.dart';
import '../../shard_alongapp/components_reused/constants.dart';

class DBHelper {
  DBHelper();

  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      print('database  created');
      return initDb();
    }
  }

  static String? _dbPath;

  static Future<String> get databaseFilepath async {
    if (_dbPath != null) {
      return _dbPath!;
    } else {
      return await getDatabasesPath();
    }
  }

//that's initialize data base
  static Future<Database> initDb() async {
    //if it already here just tell me
    // Get a location using getDatabasesPath
    String path = join(await databaseFilepath, 'task.db');
    debugPrint("path $path");
    Database ourDb = await openDatabase(
      path,
      version: _version,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table columns
        await db.execute('''
        CREATE TABLE $_tableName (
        $columnId $idType,
        $columnTitle $textType,
        $columnNote $textType, 
        $columnDate $textType,
        $columnStartTime $textType,
        $columnEndTime $textType, 
        $columnColor $integerType,
        $columnStatus $textType,
        $columnRemind $integerType,
        $columnRepeat $textType)
         ''');
        debugPrint("database created $_db => $_tableName");
      },
    );
    return ourDb;
  }

  static Future<int> insertToDtaBase(Task? task) async {
    var db = await database;
    //debugPrint("inserted ${task?.id}");
    return await db.insert(_tableName, task!.toJson());
  }

  static delete(int? id) async {
    var db = await database;

    await db.delete(_tableName, where: ' id = ? ', whereArgs: [id]);
  }

  static deleteFrom(String? status) async {
    var db = await database;

    await db.delete(_tableName, where: ' status = ? ', whereArgs: [status]);
  }

  static deleteAll() async {
    var db = await database;

    // debugPrint("deleted All tasks ${await db.delete(_tableName)}");
    await db.delete(_tableName);
  }

  Future<List<Map<String, dynamic>>> query() async {
    var db = await database;
    return await db.rawQuery('SELECT * FROM tasks');
  }

  static Future<int> update({required int id, String x = 'new'}) async {
    var db = await database;
    debugPrint("updated==>  $id");
    return await db.rawUpdate('''
    UPDATE tasks
    SET status = ?
    WHERE id = ?
    ''', [x, id]);
  }

  static Future<int> updateNote({required int id, String? x}) async {
    var db = await database;
    debugPrint("updated==>  $id");
    return await db.rawUpdate('''
    UPDATE tasks
    SET note = ?
    WHERE id = ?
    ''', [x, id]);
  }
}
