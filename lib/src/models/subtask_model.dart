class SubtaskModel {
  int subtaskId;
  String title;
  int substatut;
  int taskId;

  SubtaskModel({
    required this.subtaskId,
    required this.title,
    required this.substatut,
    required this.taskId,
  });

  // convert the SubtaskModel object in Map object
  Map<String, dynamic> toMap() {
    return {
      "subtaskId": subtaskId,
      "title": title,
      "substatut": substatut,
      "taskId": taskId,
    };
  }
}


/*

statut

-1 : late
0 : in progress
1: finish

*/




