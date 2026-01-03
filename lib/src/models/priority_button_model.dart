import 'package:tachkil/src/models/task_model.dart';

class PriorityButtonModel {
  final String text;
  bool isSelected;
  Priority priority;

  PriorityButtonModel({
    required this.text,
    required this.isSelected,
    required this.priority,
  });
}
