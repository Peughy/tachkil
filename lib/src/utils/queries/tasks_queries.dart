import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/utils/database_helper.dart';

class TasksQueries {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Priority getPriority(int numPriority) {
    Priority priority = Priority.medium;

    switch (numPriority) {
      case 1000:
        priority = Priority.high;
        break;
      case 100:
        priority = Priority.medium;
        break;
      case 10:
        priority = Priority.low;
        break;
    }

    return priority;
  }

  // add task
  Future<int> insert(TaskModel taskModel) async {
    final bd = await _dbHelper.getDBInstance();

    int rep = await bd.insert("tasks", taskModel.toMap());
    _dbHelper.closeDb();
    return rep;
  }

  // display all tasks
  Future<List<TaskModel>> select(int userId) async {
    final bd = await _dbHelper.getDBInstance();

    List<Map<String, Object?>> taskMaps = await bd.query(
      "tasks",
      where: "userId = ?",
      whereArgs: [userId],
      orderBy: "statut ASC, priority DESC, date ASC",
    );

    List<TaskModel> taskModels = [];
    for (Map<String, Object?> taskMap in taskMaps) {
      taskModels.add(
        TaskModel(
          taskId: taskMap["taskId"] as int,
          title: taskMap["title"] as String,
          description: taskMap["description"] as String,
          color: taskMap["color"] as int,
          priority: getPriority(taskMap["priority"] as int),
          date: DateTime.parse(taskMap["date"] as String),
          statut: taskMap["statut"] as int,
          userId: taskMap["userId"] as int,
        ),
      );
    }

    _dbHelper.closeDb();
    return taskModels;
  }

  // update task
  Future<int> update(TaskModel taskModel) async {
    final bd = await _dbHelper.getDBInstance();

    int rep = await bd.update(
      "tasks",
      taskModel.toMap(),
      where: "taskId = ?",
      whereArgs: [taskModel.taskId],
    );

    _dbHelper.closeDb();
    return rep;
  }

  // delete the task
  Future<int> delete(int taskId) async {
    final db = await _dbHelper.getDBInstance();

    int rep = await db.delete(
      'tasks',
      where: "taskId = ?",
      whereArgs: [taskId],
    );

    _dbHelper.closeDb();
    return rep;
  }

  Future<int> tooggleStatut(int taskId, int statut) async {
    final db = await _dbHelper.getDBInstance();

    Map<String, Object?> values = {"statut": statut};

    int rep = await db.update(
      "tasks",
      values,
      where: "taskId = ?",
      whereArgs: [taskId],
    );

    _dbHelper.closeDb();
    return rep;
  }
}
