class TaskModel {
  final String title;
  final String? description;
  final String? location;
  final DateTime date;
  int statut;

  TaskModel({
    required this.title,
    required this.date,
    this.description,
    this.location,
    required this.statut,
  });
}


/*

statut

-1 : late
0 : in progress
1: finish

*/

