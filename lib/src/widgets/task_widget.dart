import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/utils/constant.dart';

class TaskWidget extends StatefulWidget {
  final TaskModel taskModel;
  const TaskWidget({super.key, required this.taskModel});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  String addZeros(int nbr) {
    return nbr < 10 ? '0$nbr' : "$nbr";
  }

  String displayMonth(int month) {
    List<String> months = [
      'Jan',
      'Fev',
      'Mar',
      'Avr',
      'Mai',
      'Jui',
      'Juil',
      'Au',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

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
            onTap: (){
              if(widget.taskModel.statut == 0){
                setState(() {
                  widget.taskModel.statut = 1;
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
                  "${addZeros(widget.taskModel.time.day)} ${displayMonth(widget.taskModel.time.month)} ${widget.taskModel.time.year} ${addZeros(widget.taskModel.time.hour)}:${addZeros(widget.taskModel.time.minute)}",
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
