import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/task_model.dart';
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
    final Color leadingColor = Color(widget.taskModel.color);
    String priorityText = widget.taskModel.priority == Priority.high
        ? "Haute"
        : widget.taskModel.priority == Priority.medium
        ? "Moyenne"
        : "Basse";

    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.activeDarkTheme ? Colors.black12 : Colors.white38,
        border: Border.all(
          color: leadingColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // leading color bar
          Container(
            height: 120,
            width: 20,
            // height: MediaQuery.of(context).size.height,
            // height: double.maxFinite,
            decoration: BoxDecoration(
              color: leadingColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          SizedBox(width: 12),
          // content
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.taskModel.title,
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    spacing: 12,
                    children: [
                      Text(
                        "Priorités : ",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: leadingColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          priorityText,
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: leadingColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // checkbox
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    if (widget.taskModel.statut == 0) {
                      tasksQueries.tooggleStatut(widget.taskModel.taskId, 1);
                      setState(() {
                        widget.taskModel.statut = 1;
                      });
                    }
                  },
                  icon: Icon(
                    widget.taskModel.statut == 1
                        ? FontAwesomeIcons.solidCircleCheck
                        : FontAwesomeIcons.circle,
                    color: widget.taskModel.statut == 1
                        ? Colors.green
                        : Colors.grey,
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
