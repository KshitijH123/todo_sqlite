import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_sqlite/database/todo_db.dart'; 

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'tado.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _create, 
      singleInstance: true,
    );
    return database;
  }

  Future<void> _create(Database database, int version) async {
    await TodoDb().createTable(database); 
  }
}
