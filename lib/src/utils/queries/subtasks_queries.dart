import 'package:tachkil/src/models/subtask_model.dart';
import 'package:tachkil/src/utils/database_helper.dart';

class SubtasksQueries {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // add subtask
  Future<int> insert(SubtaskModel subtaskModel) async {
    final bd = await _dbHelper.database;

    int rep = await bd.insert("subtasks", subtaskModel.toMap());
    return rep;
  }

  // display all tasks
  Future<List<SubtaskModel>> select(int taskId) async {
    final bd = await _dbHelper.database;

    List<Map<String, Object?>> subtaskMaps = await bd.query(
      "subtasks",
      where: "taskId = ?",
      whereArgs: [taskId],
      orderBy: "substatut ASC, subtaskId DESC",
    );

    List<SubtaskModel> subtaskModels = [];
    for (Map<String, Object?> subtaskMap in subtaskMaps) {
      subtaskModels.add(
        SubtaskModel(
          subtaskId: subtaskMap["subtaskId"] as int,
          title: subtaskMap["title"] as String,
          substatut: subtaskMap["substatut"] as int,
          taskId: subtaskMap["taskId"] as int,
        ),
      );
    }
    return subtaskModels;
  }

  // update subtask
  Future<int> update(SubtaskModel subtaskModel) async {
    final bd = await _dbHelper.database;

    int rep = await bd.update(
      "subtasks",
      subtaskModel.toMap(),
      where: "subtaskId = ?",
      whereArgs: [subtaskModel.subtaskId],
    );

    return rep;
  }

  // delete the subtask
  Future<int> delete(int subtaskId) async {
    final db = await _dbHelper.database;

    int rep = await db.delete(
      'subtasks',
      where: "subtaskId = ?",
      whereArgs: [subtaskId],
    );

    return rep;
  }

  Future<int> toggleSubtaskStatut(int subtaskId, int statut) async {
    final db = await _dbHelper.database;

    Map<String, Object?> values = {"substatut": statut};

    int rep = await db.update(
      "subtasks",
      values,
      where: "subtaskId = ?",
      whereArgs: [subtaskId],
    );

    return rep;
  }
}
