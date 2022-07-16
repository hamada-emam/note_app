import 'package:flutter/cupertino.dart';
import 'package:noteapp/ui/components/managers/conestants_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/task.dart';

class DBHelper {
  DBHelper();
  // create instance from DB
  static Database? _db;
  // set the version of DB
  static const int _version = 1;
  // set table name of DB
  static const String _tableName = 'tasks';
  // singletone for create one instance of DB
  static Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      debugPrint('database  created');
      return initDb();
    }
  }

  // holding DB path
  static String? _dbPath;
  // get DB filepath
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
    debugPrint("pathcreated => $path");
    // set an instance of DB
    Database ourDb = await openDatabase(
      path,
      version: _version,
      // starting create DB
      onCreate: (Database db, int version) async {
        // When creating the DB, create the table columns
        await db.execute('''
        CREATE TABLE $_tableName (
        $DBNamesConstants.columnId $DBNamesConstants.idType,
        $DBNamesConstants.columnTitle $DBNamesConstants.textType,
        $DBNamesConstants.columnNote $DBNamesConstants.textType, 
        $DBNamesConstants.columnDate $DBNamesConstants.textType,
        $DBNamesConstants.columnStartTime $DBNamesConstants.textType,
        $DBNamesConstants.columnEndTime $DBNamesConstants.textType, 
        $DBNamesConstants.columnColor $DBNamesConstants.integerType,
        $DBNamesConstants.columnStatus $DBNamesConstants.textType,
        $DBNamesConstants.columnRemind $DBNamesConstants.integerType,
        $DBNamesConstants.columnRepeat $DBNamesConstants.textType)
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
