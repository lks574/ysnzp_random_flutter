import 'dart:async';

import 'package:ysnzp_random_flutter/models/NameModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String cleanTable = 'cleanTable';
  final String columnId = 'id';
  final String columnName = 'name';

  static Database _db;
  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'CLEAN.db');

//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $cleanTable($columnId INTEGER PRIMARY KEY, $columnName TEXT)");
  }

  Future<int> saveNote(NameModel model) async {
    var dbClient = await db;
    var result = await dbClient.insert(cleanTable, model.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableNote ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

    return result;
  }

  Future<List> getAllNameModel() async {
    var dbClient = await db;
    var result = await dbClient.query(cleanTable, columns: [columnId, columnName]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote');

    return result.toList();

  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $cleanTable'));
  }

  Future<NameModel> getNameModel(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(cleanTable,
        columns: [columnId, columnName],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote WHERE $columnId = $id');

    if (result.length > 0) {
      return NameModel.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteNameModel(int id) async {
    var dbClient = await db;
    return await dbClient.delete(cleanTable, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
  }

  Future<int> updateNote(NameModel model) async {
    var dbClient = await db;
    return await dbClient.update(cleanTable, model.toMap(), where: "$columnId = ?", whereArgs: [model.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }


  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

}