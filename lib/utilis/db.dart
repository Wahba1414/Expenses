import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import './../models/expenses.dart';
import './../models/category.dart';
import './../models/fliters.dart';

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

    String path = join(documentsDirectory.path, "Expenses_t_3.db");

    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      // Expenses Table
      await db.execute("CREATE TABLE Expenses ("
          "id TEXT PRIMARY KEY,"
          "title TEXT,"
          "amount TEXT,"
          "category TEXT,"
          "date TEXT,"
          "mood TEXT"
          ")");
      // Category Table.
      await db.execute("CREATE TABLE Categories ("
          "id TEXT PRIMARY KEY,"
          "title TEXT,"
          "color TEXT"
          ")");
    });
  }

  newExpenses(Expenses newItem) async {
    final db = await database;
    //get the biggest id in the table

    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Expenses (id,title,amount,category,date,mood)"
        " VALUES (?,?,?,?,?,?)",
        [
          newItem.id,
          newItem.title,
          newItem.amount,
          newItem.category,
          newItem.date.toString(),
          newItem.mood
        ]);
    return raw;
  }

  Future<List<Expenses>> getExpenses(AppFilters filters) async {
    print('filters.category:${filters.category}');

    final db = await database;
    List<Map<String, dynamic>> res;

    if (filters.category == null) {
      res = await db.query("Expenses");
    } else {
      res = await db.query("Expenses",
          where: 'category = ?', whereArgs: [filters.category]);
    }

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

  // Categories CRUD.
  Future<dynamic> newCategory(AppCategoryModel newItem) async {
    final db = await database;
    //get the biggest id in the table

    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Categories (id,title,color)"
        " VALUES (?,?,?)",
        [
          newItem.id,
          newItem.title,
          newItem.color,
        ]);
    return raw;
  }

  Future<List<AppCategoryModel>> getAllCategories() async {
    final db = await database;
    var res = await db.query("Categories");
    // temporary.
    List<AppCategoryModel> list = res.isNotEmpty
        ? res.map((c) => AppCategoryModel.fromMap(c)).toList()
        : [];
    return list;
  }

  updateExpenses(String oldCategoryName, String newCategoryName) async {
    // print('oldCategoryName:$oldCategoryName');
    // print('newCategoryName:$newCategoryName');
    final db = await database;
    var res = await db.rawUpdate('''
    UPDATE Expenses 
    SET category = ?
    WHERE category = ?
    ''', [newCategoryName, oldCategoryName]);
    return res;
  }

  deleteCategory(AppCategoryModel category) async {
    final db = await database;
    await db.delete("Categories", where: "id = ?", whereArgs: [category.id]);

    // Update all Expenses to unCategroized items.
    await updateExpenses(category.title, 'Uncategorized');
  }
}
