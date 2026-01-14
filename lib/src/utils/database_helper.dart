import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
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

  // the method instance whiche init the instanec if is the first time
  Database? _dbInstance;

  Future<Database> getDBInstance() async {
    // ??= is the operator who defined the _dbInstance value is _dbInstanec isn't null
    // and init if is null
    return _initDb();
  }

  Future closeDb() async {
    if (_dbInstance != null) {
      await _dbInstance!.close();
    }
  }
}
