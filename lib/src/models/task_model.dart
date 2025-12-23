class TaskModel {
  final int taskId;
  final String title;
  final String? description;
  final String? location;
  final DateTime date;
  int statut;

  TaskModel({
    required this.taskId,
    required this.title,
    required this.date,
    this.description,
    this.location,
    required this.statut,
  });

  // convert the TaskModel object in Map object
  Map<String, dynamic> toMap() {
    return {
      "taskId": taskId,
      "title": title,
      "description": description,
      "location": location,
      "statut": statut,
      "date": date,
    };
  }
}


/*

statut

-1 : late
0 : in progress
1: finish

*/

