import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/todo_model.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._internal();
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), "todos.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            totalSeconds INTEGER,
            remainingSeconds INTEGER,
            status TEXT,
            startTimestamp INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertTodo(TodoModel todo) async {
    final db = await database;
    return await db.insert("todos", todo.toMap());
  }

  Future<List<TodoModel>> getTodos() async {
    final db = await database;
    final result = await db.query("todos");
    return result.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<int> updateTodo(TodoModel todo) async {
    final db = await database;
    return await db.update(
      "todos",
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete("todos", where: "id = ?", whereArgs: [id]);
  }
}
