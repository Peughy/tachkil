enum Priority { high, medium, low }

class TaskModel {
  int taskId;
  String title;
  String? description;
  int color;
  Priority priority;
  int statut;
  DateTime date;
  int userId;

  TaskModel({
    required this.taskId,
    required this.title,
    this.description,
    required this.color,
    required this.priority,
    required this.statut,
    required this.date,
    required this.userId,
  });

  TaskModel copyWithTask({
    required int taskId,
    required DateTime date,
    required TaskModel taskModel,
  }) {
    return TaskModel(
      taskId: taskId,
      title: taskModel.title,
      description: taskModel.description,
      color: taskModel.color,
      priority: taskModel.priority,
      statut: taskModel.statut,
      date: date,
      userId: taskModel.userId,
    );
  }

  // convert the TaskModel object in Map object
  Map<String, dynamic> toMap() {
    return {
      "taskId": taskId,
      "title": title,
      "description": description,
      "color": color,
      "priority": getPriorityNumber(priority),
      "date": date.toString(),
      "statut": statut,
      "userId": userId,
    };
  }

  int getPriorityNumber(Priority priority) {
    int numPriority;
    switch (priority) {
      case Priority.high:
        numPriority = 1000;
        break;
      case Priority.medium:
        numPriority = 100;
        break;
      case Priority.low:
        numPriority = 10;
        break;
    }

    return numPriority;
  }
}


/*

statut

-1 : late
0 : in progress
1: finish

*/



