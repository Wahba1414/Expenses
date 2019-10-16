import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import './../models/expenses.dart';

class DBProvider {
  DBProvider._();

  // Make the whole class is static. 
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "Expenses.db");

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Expenses ("
          "id TEXT PRIMARY KEY,"
          "title TEXT,"
          "amount TEXT,"
          "category TEXT,"
          "date TEXT"
          ")");
    });
  }

  newExpenses(Expenses newItem) async {
    final db = await database;
    //get the biggest id in the table
    
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Expenses (id,title,amount,category,date)"
        " VALUES (?,?,?,?,?)",
        [newItem.id, newItem.title, newItem.amount, newItem.category, newItem.date.toString()]);
    return raw;
  }

  

  Future<List<Expenses>> getAllExpenses() async {
    final db = await database;
    var res = await db.query("Expenses");
    // temporary.
    // print('results from db');
    // print(res);
    List<Expenses> list =
        res.isNotEmpty ? res.map((c) => Expenses.fromMap(c)).toList() : [];
    return list;
  }

  deleteExpenses(String id) async {
    final db = await database;
    return db.delete("Expenses", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Expenses");
  }
}
