import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StorageService {
  // Patrón Singleton para evitar abrir múltiples conexiones a la BD
  static final StorageService instance = StorageService._init();
  static Database? _database;

  StorageService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_persistence.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Tabla simple para guardar la configuración del Workspace
    await db.execute('''
      CREATE TABLE workspace (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT NOT NULL
      )
    ''');
  }

  ///FUncion que me permite guardar la URL
  Future<void> saveWorkspace(String url) async {
    final db = await instance.database;
    await db.delete('workspace');
    await db.insert('workspace', {'url': url});
  }

  /// Recupera la URL guardada. Retorna null si es la primera vez.
  Future<String?> getWorkspace() async {
    final db = await instance.database;
    final maps = await db.query('workspace');

    if (maps.isNotEmpty) {
      return maps.first['url'] as String;
    }
    return null;
  }
}
