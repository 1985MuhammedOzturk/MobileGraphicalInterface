import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDao {
  static final TodoDao instance = TodoDao._init();

  static Database? _database;

  TodoDao._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE if not exists todos ( 
  id $idType, 
  title $textType
  )
''');
  }

  Future<void> insertTodoItem(Map<String, dynamic> todo) async {
    final db = await instance.database;
    await db.insert('todos', todo);
  }

  Future<List<Map<String, dynamic>>> fetchTodoItems() async {
    final db = await instance.database;
    final result = await db.query('todos');
    return result;
  }

  Future<void> deleteTodoItem(int id) async {
    final db = await instance.database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
