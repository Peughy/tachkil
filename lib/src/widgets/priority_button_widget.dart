import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/priority_button_model.dart';
import 'package:tachkil/src/utils/constant.dart';

class PriorityButtonWidget extends StatelessWidget {
  final bool activeDarkTheme;
  final PriorityButtonModel priorityButtonModel;
  const PriorityButtonWidget({
    super.key,
    required this.priorityButtonModel,
    required this.activeDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: activeDarkTheme ? Colors.white24 : dartColor,
          width: priorityButtonModel.isSelected ? 1 : 1.5,
        ),
        color: priorityButtonModel.isSelected
            ? Colors.red
            : Colors.transparent,
      ),
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            priorityButtonModel.text,
            style: GoogleFonts.openSans(
              fontSize: 15,
              fontWeight: priorityButtonModel.isSelected
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: activeDarkTheme
                  ? (priorityButtonModel.isSelected)
                        ? dartColor
                        : whiteColor
                  : (priorityButtonModel.isSelected)
                  ? whiteColor
                  : dartColor,
            ),
          ),
          if (priorityButtonModel.isSelected)
            Icon(
              FontAwesomeIcons.check,
              size: 16,
              color: activeDarkTheme ? dartColor : whiteColor,
            ),
        ],
      ),
    );
  }
}
