import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/queries/tasks_queries.dart';

class TaskWidget extends StatefulWidget {
  final TaskModel taskModel;
  final bool activeDarkTheme;
  const TaskWidget({
    super.key,
    required this.taskModel,
    required this.activeDarkTheme,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TasksQueries tasksQueries = TasksQueries();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: widget.activeDarkTheme
              ? widget.taskModel.statut == 1
                    ? Colors.green
                    : widget.taskModel.statut == 0
                    ? whiteColor
                    : mainColor
              : widget.taskModel.statut == 1
              ? Colors.green
              : widget.taskModel.statut == 0
              ? dartColor
              : mainColor,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        spacing: 18,
        children: [
          GestureDetector(
            onTap: () async {
              if (widget.taskModel.statut == 0) {
                // the statut is 1 when the task is complete
                await tasksQueries.tooggleStatut(widget.taskModel.taskId, 1);
                setState(() {
                  widget.taskModel.statut = 1;
                });
              } else if (widget.taskModel.statut == 1) {
                // the statut switch to 0 when the user cancel the task
                await tasksQueries.tooggleStatut(widget.taskModel.taskId, 0);
                setState(() {
                  widget.taskModel.statut = 0;
                });
              }
            },
            child: FaIcon(
              widget.taskModel.statut == 0
                  ? FontAwesomeIcons.circle
                  : widget.taskModel.statut == -1
                  ? FontAwesomeIcons.solidCircleXmark
                  : FontAwesomeIcons.solidCircleCheck,
              size: 24,
              color: widget.activeDarkTheme
                  ? widget.taskModel.statut == 1
                        ? Colors.green
                        : widget.taskModel.statut == 0
                        ? whiteColor
                        : mainColor
                  : widget.taskModel.statut == 1
                  ? Colors.green
                  : widget.taskModel.statut == 0
                  ? dartColor
                  : mainColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.taskModel.title,
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${addZeros(widget.taskModel.date.day)} ${displayMonth(widget.taskModel.date.month)} ${widget.taskModel.date.year} ${addZeros(widget.taskModel.date.hour)}:${addZeros(widget.taskModel.date.minute)}",
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
