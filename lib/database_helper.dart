import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'cat_model.dart'; // Import โดยตรงจากโฟลเดอร์เดียวกัน

class CatDatabase {
  static final CatDatabase instance = CatDatabase._init();
  static Database? _database;
  CatDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cats_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLS cats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age TEXT,
        weight TEXT,
        vaccines TEXT,
        appointments TEXT
      )
    ''');
  }

  Future<int> create(Cat cat) async {
    final db = await instance.database;
    return await db.insert('cats', cat.toMap());
  }

  Future<List<Cat>> readAllCats() async {
    final db = await instance.database;
    final result = await db.query('cats');
    return result.map((json) => Cat.fromMap(json)).toList();
  }

  Future<int> update(Cat cat) async {
    final db = await instance.database;
    return db.update('cats', cat.toMap(), where: 'id = ?', whereArgs: [cat.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('cats', where: 'id = ?', whereArgs: [id]);
  }
}