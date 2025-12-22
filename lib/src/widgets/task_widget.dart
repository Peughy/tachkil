import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';

class TaskWidget extends StatefulWidget {
  final TaskModel taskModel;
  const TaskWidget({super.key, required this.taskModel});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: widget.taskModel.statut == 1
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
            onTap: () {
              if (widget.taskModel.statut == 0) {
                setState(() {
                  widget.taskModel.statut = 1;
                });
              } else if (widget.taskModel.statut == 1) {
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
              color: widget.taskModel.statut == 1
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
