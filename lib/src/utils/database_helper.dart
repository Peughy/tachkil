import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // init instance
  static DatabaseHelper? _instance;
  static Database? _database;

  // private constructor
  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  final _dbName = "tachkil.db";
  final _dbVersion = 2;

  // when the db is created for the first time
  Future _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE users(userId INTEGER PRIMARY KEY, username TEXT UNIQUE, password TEXT)",
    );

    await db.execute(
      "CREATE TABLE tasks(taskId INTEGER PRIMARY KEY, title TEXT, description TEXT NULL, color INTEGER, priority INTEGER, statut INTEGER DEFAULT 0, date TEXT, userId INTEGER, FOREIGN KEY(userId) REFERENCES users(userId) ON DELETE CASCADE)",
    );

    await db.execute(
      "CREATE TABLE subtasks(subtaskId INTEGER PRIMARY KEY, title TEXT, substatut INTEGER DEFAULT 0,  taskId INTEGER, FOREIGN KEY(taskId) REFERENCES tasks(taskId) ON DELETE CASCADE)",
    );

    // await db.execute(
    //   "CREATE TRIGGER updateStatut BEFORE SELECT ON tasks BEGIN UPDATE tasks SET tasks.statut = -1 WHERE datetime(date) < datetime(\"now\") END; END;",
    // );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Here you can handle database upgrades when changing the version

    for (int version = oldVersion + 1; version <= newVersion; version++) {
      if (version == 2) {
        db.transaction((Transaction transaction) async {
          // Create backup table without UNIQUE constraint
          await transaction.execute(
            "CREATE TABLE tasks_backup(taskId INTEGER PRIMARY KEY, title TEXT, description TEXT NULL, color INTEGER, priority INTEGER, statut INTEGER DEFAULT 0, date TEXT, userId INTEGER, FOREIGN KEY(userId) REFERENCES users(userId) ON DELETE CASCADE)",
          );

          // Insert data into backup table
          await transaction.execute(
            "INSERT INTO tasks_backup SELECT * FROM tasks",
          );

          // Drop original table
          await transaction.execute("DROP TABLE tasks");
          // Rename backup table to original table name
          await transaction.execute("ALTER TABLE tasks_backup RENAME TO tasks");
        });
      }
    }
  }

  String get dbName => _dbName;

  // initialize the db method
  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future closeDb() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
